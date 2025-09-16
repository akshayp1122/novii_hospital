import 'package:dio/dio.dart';
import '../../domain/models/patient_model.dart';

class PatientRepository {
  final Dio dio = Dio();
  final String baseUrl = "https://flutter-amr.noviindus.in/api/";

  Future<List<Patient>> getPatients(String token) async {
    try {
      final response = await dio.get(
        "${baseUrl}PatientList",
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
          },
        ),
      );

      if (response.statusCode == 200 && response.data["status"] == true) {
        final List patientsJson = response.data["patient"];
        return patientsJson.map((e) => Patient.fromJson(e)).toList();
      } else {
        return [];
      }
    } on DioException catch (e) {
      throw Exception("Network error: ${e.response?.data ?? e.message}");
    }
  }
}
