import 'package:work_flow/services/api_load_workflow_in_group_id.dart';

class LoadWorkflowInGroupidReponsitory {
  final ApiLoadWorkflowInGroupId apiLoadWorkflowInGroupId =
      ApiLoadWorkflowInGroupId();

  Future<List<dynamic>> getWorkflowsByGroupId(int groupId) async {
    try {
      return await apiLoadWorkflowInGroupId.fetchWorkflowsByGroupId(groupId);
    } catch (e) {
      print("❌ Lỗi trong Repository: $e");
      throw Exception("Không thể tải danh sách workflow");
    }
  }
}
