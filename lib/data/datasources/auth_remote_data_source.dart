import 'package:dio/dio.dart';

class AuthRemoteDataSource {
  final Dio dio;

  AuthRemoteDataSource(this.dio);

  Future<Map<String, dynamic>> login(String username, String password) async {
    final response = await dio.post(
      "https://flutter-amr.noviindus.in/api/Login",
      data: {
        "username": username,
        "password": password,
      },
      options: Options(
        contentType: Headers.formUrlEncodedContentType, // required
      ),
    );

    return response.data;
  }
}
