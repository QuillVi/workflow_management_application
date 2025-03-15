import 'package:work_flow/apiclient/restfulapi.dart';
import 'package:work_flow/token/token_client.dart';

class ApiLoadWorkflowInGroupId {
  final RestfulApi restfulApi = RestfulApi();
  final Tokenclient tokenclient = Tokenclient();

  Future<List<String>?> loadWorkflows(int groupId) async {
    String? token = await tokenclient.getToken();

    if (token == null) {
      print('❌ Không tìm thấy Access Token');
      return null;
    }

    try {
      final response = await restfulApi.httpGet(
        "/userWorkFlow/getByGroupID/$groupId",
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      print(
          "📌 Phản hồi từ API /userWorkFlow/getByGroupID/$groupId: $response");

      if (response != null && response is List) {
        return response.map((item) => item['Name'] as String).toList();
      } else {
        print("⚠️ API không trả về danh sách workflows hợp lệ.");
      }
    } catch (e) {
      print('🔴 Lỗi khi tải workflows: $e');
    }

    return null;
  }
}
