import 'package:dio/dio.dart';
import '../models/treatment.dart';

class TreatmentRepository {
  final Dio dio = Dio();
  final String baseUrl = "https://flutter-amr.noviindus.in/api/";

  Future<List<Treatment>> fetchTreatments(String token) async {
    final response = await dio.get(
      "${baseUrl}TreatmentList",
      options: Options(
        headers: {
          "Authorization": "Bearer $token",
        },
      ),
    );

    if (response.statusCode == 200) {
      final data = response.data["treatments"] as List;
      return data.map((e) => Treatment.fromJson(e)).toList();
    } else {
      throw Exception("Failed to fetch treatments");
    }
  }
}
