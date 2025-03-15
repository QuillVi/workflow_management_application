import 'package:work_flow/apiclient/restfulapi.dart';
import 'package:work_flow/token/token_client.dart';

class ApiLoaduserClient {
  final RestfulApi resFullApi = RestfulApi();
  final Tokenclient tokenClient = Tokenclient();

  Future loadUsers() async {
    String? token = await tokenClient.getToken();
    String? refreshToken = await tokenClient.getRefreshToken();

    if (token == null || refreshToken == null) {
      print('Token hoặc refreshToken không tồn tại');
      return;
    }

    try {
      final response = await resFullApi.httpGet("/appUser/getAll", headers: {
        'Authorization': 'Bearer $token',
      });

      return response;
    } catch (e) {
      if (e.toString().contains("401")) {
        print('Access Token hết hạn. Gọi API refreshToken...');

        final refreshResponse =
            await resFullApi.httpPost("/common/refreshToken", {
          'refreshToken': refreshToken,
        });

        if (refreshResponse != null &&
            refreshResponse.containsKey('accessToken')) {
          await tokenClient.updateToken(refreshResponse['accessToken']);
          print('Access Token mới đã được cập nhật.');

          return await loadUsers();
        } else {
          print('API refreshToken không trả về accessToken.');
        }
      } else {
        print('Lỗi khi tải danh sách người dùng: $e');
      }
    }
  }
}
