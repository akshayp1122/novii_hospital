import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepositoryImpl {
  final String baseUrl = "https://flutter-amr.noviindus.in/api/";
  final Dio dio = Dio();

  Future<String> login(String username, String password) async {
    try {
      final response = await dio.post(
        "${baseUrl}Login",
        data: {
          "username": username,
          "password": password,
        },
        options: Options(
          contentType: Headers.formUrlEncodedContentType, // important for form-data
        ),
      );

      // Make sure the API returns 'token'
      if (response.statusCode == 200 && response.data["token"] != null) {
        final token = response.data["token"];

        // Save token locally
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString("auth_token", token);

        return token;
      } else {
        // Show the exact API response if login fails
        throw Exception("Login failed: ${response.data}");
      }
    } on DioException catch (e) {
      throw Exception("Network error: ${e.response?.data ?? e.message}");
    } catch (e) {
      throw Exception("Unexpected error: $e");
    }
  }
}
