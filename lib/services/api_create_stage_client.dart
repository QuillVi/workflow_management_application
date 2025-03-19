import 'package:work_flow/apiclient/restfulapi.dart';
import 'package:work_flow/token/token_client.dart';

class ApiCreateStageClient {
  final RestfulApi restfulApi = RestfulApi();
  final Tokenclient tokenclient = Tokenclient();

  Future<Map<String, dynamic>?> createStage({
    required String nameStage,
    required String descriptionStatus,
    required int workflowId,
  }) async {
    String? token = await tokenclient.getToken();
    if (token == null) {
      print('❌ Không tìm thấy Access Token');
      return null;
    }

    try {
      final response = await restfulApi.httpPost(
        "/stage/create",
        {
          "NameStage": nameStage,
          "DescriptionStatus": descriptionStatus,
          "IDWorkFlow": workflowId,
        },
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      print("📌 Phản hồi từ API /stage/create: $response");

      if (response != null && response.containsKey('IdStage')) {
        return response;
      } else {
        print("⚠️ API không trả về dữ liệu stage hợp lệ.");
        return null;
      }
    } catch (e) {
      print('🔴 Lỗi khi tạo stage: $e');
      return null;
    }
  }
}
