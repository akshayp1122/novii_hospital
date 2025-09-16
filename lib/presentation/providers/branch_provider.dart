import 'package:flutter/foundation.dart';
import '../../data/repositories/branch_repository.dart';
import '../../domain/models/branch_model.dart';

class BranchProvider with ChangeNotifier {
  final BranchRepository _repository = BranchRepository();

  List<Branch> _branches = [];
  bool _loading = false;
  String? _error;

  List<Branch> get branches => _branches;
  bool get loading => _loading;
  String? get error => _error;

  Future<void> fetchBranches(String token) async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      final result = await _repository.getBranches(token);
      _branches = result;
    } catch (e) {
      _error = e.toString();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}
