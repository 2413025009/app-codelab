/// Route paths. Use these constants instead of string literals.
abstract final class AppRoutes {
  // Auth
  static const login = '/login';
  static const register = '/register';

  // Bottom-navigation tabs (inside the shell)
  static const dashboard = '/dashboard';
  static const challenges = '/challenges';
  static const playground = '/playground';
  static const profile = '/profile';
  static const settings = '/settings';

  // Pushed on top of the shell
  static const catalog = '/catalog';

  static const lessonPattern = '/lesson/:id';
  static String lesson(String id) => '/lesson/$id';

  static const challengePattern = '/challenge/:id';
  static String challenge(String id) => '/challenge/$id';

  static const historyPattern = '/challenge/:id/history';
  static String history(String id) => '/challenge/$id/history';

  /// Full-screen playground with a back button (opened from history / project).
  static const lab = '/lab';
}
