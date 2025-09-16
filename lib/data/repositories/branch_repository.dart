import 'package:dio/dio.dart';
import '../../domain/models/branch_model.dart';

class BranchRepository {
  final Dio _dio = Dio();
  final String baseUrl = "https://flutter-amr.noviindus.in/api/";

  Future<List<Branch>> getBranches(String token) async {
    try {
      final response = await _dio.get(
        "${baseUrl}BranchList",
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
          },
        ),
      );

      if (response.statusCode == 200 && response.data["status"] == true) {
        final List<dynamic> branchesJson = response.data["branches"];
        return branchesJson.map((e) => Branch.fromJson(e)).toList();
      } else {
        return [];
      }
    } on DioException catch (e) {
      throw Exception("Network error: ${e.response?.data ?? e.message}");
    }
  }
}
