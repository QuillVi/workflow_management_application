class ApiEndpoints {
  static final String baseUrl = 'http://localhost:3000/api';
  static _AuthEndPoints authEndpoints = _AuthEndPoints();
}

class _AuthEndPoints {
  final String registerEmail = 'authaccount/register';
  final String loginEmail = ' authaccount/login';
}
