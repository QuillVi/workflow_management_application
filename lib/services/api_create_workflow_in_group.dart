import 'package:work_flow/apiclient/restfulapi.dart';
import 'package:work_flow/token/token_client.dart';

class ApiCreateWorkflowInGroup {
  final RestfulApi restfulApi = RestfulApi();
  final Tokenclient tokenclient = Tokenclient();

  Future<int?> createWorkflow(String name, String description,
      int selectedGroupId, List<dynamic> stages) async {
    String? token = await tokenclient.getToken();

    if (token == null) {
      print('❌ Không tìm thấy Access Token');
      return null;
    }

    if (name.isEmpty || description.isEmpty) {
      print('⚠️ Tên và mô tả workflow không được để trống.');
      return null;
    }

    print('📌 Đang gửi yêu cầu tạo workflow...');
    print('🔹 Token: $token');
    print('🔹 Name: $name');
    print('🔹 Description: $description');
    print('🔹 GroupID: $selectedGroupId');
    print('🔹 Stages: $stages');

    try {
      final response = await restfulApi.httpPost(
        "/workFlow/saveWorkFLow",
        {
          'name': name,
          'description': description,
          'GroupID': selectedGroupId,
          'stages': stages,
        },
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      print("📌 Phản hồi từ API /workFlow/saveWorkFLow: $response");

      if (response != null && response.containsKey('workflowId')) {
        final int workflowId = response['workflowId'];
        print('✅ Workflow được tạo với ID: $workflowId');
        return workflowId;
      } else {
        print("⚠️ API không trả về dữ liệu workflow hợp lệ.");
      }
    } catch (e) {
      print('🔴 Lỗi khi tạo workflow: $e');
    }

    return null;
  }
}
