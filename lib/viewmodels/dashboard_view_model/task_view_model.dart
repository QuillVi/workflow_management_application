import 'package:flutter/material.dart';
import 'package:work_flow/repositorys/task_repository.dart';

class TaskViewModel extends ChangeNotifier {
  final TaskRepository taskRepository;

  TaskViewModel(this.taskRepository);

  List<dynamic> _tasks = [];
  bool _isLoading = false;

  List<dynamic> get tasks => _tasks;
  bool get isLoading => _isLoading;

  Future<void> loadTasks() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await taskRepository.loadTasks();

      if (response != null && response is Map<String, dynamic>) {
        if (response.containsKey('data') &&
            response['data'].containsKey('jobs')) {
          _tasks = response['data']['jobs'] as List<dynamic>;
          print('du lieu khi call api task: $_tasks');
        } else {
          print('⚠️ Dữ liệu không chứa danh sách công việc hợp lệ');
          _tasks = [];
        }
      } else {
        print('⚠️ Phản hồi API không phải là Map<String, dynamic>');
        _tasks = [];
      }
    } catch (e) {
      print('❌ Lỗi trong TaskViewModel.loadTasks(): $e');
      _tasks = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
