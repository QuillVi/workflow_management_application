import 'package:flutter/material.dart';
import 'package:work_flow/repositorys/task_repository.dart';

class TaskViewModel extends ChangeNotifier {
  final TaskRepository taskRepository;

  TaskViewModel(this.taskRepository);

  List<dynamic> _tasks = [];

  Future loadTasks() async {
    _tasks = await taskRepository.loadTasks();

    print('du lieu sao khi call api task : $_tasks');
    notifyListeners();

    return _tasks;
  }
}
