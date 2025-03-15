import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:work_flow/apiclient/restfulapi.dart';
import 'package:work_flow/token/token_client.dart';
import 'package:work_flow/views/mybottomnavigationbar_view/mybottomnavigationbar_view.dart';

class ApiLoginClient {
  final RestfulApi restfulApi = RestfulApi();
  final Tokenclient tokenClient = Tokenclient();

  Future<void> login(
      String email, String password, BuildContext context) async {
    try {
      final response = await restfulApi.httpPost("/login", {
        'username': email,
        'password': password,
      });

      if (response != null && response.containsKey('token')) {
        print('Phản hồi API đăng nhập: $response');
        await updateData(response);

        await tokenClient.updateToken(response['token']);
        await tokenClient.updateRefreshToken(response['refreshToken']);

        await FirebaseMessaging.instance.deleteToken();
        await Future.delayed(Duration(seconds: 2));
        String? newFcmToken = await FirebaseMessaging.instance.getToken();

        print('🔵 FCM Token mới: $newFcmToken');

        if (newFcmToken == null || newFcmToken.isEmpty) {
          print('❌ Lỗi: Không tìm thấy FCM Token mới');
          return;
        }

        await sendFCMTokenToServer(response['IDUser'], newFcmToken);

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('fcm_token', newFcmToken);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Đăng nhập thành công!'),
            backgroundColor: Colors.green,
            duration: Duration(milliseconds: 500),
          ),
        );

        await Future.delayed(Duration(seconds: 1));

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Mybottomnavigationbar()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Đăng nhập không thành công!'),
            backgroundColor: Colors.red,
          ),
        );
        print('Lỗi đăng nhập: ${response?['message'] ?? 'Lỗi không xác định'}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Đã xảy ra lỗi: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
      print('🔴 Lỗi đăng nhập: $e');
    }
  }

  Future<void> sendFCMTokenToServer(int userId, String fcmToken) async {
    try {
      String? token = await tokenClient.getToken();

      if (token == null || token.isEmpty) {
        print('❌ Lỗi: Không tìm thấy Access Token');
        return;
      }

      final response = await restfulApi.httpPost(
        "/notify/saveFCMToken",
        {
          'IDUser': userId,
          'fcm_token': fcmToken,
        },
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response != null) {
        print('✅ FCM Token đã được lưu thành công!');
      } else {
        print('❌ Lỗi khi lưu FCM Token!');
      }
    } catch (e) {
      print('🔴 Lỗi khi gửi FCM Token: ${e.toString()}');
    }
  }

  Future<void> updateData(Map<String, dynamic> mapResponse) async {
    final pref = await SharedPreferences.getInstance();
    await pref.setString('name', mapResponse['Name'] ?? '');
    await pref.setInt('IDUser', mapResponse['IDUser']);
    print('✅ IDUser được lưu: ${mapResponse['IDUser']}');
  }
}
