import '../domain/auth_repository.dart';

/// In-memory auth used until the backend is connected.
/// Seeded with a demo student matching Stitch v2 design; accounts created via register work for login.
class MockAuthRepository implements AuthRepository {
  MockAuthRepository() {
    _accounts['farhan@smk.belajar.id'] = const _Account(
      user: AuthUser(
        name: 'Muhammad Farhan',
        email: 'farhan@smk.belajar.id',
        role: 'student',
        nisn: '0072918402',
        schoolName: 'SMKN 1 Jakarta',
        className: 'Kelas X RPL 2',
        phone: '+62 812-3456-7890',
        bio: 'Fokus belajar logika pemrograman Python dan Web Dasar untuk persiapan magang industri.',
        xpPoints: 480,
      ),
      password: 'rahasia123',
    );
  }

  final Map<String, _Account> _accounts = {};
  String? _currentEmail;

  static const _latency = Duration(milliseconds: 500);

  @override
  Future<AuthUser> login({required String email, required String password}) async {
    await Future<void>.delayed(_latency);
    final account = _accounts[email.trim().toLowerCase()];
    if (account == null || account.password != password) {
      throw const AuthFailure(AuthFailureType.invalidCredentials);
    }
    _currentEmail = account.user.email;
    return account.user;
  }

  @override
  Future<void> register({
    required String name,
    required String email,
    required String password,
    String? nisn,
    String? schoolName,
    String? className,
  }) async {
    await Future<void>.delayed(_latency);
    final key = email.trim().toLowerCase();
    if (_accounts.containsKey(key)) throw const AuthFailure(AuthFailureType.emailTaken);
    _accounts[key] = _Account(
      user: AuthUser(
        name: name.trim(),
        email: key,
        nisn: nisn ?? '0072918402',
        schoolName: schoolName ?? 'SMKN 1 Jakarta',
        className: className ?? 'Kelas X RPL 2',
        phone: '+62 812-3456-7890',
        bio: 'Fokus belajar logika pemrograman Python dan Web Dasar.',
        xpPoints: 100,
      ),
      password: password,
    );
  }

  @override
  Future<AuthUser> updateProfile({
    required String name,
    String? phone,
    String? bio,
    String? schoolName,
    String? className,
    String? nisn,
  }) async {
    await Future<void>.delayed(_latency);
    final email = _currentEmail ?? 'farhan@smk.belajar.id';
    final account = _accounts[email];
    if (account == null) {
      throw const AuthFailure(AuthFailureType.invalidCredentials);
    }

    final updated = account.user.copyWith(
      name: name.trim(),
      phone: phone,
      bio: bio,
      schoolName: schoolName,
      className: className,
      nisn: nisn,
    );
    _accounts[email] = _Account(user: updated, password: account.password);
    return updated;
  }

  @override
  Future<void> logout() async {
    _currentEmail = null;
  }

  @override
  Future<AuthUser?> restoreSession() async => null; // Demo tidak persisten.
}

class _Account {
  const _Account({required this.user, required this.password});
  final AuthUser user;
  final String password;
}
