import 'package:dio/dio.dart';
import 'package:intl/intl.dart';

class PatientService {
  final Dio _dio = Dio();

  /// Format datetime as "dd/MM/yyyy-hh:mm a"
  String formatDateTime(DateTime date, int hour, int minute) {
    final dt = DateTime(date.year, date.month, date.day, hour, minute);
    return DateFormat('dd/MM/yyyy-hh:mm a').format(dt);
  }

 Future<bool> registerPatient(Map<String, dynamic> data, String token) async {
  try {
    final formData = FormData.fromMap(data);

    print("📤 Sending data to backend:");
    data.forEach((key, value) {
      print("   $key: $value");
    });

    final response = await _dio.post(
      "https://flutter-amr.noviindus.in/api/PatientUpdate",
      data: formData,
      options: Options(
        headers: {
          "Authorization": "Bearer $token",
        },
      ),
    );

    print("✅ Response status: ${response.statusCode}");
    print("✅ Response data: ${response.data}");

    return response.statusCode == 200;
  } catch (e) {
    print("❌ Dio error: $e");
    return false;
  }
}

}
