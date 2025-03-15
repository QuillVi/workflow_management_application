import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:work_flow/viewmodels/profile_view_model/get_user_id_view_model.dart';
import 'package:work_flow/viewmodels/profile_view_model/theme_view_model.dart';
import 'package:work_flow/views/login_views/login_view.dart';

class ProfileBoard extends StatefulWidget {
  const ProfileBoard({super.key});

  @override
  State<ProfileBoard> createState() => _ProfileBoardState();
}

Map mapResponse = {};
String nameUser = '';
int idUser = -1;

class _ProfileBoardState extends State<ProfileBoard> {
  final bool notificationsOn = true;
  final String language = "Tiếng Việt";
  String theme = "Sáng";

  String? name;
  String? username;

  Future<void> _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginView()),
      (route) => false,
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<GetUserIdViewModel>().getUserProfile();
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
      body: Consumer<GetUserIdViewModel>(builder: (context, viewmodel, child) {
        return SingleChildScrollView(
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
                viewmodel.name ?? 'Tên người dùng',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                viewmodel.username ?? 'Tên đăng nhập',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                ),
              ),
              SizedBox(height: 20),
              buildProfileOption(Icons.notifications_outlined, 'Nhận thông báo',
                  trailingText: notificationsOn ? 'Bật' : 'Tắt'),
              buildProfileOption(Icons.language_outlined, 'Ngôn ngữ',
                  trailingText: language),
              SizedBox(height: 10),
              buildProfileOption(Icons.security_outlined, 'Bảo mật'),
              Consumer<ThemeViewModel>(
                builder: (context, themeViewModel, child) {
                  return ListTile(
                    leading: const Icon(Icons.dark_mode, color: Colors.black),
                    title: const Text(
                      'Giao diện',
                      style: TextStyle(fontSize: 13),
                    ),
                    trailing: Switch(
                      value: themeViewModel.isDarkMode,
                      onChanged: (value) {
                        if (value != themeViewModel.isDarkMode) {
                          themeViewModel.changeTheme();
                        }
                      },
                    ),
                  );
                },
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
        );
      }),
    );
  }
}

Widget buildProfileOption(IconData icon, String title,
    {String? trailingText, Function()? onTap}) {
  return ListTile(
    leading: Icon(icon, color: Colors.black),
    title: Text(
      title,
      style: TextStyle(fontSize: 13),
    ),
    trailing: trailingText != null
        ? Text(
            trailingText,
            style: TextStyle(
              fontSize: 13,
              color: Colors.black54,
            ),
          )
        : null,
    onTap: onTap,
  );
}
