import 'package:flutter/material.dart';
import 'package:work_flow/repositorys/fecth_job_done_reponsitory.dart';

class FecthJobDoneViewModel extends ChangeNotifier {
  final FecthJobDoneReponsitory fecthJobDoneReponsitory =
      FecthJobDoneReponsitory();

  List<Map<String, dynamic>> _jobs = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Map<String, dynamic>> get jobs => _jobs;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchJobsDone(BuildContext context) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _jobs = await fecthJobDoneReponsitory.fetchJobsDone(context);
      print('Dữ liệu job done: $_jobs');
    } catch (e) {
      _errorMessage = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }
}
