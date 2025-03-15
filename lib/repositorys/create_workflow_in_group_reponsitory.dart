import 'package:work_flow/services/api_create_workflow_in_group.dart';

class CreateWorkflowInGroupReponsitory {
  final ApiCreateWorkflowInGroup apiCreateWorkflowInGroup =
      ApiCreateWorkflowInGroup();

  Future<int?> createWorkflow(String name, String description,
      int selectedGroupId, List<dynamic> stages) {
    return apiCreateWorkflowInGroup.createWorkflow(
        name, description, selectedGroupId, stages);
  }
}
