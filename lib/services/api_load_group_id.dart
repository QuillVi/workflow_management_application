import 'package:work_flow/apiclient/restfulapi.dart';
import 'package:work_flow/token/token_client.dart';
import 'package:work_flow/views/group_view/info_group_view.dart';

class ApiLoadGroupId {
  final RestfulApi restfulApi = RestfulApi();
  final Tokenclient tokenclient = Tokenclient();

  Future<Group?> loadGroup(int groupId) async {
    String? token = await tokenclient.getToken();

    if (token == null) {
      print('❌ Không tìm thấy Access Token');
      return null;
    }

    try {
      final response = await restfulApi.httpGet(
        "/group/$groupId",
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      print("📌 Phản hồi từ API /group/$groupId: $response");

      if (response != null && response.containsKey('group')) {
        return Group.fromJson(response['group']);
      } else {
        print("⚠️ API không trả về dữ liệu nhóm hợp lệ.");
      }
    } catch (e) {
      print('🔴 Lỗi khi tải nhóm: $e');
    }

    return null;
  }
}
