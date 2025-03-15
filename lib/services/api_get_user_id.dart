import 'package:shared_preferences/shared_preferences.dart';
import 'package:work_flow/apiclient/restfulapi.dart';
import 'package:work_flow/token/token_client.dart';

class ApiGetUserId {
  final RestfulApi restfulApi = RestfulApi();
  final Tokenclient tokenclient = Tokenclient();

  Future<void> getUserProfile(Function(String, String) updateUser) async {
    String? token = await tokenClient.getToken();
    String? refreshToken = await tokenClient.getRefreshToken();

    final prefs = await SharedPreferences.getInstance();
    final int? idUser = prefs.getInt('IDUser');

    if (idUser == null || token == null || refreshToken == null) {
      print('IDUser hoặc Token không tồn tại');
      return;
    }

    try {
      final response = await restfulApi.httpGet("/appUser/$idUser", headers: {
        'Authorization': 'Bearer $token',
      });

      if (response != null) {
        print('User data: $response');
        updateUser(response['Name'], response['Username']);
      } else {
        print('Không nhận được dữ liệu từ API.');
      }
    } catch (e) {
      if (e.toString().contains("401")) {
        print('Access Token hết hạn. Gọi API refreshToken...');

        final refreshResponse =
            await restfulApi.httpPost("/common/refreshToken", {
          'refreshToken': refreshToken,
        });

        if (refreshResponse != null &&
            refreshResponse.containsKey('accessToken')) {
          await tokenClient.updateToken(refreshResponse['accessToken']);
          print('Access Token mới đã được cập nhật.');
          return getUserProfile(updateUser);
        } else {
          print('API refreshToken không trả về accessToken.');
        }
      } else {
        print('Lỗi khi tải thông tin người dùng: $e');
      }
    }
  }
}
