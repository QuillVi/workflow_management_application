import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:work_flow/views/message_push_notification/globalkey.dart';

class NotiService {
  static final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    // 📌 Yêu cầu quyền nhận thông báo
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print("🔔 Đã cấp quyền nhận thông báo!");
    } else {
      print("🚫 Người dùng từ chối nhận thông báo.");
    }

    // 📌 Cấu hình Local Notifications
    const AndroidInitializationSettings androidInit =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings iosInit = DarwinInitializationSettings();

    final InitializationSettings initSettings =
        InitializationSettings(android: androidInit, iOS: iosInit);

    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        _handleNotificationClick(response.payload);
      },
    );

    // 📌 Xử lý khi app đang mở (foreground)
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print(
          '📩 Nhận thông báo khi app đang mở: ${message.notification?.title}');
      showBigTextNotification(
        title: message.notification?.title ?? "Thông báo",
        body: message.notification?.body ?? "Nội dung thông báo",
        payload: message.data['jobId'] ?? "",
      );
    });

    // 📌 Xử lý khi nhấn vào thông báo khi app đang chạy ngầm
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("📩 Người dùng nhấn vào thông báo khi app chạy ngầm $message");
      _handleNotificationNavigation(message);
    });

    // 📌 Kiểm tra thông báo chưa xử lý khi app mở lại
    await _checkSavedNotification();
  }

  // 📌 Hàm hiển thị thông báo khi app đang mở
  static Future<void> showBigTextNotification({
    required String title,
    required String body,
    required String payload,
  }) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'high_importance_channel',
      'High Importance Notifications',
      channelDescription: 'Kênh thông báo quan trọng',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      styleInformation: BigTextStyleInformation(''),
    );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: DarwinNotificationDetails(),
    );

    await _localNotifications.show(
      0,
      title,
      body,
      notificationDetails,
      payload: payload,
    );

    // 📌 Lưu payload vào SharedPreferences để xử lý sau
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('pending_notification', payload);
  }

  static void _handleNotificationClick(String? payload) async {
    if (payload != null && payload.isNotEmpty) {
      print(
          '📩 Người dùng nhấn vào thông báo với _handleNotificationClick jobId: $payload');

      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('pending_notification');
      NavigationService.navigatorKey.currentState
          ?.pushNamed('/infoJob', arguments: payload);
    }
  }

  static Future<void> _checkSavedNotification() async {
    final prefs = await SharedPreferences.getInstance();
    final String? pendingJobId = prefs.getString('pending_notification');

    if (pendingJobId != null) {
      print('📩 Phát hiện thông báo chưa xử lý: $pendingJobId');
      _handleNotificationClick(pendingJobId);
    }
  }

  static void _handleNotificationNavigation(RemoteMessage message) {
    final String? jobId = message.data['jobId'];
    print("📩 _handleNotificationNavigation được gọi với jobId: $jobId");

    if (jobId != null && jobId.isNotEmpty) {
      Future.delayed(Duration(milliseconds: 500), () {
        if (NavigationService.navigatorKey.currentState != null) {
          print("✅ navigatorKey sẵn sàng, điều hướng...");
          NavigationService.navigatorKey.currentState!
              .pushNamed('/infoJob', arguments: jobId);
        } else {
          print(
              "❌ navigatorKey.currentState vẫn null sau delay, không thể điều hướng.");
        }
      });
    } else {
      print("⚠️ jobId không hợp lệ.");
    }
  }
}
