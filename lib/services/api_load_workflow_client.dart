import 'package:work_flow/apiclient/restfulapi.dart';
import 'package:work_flow/token/token_client.dart';

class ApiLoadWorkflowClient {
  final RestfulApi restfulApi = RestfulApi();
  final Tokenclient tokenclient = Tokenclient();

  Future<List<dynamic>> fetchWorkflows() async {
    String? token = await tokenclient.getToken();

    if (token == null) {
      throw Exception("Token không tồn tại, vui lòng đăng nhập lại.");
    }

    try {
      final response = await restfulApi.httpGet(
        "/workFlow/getAll",
        headers: {'Authorization': 'Bearer $token'},
      );

      return response;
    } catch (e) {
      throw Exception("Lỗi khi tải workflows: $e");
    }
  }
}
