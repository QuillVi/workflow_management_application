import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:work_flow/themes/primarycolor.dart';
import 'package:http/http.dart';
import 'package:work_flow/view/screens/dash_board/mybottomnavigationbar.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool keepLoggedIn = false;

  String? finalName;
  bool obscureText = true;

  void login(String email, String password) async {
    try {
      final response =
          await post(Uri.parse('http://192.168.1.3:3000/api/login'), body: {
        'username': email,
        'password': password,
      });

      if (response.statusCode == 200) {
        Map<String, dynamic> mapResponse = jsonDecode(response.body);
        updateData(mapResponse);
        if (mapResponse['token'].toString().isNotEmpty) {
          final prefs = await SharedPreferences.getInstance();
          prefs.setString('token', mapResponse['token']);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Mybottomnavigationbar()),
          );
        }
      } else {
        print('Lỗi: ${response.statusCode}');
      }
    } catch (e) {
      print('Lỗi: ${e.toString()}');
    }
  }

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token') != null;
  }

  void initState() {
    super.initState();
    isLoggedIn().then((isLoggedIn) {
      if (isLoggedIn) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Mybottomnavigationbar()),
        );
      }
    });
  }

  void updateData(Map<String, dynamic> mapResponse) async {
    final pref = await SharedPreferences.getInstance();
    pref.setString('name', mapResponse['Name']);
  }

  Future getValidationData() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    sharedPreferences.setString('name', nameController.text);
    setState(() {
      finalName = sharedPreferences.getString('name');
    });
    print(finalName);
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Đăng nhập',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 20),
              TextField(
                controller: passwordController,
                decoration: InputDecoration(
                  labelText: 'Mật khẩu',
                  border: OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      obscureText ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        obscureText = !obscureText;
                      });
                    },
                  ),
                ),
                obscureText: obscureText,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  login(emailController.text, passwordController.text);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.primaryColor,
                  padding: EdgeInsets.symmetric(vertical: 15),
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                child: Text(
                  'Đăng nhập',
                  style: TextStyle(fontSize: 16, color: AppColor.whiteColor),
                ),
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(child: Divider()),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text("hoặc đăng nhập với"),
                  ),
                  Expanded(child: Divider()),
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: CircleAvatar(
                      radius: 30,
                      backgroundImage: AssetImage('lib/images/face.png'),
                    ),
                    iconSize: 10,
                    onPressed: () {},
                  ),
                  SizedBox(width: 30),
                  IconButton(
                    icon: CircleAvatar(
                      radius: 30,
                      backgroundImage: AssetImage('lib/images/google.png'),
                    ),
                    iconSize: 10,
                    onPressed: () {},
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
