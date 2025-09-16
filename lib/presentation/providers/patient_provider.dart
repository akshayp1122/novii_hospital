import 'package:flutter/foundation.dart';
import '../../data/repositories/patient_repository.dart';
import '../../domain/models/patient_model.dart';

class PatientProvider with ChangeNotifier {
  final PatientRepository _repository = PatientRepository();

  List<Patient> _patients = [];
  bool _loading = false;
  String? _error;

  List<Patient> get patients => _patients;
  bool get loading => _loading;
  String? get error => _error;

  Future<void> fetchPatients(String token) async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      final result = await _repository.getPatients(token);
      _patients = result;
    } catch (e) {
      _error = e.toString();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}
