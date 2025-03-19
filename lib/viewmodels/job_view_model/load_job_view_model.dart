import 'package:flutter/material.dart';
import 'package:work_flow/repositorys/load_job_reponsitory.dart';

class LoadJobViewModel extends ChangeNotifier {
  final LoadJobReponsitory loadJobReponsitory = LoadJobReponsitory();

  bool _isEditing = false;
  bool get isEditing => _isEditing;

  String _title = 'Tasks';
  String get title => _title;

  List<dynamic> _jobs = [];
  List<dynamic> get jobs => _jobs;

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  void toggleEditing() {
    _isEditing = !_isEditing;
    notifyListeners();
  }

  void updateTitle(String newTitle) {
    _title = newTitle;
    _isEditing = false;
    notifyListeners();
  }

  Future<void> fetchJobs() async {
    _isLoading = true;
    notifyListeners();

    try {
      _jobs = await loadJobReponsitory.getJobs();
    } catch (e) {
      debugPrint("Lỗi khi tải danh sách công việc: $e");
    }

    _isLoading = false;
    notifyListeners();
  }
}
