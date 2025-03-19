import 'package:flutter/foundation.dart';
import 'package:work_flow/apiclient/restfulapi.dart';
import 'package:work_flow/token/token_client.dart';

class ApiLoadStageInWorkflow {
  final RestfulApi restfulApi = RestfulApi();
  final Tokenclient tokenclient = Tokenclient();

  Future<List<Map<String, dynamic>>> loadStageInWorkflow(int workflowId) async {
    String? token = await tokenclient.getToken();

    if (token == null) {
      throw Exception('❌ Token không tồn tại, vui lòng đăng nhập lại.');
    }

    return await _fetchStages(workflowId, token);
  }

  Future<List<Map<String, dynamic>>> _fetchStages(
      int workflowId, String token) async {
    try {
      final response = await restfulApi.httpGet(
        "/stage/stagebyidworkflow/$workflowId",
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      print('du lieu reponse: $response');
      print('du lieu workflowId: $workflowId');

      if (response == null || response.isEmpty) {
        throw Exception('⚠️ Không có dữ liệu stage nào được trả về.');
      }

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      if (e.toString().contains("401")) {
        debugPrint('⚠️ Token hết hạn, đang làm mới token...');

        bool refreshed = await tokenclient.refreshAccessToken();
        if (refreshed) {
          debugPrint('✅ Token mới đã được cập nhật, thử lại...');
          String? newToken = await tokenclient.getToken();
          if (newToken != null) {
            return await _fetchStages(workflowId, newToken);
          }
        }
        throw Exception('❌ Làm mới token thất bại, vui lòng đăng nhập lại.');
      }

      throw Exception('🔴 Lỗi khi tải danh sách stages: $e');
    }
  }
}
