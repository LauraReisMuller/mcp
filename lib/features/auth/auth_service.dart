class AuthService {
  static final AuthService instance = AuthService._internal();
  final Map<String, String> _users = {};
  String? _currentUser;

  AuthService._internal();

  Future<bool> login(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 500));
    if (_users[email] == password) {
      _currentUser = email;
      return true;
    }
    return false;
  }

  Future<bool> signup(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 500));
    if (_users.containsKey(email)) {
      return false;
    }
    _users[email] = password;
    return true;
  }

  void logout() {
    _currentUser = null;
  }

  String? get currentUser => _currentUser;
}
