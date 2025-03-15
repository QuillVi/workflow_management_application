import 'package:work_flow/apiclient/restfulapi.dart';
import 'package:work_flow/token/token_client.dart';

class ApiCreateGroupAddmember {
  final RestfulApi restfulApi = RestfulApi();
  final Tokenclient tokenclient = Tokenclient();

  Future<int?> createGroupAndAddMembers(String groupName, int idUser) async {
    String? token = await tokenclient.getToken();

    if (token == null) {
      print('❌ Không tìm thấy Access Token');
      return null;
    }

    if (groupName.isEmpty) {
      print('⚠️ Tên nhóm không được để trống.');
      return null;
    }

    try {
      final response = await restfulApi.httpPost(
        "/group/create",
        {
          'groupName': groupName,
          'IDUser': idUser,
        },
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      print("📌 Phản hồi từ API /group/create: $response");

      if (response != null && response.containsKey('group')) {
        final int groupId = response['group']['GroupID'];
        print('✅ Nhóm được tạo với ID: $groupId');
        return groupId;
      } else {
        print("⚠️ API không trả về dữ liệu nhóm hợp lệ.");
      }
    } catch (e) {
      print('🔴 Lỗi khi tạo nhóm: $e');
    }

    return null;
  }
}
