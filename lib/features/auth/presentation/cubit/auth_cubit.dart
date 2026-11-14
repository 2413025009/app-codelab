// FILE: lib/features/auth/presentation/cubit/auth_cubit.dart
// TUGAS: state autentikasi UI — dua status (unauthenticated/authenticated) plus data user.
// FUNGSI YANG DIKELOLA: alur login, registrasi, pembaruan profil, restoreSession,
// dan logout — semuanya hanya menyalurkan ke AuthRepository, tanpa logika mock.
// WAJIB DIUBAH BILA: alur sesi berubah (mis. refresh token otomatis pindah ke sini).
import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/network/session_notice.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../notifications/notification_events.dart';
import '../../domain/auth_repository.dart';

enum AuthStatus { unauthenticated, authenticated }

class AuthState extends Equatable {
  const AuthState({this.status = AuthStatus.unauthenticated, this.user});

  final AuthStatus status;
  final AuthUser? user;

  bool get isAuthenticated => status == AuthStatus.authenticated;

  @override
  List<Object?> get props => [status, user];
}

/// App-wide session state. The router listens to it for route guarding.
class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this._repository) : super(const AuthState()) {
    // Minggu 13: sesi tunggal. Ketika server menolak token karena sesinya
    // dicabut (akun dipakai masuk di perangkat lain, logout, atau sandi
    // berubah), lapisan jaringan menitipkan pesan lewat SessionNotice. Cubit
    // mengeluarkan pengguna SEKALI di sini; pesan ditampilkan layar masuk.
    SessionNotice.message.addListener(_handleSessionNotice);
  }

  final AuthRepository _repository;

  /// Bahasa aktif terakhir untuk teks notifikasi sesi (dipasang layar lewat
  /// [setLocalizations]). Notifikasi bisa terjadi saat tidak ada BuildContext.
  AppLocalizations? _lastL10n;

  /// Dipanggil layar (mis. LoginPage/AppShell) agar notifikasi sesi memakai
  /// bahasa aplikasi aktif.
  void setLocalizations(AppLocalizations l10n) => _lastL10n = l10n;

  void _handleSessionNotice() {
    final msg = SessionNotice.message.value;
    if (msg == null) return;
    if (!state.isAuthenticated) return;
    // Minggu 13 (Notifikasi 5): kabari lewat notifikasi HP juga, supaya siswa
    // tahu alasannya walau aplikasi sedang di latar belakang. Teks diambil dari
    // pesan server agar alasannya tepat (perangkat lain / logout / sandi).
    final l10n = _lastL10n;
    unawaited(
      NotificationEvents.sessionRevoked(
        title: l10n?.notifSessionTitle ?? 'Sesi Akun Diakhiri',
        body: l10n?.notifSessionBody ?? msg,
      ),
    );
    emit(const AuthState());
  }

  @override
  Future<void> close() {
    SessionNotice.message.removeListener(_handleSessionNotice);
    return super.close();
  }

  /// Throws [AuthFailure] on bad credentials.
  Future<void> login({required String email, required String password}) async {
    final user = await _repository.login(email: email, password: password);
    emit(AuthState(status: AuthStatus.authenticated, user: user));
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
    String? nisn,
    String? schoolName,
    String? className,
  }) {
    return _repository.register(
      name: name,
      email: email,
      password: password,
      nisn: nisn,
      schoolName: schoolName,
      className: className,
    );
  }

  /// Minggu 9: pendaftaran akun guru berpagar kode sekolah (menyimpan sesi).
  Future<void> registerTeacher({
    required String name,
    required String email,
    required String password,
    required String schoolCode,
  }) {
    return _repository.registerTeacher(
      name: name,
      email: email,
      password: password,
      schoolCode: schoolCode,
    );
  }

  /// Minggu 9: Pengaturan akun (siswa & pengajar) — ganti kata sandi.
  /// Melempar [AuthFailure] bila sandi lama salah / aturan baru lewat.
  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
  }) {
    return _repository.changePassword(
      oldPassword: oldPassword,
      newPassword: newPassword,
    );
  }

  Future<void> updateProfile({
    required String name,
    String? email,
    String? phone,
    String? bio,
    String? schoolName,
    String? className,
    String? nisn,
    String? address,
    String? staffCode,
  }) async {
    final updated = await _repository.updateProfile(
      name: name,
      email: email,
      phone: phone,
      bio: bio,
      schoolName: schoolName,
      className: className,
      nisn: nisn,
      address: address,
      staffCode: staffCode,
    );
    emit(AuthState(status: AuthStatus.authenticated, user: updated));
  }

  Future<void> uploadAvatar({
    required List<int> bytes,
    required String fileName,
  }) async {
    final updated = await _repository.uploadAvatar(
      bytes: bytes,
      fileName: fileName,
    );
    emit(AuthState(status: AuthStatus.authenticated, user: updated));
  }

  Future<void> deleteAvatar() async {
    final updated = await _repository.deleteAvatar();
    emit(AuthState(status: AuthStatus.authenticated, user: updated));
  }

  /// Minggu 14: salinan data pribadi akun (JSON terformat) untuk ditampilkan
  /// dan disalin dari layar Pengaturan.
  Future<String> exportPersonalData() => _repository.exportPersonalData();

  /// Minggu 14: hapus akun permanen. Setelah server mengonfirmasi, sesi lokal
  /// dibersihkan dan pengguna keluar — bukan tetap di layar dengan akun hilang.
  Future<void> deleteAccount({
    required String password,
    required String confirm,
  }) async {
    await _repository.deleteAccount(password: password, confirm: confirm);
    emit(const AuthState());
  }

  void addXp(int xp) {
    final current = state.user;
    if (current == null) return;
    emit(
      AuthState(
        status: state.status,
        user: current.copyWith(xpPoints: current.xpPoints + xp),
      ),
    );
  }

  void setXp(int xp) {
    final current = state.user;
    if (current == null || current.xpPoints == xp) return;
    emit(
      AuthState(
        status: state.status,
        user: current.copyWith(xpPoints: xp),
      ),
    );
  }

  Future<void> logout() async {
    await _repository.logout();
    emit(const AuthState());
  }

  /// Silent restore at startup (Persists login across restarts).
  /// Returns true when a session was restored.
  Future<bool> restoreSession() async {
    final user = await _repository.restoreSession();
    if (user == null) return false;
    emit(AuthState(status: AuthStatus.authenticated, user: user));
    return true;
  }
}
