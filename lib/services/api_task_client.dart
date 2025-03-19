import 'package:work_flow/apiclient/restfulapi.dart';
import 'package:work_flow/token/token_client.dart';

class ApiTaskClient {
  final RestfulApi resFullApi = RestfulApi();
  final tokenClient = Tokenclient();

  Future loadTasks() async {
    String? token = await tokenClient.getToken();
    String? refreshToken = await tokenClient.getRefreshToken();
    int? userId = await tokenClient.getIDUser();

    if (token == null || refreshToken == null || userId == null) {
      print('Token, refreshToken hoặc IDUser không tồn tại');
      return;
    }

    try {
      final response = await resFullApi.httpGet(
        "/job/getJobByIDUser/$userId",
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      return response;
    } catch (e) {
      if (e.toString().contains("401")) {
        print('Access Token hết hạn. Gọi API refreshToken...');

        final refreshResponse = await resFullApi.httpPost(
          "/common/refreshToken",
          {'refreshToken': refreshToken},
        );

        if (refreshResponse != null &&
            refreshResponse.containsKey('accessToken')) {
          await tokenClient.updateToken(refreshResponse['accessToken']);
          print('Access Token mới đã được cập nhật.');

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
