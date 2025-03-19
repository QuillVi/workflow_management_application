import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'package:work_flow/api_constants.dart';
import 'package:work_flow/views/jobs_view/info_job.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  List<Map<String, Object>> notifications = [
    {"section": "New", "items": []},
    {"section": "Yesterday", "items": []},
  ];

  @override
  void initState() {
    super.initState();
    getAllFCMNotify();
    getYesterdayNotifications();
  }

  Future<String?> getUserName(int idUser, String token) async {
    final url = Uri.parse('$baseUrl/appUser/getAll');

    final response = await http.get(
      url,
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json"
      },
    );

    print("📡 API Response Code: ${response.statusCode}");
    print("📡 API Response Body: ${response.body}");

    if (response.statusCode == 200) {
      try {
        List<dynamic> data = jsonDecode(response.body);
        var user = data.firstWhere(
          (user) => user['IDUser'] == idUser,
          orElse: () => null,
        );
        return user != null ? user['Name'] as String? : null;
      } catch (e) {
        print("⚠️ JSON Decode Error: $e");
        return null;
      }
    } else {
      print("🚨 Failed to load user data: ${response.statusCode}");
      return null;
    }
  }

  Future<void> getAllFCMNotify() async {
    Map<String, dynamic> userData = await getAuthData();
    if (userData.isEmpty) return;

    int userId = userData["userId"];
    String token = userData["token"];

    final response = await http.get(
      Uri.parse('$baseUrl/notify/getAllFCMNotify/$userId'),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json"
      },
    );

    if (response.statusCode == 200) {
      try {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['success'] == true) {
          final List<dynamic> notificationsData = data['data'];

          List<Future<Map<String, String>>> fetchTasks =
              notificationsData.take(3).map((notification) async {
            int idUser = notification['IDUser'] ?? 0;
            String userName = await getUserName(idUser, token) ?? "Unknown";
            String formattedTime =
                calculateTimeDifference(notification['created_at']);

            return {
              "name": userName,
              "action": notification['title']?.toString() ?? '',
              "time": formattedTime,
              "jobId": notification['IDJob']?.toString() ?? ''
            };
          }).toList();

          List<Map<String, String>> newNotifications =
              await Future.wait(fetchTasks);

          setState(() {
            notifications[0]['items'] = newNotifications;
          });
        }
      } catch (e) {
        print("JSON Decode Error: $e");
      }
    }
  }

  Future<void> getYesterdayNotifications() async {
    Map<String, dynamic> userData = await getAuthData();
    if (userData.isEmpty) return;

    int userId = userData["userId"];
    String token = userData["token"];

    final response = await http.get(
      Uri.parse('$baseUrl/notify/getYesterdayNotifications/$userId'),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json"
      },
    );

    if (response.statusCode == 200) {
      try {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['success'] == true) {
          final List<dynamic> notificationsData = data['data'];

          List<Future<Map<String, String>>> fetchTasks =
              notificationsData.map((notification) async {
            int idUser = notification['IDUser'] ?? 0;
            String userName = await getUserName(idUser, token) ?? "Unknown";
            String formattedTime =
                calculateTimeDifference(notification['created_at']);

            return {
              "name": userName,
              "action": notification['title']?.toString() ?? '',
              "time": formattedTime,
              "jobId": notification['IDJob']?.toString() ?? ''
            };
          }).toList();

          List<Map<String, String>> newNotifications =
              await Future.wait(fetchTasks);

          setState(() {
            notifications[1]['items'] = newNotifications;
          });
        }
      } catch (e) {
        print("JSON Decode Error: $e");
      }
    }
  }

  Future<Map<String, dynamic>> getAuthData() async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    int? userId = prefs.getInt('IDUser');

    if (token == null || userId == null) {
      print("⚠️ Token hoặc IDUser không tồn tại!");
      return {};
    }

    return {
      "token": token,
      "userId": userId,
    };
  }

  String calculateTimeDifference(String createdAt) {
    DateTime createdTime = DateTime.parse(createdAt).toLocal();
    Duration difference = DateTime.now().difference(createdTime);

    if (difference.inMinutes < 60) {
      return "${difference.inMinutes} phút trước";
    } else if (difference.inHours < 24) {
      return "${difference.inHours} giờ trước";
    } else {
      return "${difference.inDays} ngày trước";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        actions: [
          CircleAvatar(
            backgroundImage: AssetImage('lib/images/user.png'),
          ),
          SizedBox(width: 16),
        ],
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final section = notifications[index];
          return NotificationSection(
            title: section["section"] as String,
            items: List<Map<String, String>>.from(
                section["items"] as Iterable<dynamic>? ?? []),
          );
        },
      ),
    );
  }
}

class NotificationSection extends StatelessWidget {
  final String title;

  final List<Map<String, String>> items;

  const NotificationSection({
    required this.title,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.grey[700],
          ),
        ),
        SizedBox(height: 10),
        ...items.map((item) => NotificationItem(
              name: item["name"] ?? "Unknown",
              action: item["action"] ?? "Unknown action",
              time: item["time"] ?? "Unknown time",
              jobId: item["jobId"] ?? "",
            )),
        SizedBox(height: 20),
      ],
    );
  }
}

class NotificationItem extends StatelessWidget {
  final String name;
  final String action;
  final String time;
  final String jobId;

  const NotificationItem({
    required this.name,
    required this.action,
    required this.time,
    required this.jobId,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (jobId.isNotEmpty) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => InfoJob(jobId: jobId), // Truyền jobId ở đây
            ),
          );
        } else {
          // Xử lý trường hợp jobId là null hoặc rỗng
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Job ID không tồn tại')),
          );
        }
      },
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundImage: AssetImage('lib/images/user.png'),
                radius: 25,
              ),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: name,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          TextSpan(
                            text: ' $action',
                            style: TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      time,
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(Icons.more_vert),
                onPressed: () {},
              ),
            ],
          ),
          Divider(),
        ],
      ),
    );
  }
}
