// FILE: lib/features/auth/presentation/cubit/auth_cubit.dart
// TUGAS: state autentikasi UI — dua status (unauthenticated/authenticated) plus data user.
// FUNGSI YANG DIKELOLA: alur login, registrasi, pembaruan profil, restoreSession,
// dan logout — semuanya hanya menyalurkan ke AuthRepository, tanpa logika mock.
// WAJIB DIUBAH BILA: alur sesi berubah (mis. refresh token otomatis pindah ke sini).
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
  AuthCubit(this._repository) : super(const AuthState());

  final AuthRepository _repository;

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

  Future<void> updateProfile({
    required String name,
    String? phone,
    String? bio,
    String? schoolName,
    String? className,
    String? nisn,
  }) async {
    final updated = await _repository.updateProfile(
      name: name,
      phone: phone,
      bio: bio,
      schoolName: schoolName,
      className: className,
      nisn: nisn,
    );
    emit(AuthState(status: AuthStatus.authenticated, user: updated));
  }

  void addXp(int xp) {
    final current = state.user;
    if (current == null) return;
    emit(AuthState(
      status: state.status,
      user: current.copyWith(xpPoints: current.xpPoints + xp),
    ));
  }

  void setXp(int xp) {
    final current = state.user;
    if (current == null) return;
    emit(AuthState(
      status: state.status,
      user: current.copyWith(xpPoints: xp),
    ));
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
