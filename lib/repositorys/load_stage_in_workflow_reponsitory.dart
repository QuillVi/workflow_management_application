import 'package:work_flow/services/api_load_stage_in_workflow.dart';

class LoadStageInWorkflowReponsitory {
  final ApiLoadStageInWorkflow apiLoadStageInWorkflow =
      ApiLoadStageInWorkflow();

  Future<List<Map<String, dynamic>>> getStagesByWorkflowId(
      int workflowId) async {
    return await apiLoadStageInWorkflow.loadStageInWorkflow(workflowId);
  }
}
