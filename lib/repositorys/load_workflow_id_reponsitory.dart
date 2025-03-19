import 'package:work_flow/services/api_load_workflow_id.dart';
import 'package:work_flow/models/workflow_model/workflow_model.dart';

class LoadWorkflowIdReponsitory {
  final ApiLoadWorkflowId apiLoadWorkflowId = ApiLoadWorkflowId();

  Future<Workflow?> getWorkflowById(int workflowId) async {
    return await apiLoadWorkflowId.loadWorkflow(workflowId);
  }
}
