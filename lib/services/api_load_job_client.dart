import 'package:work_flow/apiclient/restfulapi.dart';
import 'package:work_flow/token/token_client.dart';

class ApiLoadJobClient {
  final RestfulApi restfulApi = RestfulApi();
  final Tokenclient tokenclient = Tokenclient();

  Future<List<dynamic>> loadJobs() async {
    String? token = await tokenclient.getToken();
    String? refreshToken = await tokenclient.getRefreshToken();

    if (token == null || refreshToken == null) {
      print('Token hoặc refreshToken không tồn tại');
      return [];
    }

    try {
      final response = await restfulApi.httpGet("/job/getAll", headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      });

      print("Phản hồi từ API /job/getAll: $response");

      if (response is List<dynamic>) {
        print("Dữ liệu công việc từ API: $response");
        return response;
      }
      return [];
    } catch (e) {
      if (e.toString().contains("401")) {
        print('Access Token hết hạn. Gọi API refreshToken...');

        final refreshResponse =
            await restfulApi.httpPost("/common/refreshToken", {
          'refreshToken': refreshToken,
        });

        if (refreshResponse != null &&
            refreshResponse.containsKey('accessToken')) {
          await tokenclient.updateToken(refreshResponse['accessToken']);
          print('Access Token mới đã được cập nhật.');

          return await loadJobs();
        } else {
          print('API refreshToken không trả về accessToken.');
        }
      } else {
        print('Lỗi khi tải danh sách công việc: $e');
      }
    }

    return [];
  }
}
