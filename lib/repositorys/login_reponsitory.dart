import 'package:flutter/material.dart';
import 'package:work_flow/services/api_login_client.dart';

class LoginRepository {
  final ApiLoginClient apiLoginClient = ApiLoginClient();

  Future<void> login(
      String email, String password, BuildContext context) async {
    return await apiLoginClient.login(email, password, context);
  }

  Future<void> updateFCMToken(int userId, String fcmToken) async {
    await apiLoginClient.sendFCMTokenToServer(userId, fcmToken);
  }
}
