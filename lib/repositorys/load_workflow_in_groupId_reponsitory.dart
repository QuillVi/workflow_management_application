import 'package:work_flow/services/api_load_workflow_in_group_id.dart';

class LoadWorkflowInGroupidReponsitory {
  final ApiLoadWorkflowInGroupId apiLoadWorkflowInGroupId =
      ApiLoadWorkflowInGroupId();

  Future<List<String>?> getWorkflowsByGroupId(int groupId) async {
    try {
      return await apiLoadWorkflowInGroupId.loadWorkflows(groupId);
    } catch (e) {
      print('❌ Lỗi khi lấy dữ liệu workflows của nhóm: $e');
      return null;
    }
  }
}
