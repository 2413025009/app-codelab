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
        xpPoints,
        avatarUrl,
      ];
}

enum AuthFailureType { invalidCredentials, emailTaken, network }

class AuthFailure implements Exception {
  const AuthFailure(this.type);
  final AuthFailureType type;

  /// User-facing copy from DESIGN.md §4 (no blame, always a next step).
  String get message => switch (type) {
        AuthFailureType.invalidCredentials => 'Email atau kata sandi belum cocok. Coba periksa lagi.',
        AuthFailureType.emailTaken => 'Email ini sudah punya akun. Mau masuk saja?',
        AuthFailureType.network => 'Belum tersambung ke internet. Coba lagi sebentar.',
      };
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
  Future<AuthUser> updateProfile({
    required String name,
    String? phone,
    String? bio,
    String? schoolName,
    String? className,
    String? nisn,
  });
  Future<void> logout();

  /// Restores a saved session at app startup (null when nobody was logged in).
  Future<AuthUser?> restoreSession();
}
