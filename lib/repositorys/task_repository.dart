import 'package:work_flow/services/api_task_client.dart';

class TaskRepository {
  final ApiTaskClient apiTaskClient;

  TaskRepository(this.apiTaskClient);

  Future<dynamic> loadTasks() async {
    return await apiTaskClient.loadTasks();
  }
}
