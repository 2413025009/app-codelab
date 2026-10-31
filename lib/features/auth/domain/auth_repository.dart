import 'package:equatable/equatable.dart';

class AuthUser extends Equatable {
  const AuthUser({
    required this.name,
    required this.email,
    this.role = 'student',
    this.nisn,
    this.schoolName,
    this.className,
    this.phone,
    this.bio,
    this.address,
    this.staffCode,
    this.xpPoints = 0,
    this.avatarUrl,
  });

  final String name;
  final String email;
  final String role;
  final String? nisn;
  final String? schoolName;
  final String? className;
  final String? phone;
  final String? bio;
  final String? address;
  final String? staffCode;
  final int xpPoints;
  final String? avatarUrl;

  AuthUser copyWith({
    String? name,
    String? email,
    String? role,
    String? nisn,
    String? schoolName,
    String? className,
    String? phone,
    String? bio,
    String? address,
    String? staffCode,
    int? xpPoints,
    String? avatarUrl,
  }) {
    return AuthUser(
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      nisn: nisn ?? this.nisn,
      schoolName: schoolName ?? this.schoolName,
      className: className ?? this.className,
      phone: phone ?? this.phone,
      bio: bio ?? this.bio,
      address: address ?? this.address,
      staffCode: staffCode ?? this.staffCode,
      xpPoints: xpPoints ?? this.xpPoints,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }

  @override
  List<Object?> get props => [
    name,
    email,
    role,
    nisn,
    schoolName,
    className,
    phone,
    bio,
    address,
    staffCode,
    xpPoints,
    avatarUrl,
  ];
}

enum AuthFailureType {
  invalidCredentials,
  emailTaken,
  network,
  schoolCodeNotFound,
  // Minggu 9: perubahan kata sandi (Pengaturan).
  wrongOldPassword,
  passwordPolicy,
  // Foto profil: berkas ditolak server (format/ukuran) atau gagal diunggah.
  avatarUpload,
  // Email akun tidak memakai domain @smk.belajar.id.
  emailDomain,
  // Isian lain ditolak server (mis. bio terlalu panjang) — bukan email.
  invalidInput,
  // Server menjawab tetapi sedang bermasalah (5xx) — jangan disebut offline.
  server,
}

class AuthFailure implements Exception {
  const AuthFailure(this.type, {this.detail});

  final AuthFailureType type;

  /// Pesan tambahan dari server (mis. nama kolom yang belum sesuai).
  final String? detail;

  /// User-facing copy from DESIGN.md §4 (no blame, always a next step).
  String get message => detail ?? switch (type) {
    AuthFailureType.invalidCredentials =>
      'Email atau kata sandi belum cocok. Coba periksa lagi.',
    AuthFailureType.emailTaken => 'Email ini sudah punya akun. Mau masuk saja?',
    AuthFailureType.network =>
      'Belum tersambung ke internet. Coba lagi sebentar.',
    AuthFailureType.schoolCodeNotFound =>
      'Kode sekolah tidak ditemukan. Silakan hubungi admin sekolahmu.',
    AuthFailureType.wrongOldPassword =>
      'Kata sandi lama belum cocok. Coba periksa lagi.',
    AuthFailureType.passwordPolicy =>
      'Kata sandi baru belum memenuhi aturan (minimal 8 karakter, ada angka atau simbol).',
    AuthFailureType.avatarUpload =>
      'Foto profil belum bisa diunggah. Gunakan JPG atau PNG maksimal 2 MB.',
    AuthFailureType.emailDomain =>
      'Email harus memakai domain @smk.belajar.id.',
    AuthFailureType.invalidInput =>
      'Ada isian yang belum sesuai. Periksa kembali lalu simpan lagi.',
    AuthFailureType.server =>
      'Server sedang bermasalah. Coba lagi beberapa saat lagi.',
  };
}

/// Kartu verifikasi sekolah read-only hasil pencocokan kode resmi
/// (Minggu 9 — PROMPT.md Bagian 3: RegisterRoleSchoolSection).
class VerifiedSchool extends Equatable {
  const VerifiedSchool({
    required this.schoolCode,
    required this.name,
    required this.address,
  });

  final String schoolCode;
  final String name;
  final String address;

  @override
  List<Object?> get props => [schoolCode, name, address];
}

/// Contract for authentication. The mock implementation is swapped for an
/// API-backed one (POST /api/v1/auth/*, PUT /api/v1/me) when connected to backend.
abstract interface class AuthRepository {
  Future<AuthUser> login({required String email, required String password});
  Future<void> register({
    required String name,
    required String email,
    required String password,
    String? nisn,
    String? schoolName,
    String? className,
  });

  /// Minggu 9: pendaftaran akun guru berpagar kode sekolah resmi.
  Future<void> registerTeacher({
    required String name,
    required String email,
    required String password,
    required String schoolCode,
  });

  /// Minggu 9: kartu verifikasi sekolah read-only dari kode resmi.
  Future<VerifiedSchool> verifySchool({required String schoolCode});

  /// Minggu 9: Pengaturan akun (siswa & pengajar) — ganti kata sandi.
  /// Wajib tahu sandi lama; aturan sandi baru sama seperti registrasi.
  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
  });
  Future<AuthUser> updateProfile({
    required String name,
    String? email,
    String? phone,
    String? bio,
    String? schoolName,
    String? className,
    String? nisn,
    String? address,
    String? staffCode,
  });

  /// Unggah/ganti foto profil. Server mengembalikan profil terbaru.
  Future<AuthUser> uploadAvatar({
    required List<int> bytes,
    required String fileName,
  });

  /// Hapus foto profil lalu kembalikan profil tanpa avatar.
  Future<AuthUser> deleteAvatar();

  Future<void> logout();

  /// Restores a saved session at app startup (null when nobody was logged in).
  Future<AuthUser?> restoreSession();
}
