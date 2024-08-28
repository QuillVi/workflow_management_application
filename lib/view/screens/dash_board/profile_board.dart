import 'package:flutter/material.dart';
import 'package:work_flow/themes/primarycolor.dart';
import 'package:work_flow/view/screens/create_task/my_task_dash_board.dart';

class ProfileBoard extends StatefulWidget {
  const ProfileBoard({super.key});

  @override
  State<ProfileBoard> createState() => _ProfileBoardState();
}

class _ProfileBoardState extends State<ProfileBoard> {
  bool notificationsOn = true;
  String language = "Tiếng việt";
  String theme = "Sáng";

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
              'Dong Vi',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'youremail@domain.com | +01 234 567 89',
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
            buildProfileOption(Icons.brightness_6_outlined, 'Giao diện',
                trailingText: theme),
            SizedBox(height: 10),
            buildProfileOption(Icons.help_outlined, 'Trợ giúp và hỗ trợ'),
            buildProfileOption(Icons.contact_mail_outlined, 'Liên hệ'),
            buildProfileOption(
                Icons.privacy_tip_outlined, 'Chính sách bảo mật'),
          ],
        ),
      ),
    );
  }

  Widget buildProfileOption(IconData icon, String title,
      {String? trailingText}) {
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
      onTap: () {},
    );
  }
}
