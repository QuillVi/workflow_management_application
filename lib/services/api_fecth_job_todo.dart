import 'package:flutter/material.dart';
import 'package:work_flow/apiclient/restfulapi.dart';
import 'package:work_flow/token/token_client.dart';
import 'package:work_flow/views/login_views/login_view.dart';

class ApiFecthJobTodo {
  final RestfulApi resFullApi = RestfulApi();
  final Tokenclient tokenClient = Tokenclient();

  Future<List<Map<String, dynamic>>> fetchJobsToDo(BuildContext context) async {
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
          await resFullApi.httpGet("/job/getJobsByStatus/to-do", headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      });

      if (response != null &&
          response['success'] == true &&
          response['data'] != null) {
        return (response['data'] as List).map((job) {
          return {
            'IDJob': job['IDJob'],
            'NameJob': job['NameJob'],
            'TimeStart': job['TimeStart'],
            'Status': job['Status'],
          };
        }).toList();
      } else {
        return [];
      }
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
          return await fetchJobsToDo(context);
        } else {
          _redirectToLogin(context);
          throw Exception('API refreshToken không trả về accessToken.');
        }
      } else {
        throw Exception('Lỗi khi tải danh sách công việc: $e');
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
