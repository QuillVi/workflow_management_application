import 'package:flutter/material.dart';
import 'package:work_flow/apiclient/restfulapi.dart';
import 'package:work_flow/token/token_client.dart';
import 'package:work_flow/views/login_views/login_view.dart';

class ApiFecthTotalJobReceiced {
  final RestfulApi restfulApi = RestfulApi();
  final Tokenclient tokenClient = Tokenclient();

  Future<int> fetchTotalJobsReceived(BuildContext context) async {
    String? token = await tokenClient.getToken();
    String? refreshToken = await tokenClient.getRefreshToken();
    int? idUser = await tokenClient.getIDUser();

    if (token == null || refreshToken == null || idUser == null) {
      _redirectToLogin(context);
      throw Exception(
          'Token hoặc IDUser không tồn tại. Vui lòng đăng nhập lại.');
    }

    try {
      final response =
          await restfulApi.httpGet("/job/TotalJobsInWeek/$idUser", headers: {
        'Authorization': 'Bearer $token',
      });

      if (response != null && response['success'] == true) {
        return response['data']['totalJobsReceived'] ?? 0;
      } else {
        throw Exception(response?['message'] ?? 'Lỗi khi gọi API');
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
          return await fetchTotalJobsReceived(context);
        } else {
          _redirectToLogin(context);
          throw Exception('API refreshToken không trả về accessToken.');
        }
      } else {
        throw Exception('Lỗi khi tải số lượng công việc: $e');
      }
    }
  }

  void _redirectToLogin(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginView()),
      (route) => false,
    );
  }
}
