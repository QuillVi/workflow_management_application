import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:work_flow/api_constants.dart';
import 'package:work_flow/view/screens/login_app/login.dart';
import 'package:http/http.dart' as http;

class ProfileBoard extends StatefulWidget {
  const ProfileBoard({super.key});

  @override
  State<ProfileBoard> createState() => _ProfileBoardState();
}

Map mapResponse = {};
int? iduser;

class _ProfileBoardState extends State<ProfileBoard> {
  final bool notificationsOn = true;
  final String language = "Tiếng Việt";
  String theme = "Sáng";

  String? name;
  String? username;
  String? phone;

  @override
  void initState() {
    _getUserProfile();
    super.initState();
  }

  Future<void> _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => Login()),
      (route) => false,
    );
  }

  Future<void> _getUserProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final idUser = prefs.getInt('idUser');
    print('IDUser: $idUser');
    if (idUser != null) {
      final token = await _getToken();
      if (token != null) {
        final response = await http.get(
          Uri.parse('$baseUrl/appUser/$idUser'),
          headers: {
            'Authorization': 'Bearer $token',
          },
        );

        if (response.statusCode == 200) {
          final jsonData = jsonDecode(response.body);
          setState(() {
            name = jsonData['Name'];
            username = jsonData['Username'];
            phone = jsonData['Phone'];
          });
        } else {
          print('Failed to load user profile');
        }
      } else {
        print('Token not found');
      }
    } else {
      print('IDUser not found');
    }
  }

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  void _getDataUser() async {
    final pref = await SharedPreferences.getInstance();
    setState(() {
      iduser = pref.getInt('iduser' ?? 'not found');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.notifications_active_outlined, color: Colors.black),
          onPressed: () {},
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('lib/images/user.png'),
              child: Align(
                alignment: Alignment.bottomRight,
                child: CircleAvatar(
                  radius: 15,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.edit, size: 16, color: Colors.black),
                ),
              ),
            ),
            SizedBox(height: 10),
            Text(
              '$name',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '$username | $phone',
              style: TextStyle(
                fontSize: 14,
                color: Colors.black54,
              ),
            ),
            SizedBox(height: 20),
            buildProfileOption(
                Icons.person_outlined, 'Chỉnh sửa thông tin trang cá nhân'),
            buildProfileOption(Icons.notifications_outlined, 'Nhận thông báo',
                trailingText: notificationsOn ? 'Bật' : 'Tắt'),
            buildProfileOption(Icons.language_outlined, 'Ngôn ngữ',
                trailingText: language),
            SizedBox(height: 10),
            buildProfileOption(Icons.security_outlined, 'Bảo mật'),
            buildProfileOption(
              Icons.brightness_6_outlined,
              'Giao diện',
              trailingText: theme,
              onTap: () {},
            ),
            SizedBox(height: 10),
            buildProfileOption(Icons.help_outlined, 'Trợ giúp và hỗ trợ'),
            buildProfileOption(Icons.contact_mail_outlined, 'Liên hệ'),
            buildProfileOption(
                Icons.privacy_tip_outlined, 'Chính sách bảo mật'),
            buildProfileOption(Icons.exit_to_app, 'Đăng xuất',
                onTap: () => _logout(context)),
          ],
        ),
      ),
    );
  }

  Widget buildProfileOption(IconData icon, String title,
      {String? trailingText, VoidCallback? onTap}) {
    return ListTile(
      leading: Icon(icon, color: Colors.black),
      title: Text(
        title,
        style: TextStyle(fontSize: 13),
      ),
      trailing: trailingText != null
          ? Text(
              trailingText,
              style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
            )
          : null,
      onTap: onTap,
    );
  }
}
