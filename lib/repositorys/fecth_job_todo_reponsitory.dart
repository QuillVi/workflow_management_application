import 'package:flutter/material.dart';
import 'package:work_flow/services/api_fecth_job_todo.dart';

class FecthJobTodoReponsitory {
  final ApiFecthJobTodo apiFecthJobTodo = ApiFecthJobTodo();

  Future<List<Map<String, dynamic>>> fetchJobsToDo(BuildContext context) async {
    return await apiFecthJobTodo.fetchJobsToDo(context);
  }
}
