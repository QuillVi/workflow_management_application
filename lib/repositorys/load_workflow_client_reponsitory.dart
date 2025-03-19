import 'package:work_flow/services/api_load_workflow_client.dart';

class LoadWorkflowClientReponsitory {
  final ApiLoadWorkflowClient apiLoadWorkflowClient = ApiLoadWorkflowClient();

  Future<List<dynamic>> getWorkflows() async {
    try {
      return await apiLoadWorkflowClient.fetchWorkflows();
    } catch (e) {
      throw Exception("Lỗi khi tải workflows: $e");
    }
  }
}
