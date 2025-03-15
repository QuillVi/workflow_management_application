import 'package:flutter/material.dart';
import 'package:work_flow/repositorys/fecth_job_todo_reponsitory.dart';

class FecthJobTodoViewModel extends ChangeNotifier {
  final FecthJobTodoReponsitory fecthJobTodoReponsitory =
      FecthJobTodoReponsitory();

  List<Map<String, dynamic>> _jobs = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Map<String, dynamic>> get jobs => _jobs;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchJobsToDo(BuildContext context) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _jobs = await fecthJobTodoReponsitory.fetchJobsToDo(context);
      print('dữ liệu job todo: $_jobs');
    } catch (e) {
      _errorMessage = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }
}
