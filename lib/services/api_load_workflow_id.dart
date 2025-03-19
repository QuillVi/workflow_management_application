import 'package:work_flow/apiclient/restfulapi.dart';
import 'package:work_flow/token/token_client.dart';
import 'package:work_flow/models/workflow_model/workflow_model.dart';

class ApiLoadWorkflowId {
  final RestfulApi restfulApi = RestfulApi();
  final Tokenclient tokenclient = Tokenclient();

  Future<Workflow?> loadWorkflow(int workflowId) async {
    String? token = await tokenclient.getToken();
    String? refreshToken = await tokenclient.getRefreshToken();

    if (token == null || refreshToken == null) {
      print('❌ Không tìm thấy Access Token hoặc Refresh Token');
      return null;
    }

    try {
      final response = await restfulApi.httpGet(
        "/workFlow/$workflowId",
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      print("📌 Phản hồi từ API  ehhe /workFlow/$workflowId: $response");

      if (response != null && response.containsKey('workflow')) {
        return Workflow.fromJson(response['workflow']);
      } else {
        print("⚠️ API không trả về dữ liệu workflow hợp lệ.");
      }
    } catch (e) {
      if (e.toString().contains("401")) {
        print('🔄 Access Token hết hạn. Gọi API refreshToken...');

        final refreshResponse = await restfulApi.httpPost(
          "/common/refreshToken",
          {'refreshToken': refreshToken},
        );

        if (refreshResponse != null &&
            refreshResponse.containsKey('accessToken')) {
          await tokenclient.updateToken(refreshResponse['accessToken']);
          print('✅ Access Token mới đã được cập nhật.');
          return await loadWorkflow(workflowId);
        } else {
          print('⚠️ API refreshToken không trả về accessToken.');
        }
      } else {
        print('🔴 Lỗi khi tải workflow: $e');
      }
    }

    return null;
  }
}
