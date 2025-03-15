import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'noti_service.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('📩 Nhận thông báo trong background: ${message.messageId}');
}

class PushNotifications {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initNotifications() async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      sound: true,
      badge: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.denied) {
      print("🚫 Người dùng từ chối thông báo");
      return;
    }

    final fcmToken = await _firebaseMessaging.getToken();
    print('🔑 FCM Token: $fcmToken');

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("🔔 Nhận thông báo mới (foreground)");
      print("Title: ${message.notification?.title}");
      print("Body: ${message.notification?.body}");
      print("Payload: ${message.data}");

      NotiService.showBigTextNotification(
        title: message.notification?.title ?? 'Thông báo',
        body: message.notification?.body ?? '',
        payload: message.data['jobId'] ?? '',
      );
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print(
          "📩 Người dùng nhấn vào thông báo với onMessageOpenedApp jobId: ${message.data['jobId']}");

      if (navigatorKey.currentState == null) {
        print("❌ navigatorKey.currentState == null, không thể điều hướng");
      } else {
        print("✅ navigatorKey.currentState đã sẵn sàng");
        navigatorKey.currentState
            ?.pushNamed('/infoJob', arguments: message.data['jobId']);
      }
    });
  }
}
