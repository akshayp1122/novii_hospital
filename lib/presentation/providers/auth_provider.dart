import 'package:flutter/foundation.dart';
import '../../data/repositories/auth_repository_impl.dart';

class AuthProvider with ChangeNotifier {
  final AuthRepositoryImpl _repository = AuthRepositoryImpl();

  bool _loading = false;
  String? _token;
  String? _error;

  bool get loading => _loading;
  String? get token => _token;
  String? get error => _error;

  Future<void> login(String username, String password) async {
    if (username.isEmpty || password.isEmpty) {
      _error = "Username and password cannot be empty";
      notifyListeners();
      return;
    }

    _loading = true;
    _error = null;
    notifyListeners();

    try {
      final resultToken = await _repository.login(username, password);
      _token = resultToken;
      print("✅ Login success, token: $_token");
    } catch (e) {
      _error = e.toString();
      print("❌ Login error: $_error");
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}
