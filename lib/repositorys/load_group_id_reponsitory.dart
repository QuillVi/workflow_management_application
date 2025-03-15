import 'package:work_flow/services/api_load_group_id.dart';
import 'package:work_flow/views/group_view/info_group_view.dart';

class LoadGroupIdReponsitory {
  final ApiLoadGroupId apiLoadGroupId = ApiLoadGroupId();

  Future<Group?> getGroupById(String groupId) async {
    try {
      int? id = int.tryParse(groupId);
      if (id == null) {
        print('❌ Giá trị groupId không hợp lệ: $groupId');
        return null;
      }

      final response = await apiLoadGroupId.loadGroup(id);
      return response;
    } catch (e) {
      print('❌ Lỗi khi lấy dữ liệu nhóm: $e');
    }
    return null;
  }
}
