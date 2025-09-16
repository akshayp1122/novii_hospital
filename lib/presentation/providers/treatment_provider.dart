import 'package:flutter/material.dart';
import 'package:noviindus_patients/domain/models/treatment.dart';
import 'package:noviindus_patients/domain/repositories/treatment_repository.dart';

class TreatmentProvider extends ChangeNotifier {
  final TreatmentRepository repository;
  TreatmentProvider(this.repository);

  List<Treatment> _treatments = [];
  List<Treatment> get treatments => _treatments;

  bool _loading = false;
  bool get loading => _loading;

  String? _error;
  String? get error => _error;

  Future<void> fetchTreatments(String token) async {
    _loading = true;
    notifyListeners();
    try {
      _treatments = await repository.fetchTreatments(token);
      _error = null;
    } catch (e) {
      _error = e.toString();
    }
    _loading = false;
    notifyListeners();
  }
}
