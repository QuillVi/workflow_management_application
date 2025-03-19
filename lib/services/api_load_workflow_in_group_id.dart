import 'package:work_flow/apiclient/restfulapi.dart';
import 'package:work_flow/token/token_client.dart';

class ApiLoadWorkflowInGroupId {
  final RestfulApi restfulApi = RestfulApi();
  final Tokenclient tokenclient = Tokenclient();

  Future<List<dynamic>> fetchWorkflowsByGroupId(int groupId) async {
    try {
      String? token = await tokenClient.getToken();

      if (token == null) {
        print("❌ Token không tồn tại, thử làm mới...");
        bool refreshed = await tokenClient.refreshAccessToken();
        if (!refreshed) {
          throw Exception("Làm mới token thất bại. Vui lòng đăng nhập lại.");
        }
        token = await tokenClient.getToken();
      }

      final response = await restfulApi.httpGet(
        "/userWorkFlow/getByGroupID/$groupId",
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response is List) {
        return response;
      } else {
        throw Exception("Dữ liệu trả về không hợp lệ");
      }
    } catch (e) {
      throw Exception("Lỗi khi lấy danh sách workflow: $e");
    }
  }
}
