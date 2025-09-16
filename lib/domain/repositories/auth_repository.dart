import 'package:noviindus_patients/domain/entities/login_response.dart';

abstract class AuthRepository {
  Future<LoginResponse> login(String username, String password);
}
