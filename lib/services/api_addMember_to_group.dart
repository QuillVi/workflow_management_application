import 'package:work_flow/apiclient/restfulapi.dart';
import 'package:work_flow/token/token_client.dart';

class ApiAddmemberToGroup {
  final RestfulApi restfulApi = RestfulApi();
  final Tokenclient tokenclient = Tokenclient();

  Future<void> addMembersToGroup(int groupId, List<String> emailList) async {
    print('📌 Đang thêm thành viên vào nhóm với ID: $groupId');
    print('📋 Danh sách email: $emailList');

    if (emailList.isEmpty) {
      print('⚠️ Không có email nào để thêm vào nhóm.');
      return;
    }

    String? token = await tokenclient.getToken();
    if (token == null) {
      print("❌ Token không tồn tại, vui lòng đăng nhập lại.");
      return;
    }

    try {
      final response = await restfulApi.httpPost(
        "/group/addMember",
        {
          'emails': emailList,
          'groupId': groupId,
        },
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response != null) {
        print('✅ Thành viên đã được thêm vào nhóm thành công!');
      } else {
        print("⚠️ API không trả về phản hồi hợp lệ.");
      }
    } catch (e) {
      print('🔴 Lỗi khi thêm thành viên vào nhóm: $e');
    }
  }
}
