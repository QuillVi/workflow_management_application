import 'package:work_flow/apiclient/restfulapi.dart';
import 'package:work_flow/token/token_client.dart';

class ApiTaskClient {
  final RestfulApi resFullApi = RestfulApi();
  final tokenClient = Tokenclient();

  Future loadTasks() async {
    String? token = await tokenClient.getToken();
    String? refreshToken = await tokenClient.getRefreshToken();

    if (token == null || refreshToken == null) {
      print('Token hoặc refreshToken không tồn tại');
      return;
    }

    try {
      final response = await resFullApi.httpGet("/job/getAll", headers: {
        'Authorization': 'Bearer $token',
      });

      return response; // Trả về danh sách công việc
    } catch (e) {
      if (e.toString().contains("401")) {
        print('Access Token hết hạn. Gọi API refreshToken...');

        // Gọi API refresh token
        final refreshResponse =
            await resFullApi.httpPost("/common/refreshToken", {
          'refreshToken': refreshToken,
        });

        if (refreshResponse != null &&
            refreshResponse.containsKey('accessToken')) {
          await tokenClient.updateToken(refreshResponse['accessToken']);
          print('Access Token mới đã được cập nhật.');

          // Gọi lại API sau khi cập nhật token
          return await loadTasks();
        } else {
          print('API refreshToken không trả về accessToken.');
        }
      } else {
        print('Lỗi khi tải danh sách công việc: $e');
      }
    }
  }
}
