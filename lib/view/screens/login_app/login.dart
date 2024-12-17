import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:work_flow/api_constants.dart';
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
      final response = await post(
        Uri.parse('$baseUrl/login'),
        body: {
          'username': email,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> mapResponse = jsonDecode(response.body);

        print('Phản hồi API đăng nhập: $mapResponse');
        updateData(mapResponse);

        if (mapResponse['token'] != null &&
            mapResponse['token'].toString().isNotEmpty) {
          final prefs = await SharedPreferences.getInstance();
          prefs.setString('token', mapResponse['token']);

          // Hiện thông báo thành công
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Đăng nhập thành công!'),
              backgroundColor: Colors.green,
              duration: Duration(milliseconds: 500),
            ),
          );

          await Future.delayed(Duration(seconds: 1));

          // Chuyển đến màn hình chính
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Mybottomnavigationbar()),
          );
        }
      } else {
        // Hiện thông báo lỗi đăng nhập
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Đăng nhập không thành công!'),
            backgroundColor: Colors.red,
          ),
        );
        print('Lỗi: ${response.statusCode}');
      }
    } catch (e) {
      // Hiện thông báo lỗi ngoại lệ
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Đã xảy ra lỗi: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
      print('Lỗi: ${e.toString()}');
    }
  }

  void updateData(Map<String, dynamic> mapResponse) async {
    final pref = await SharedPreferences.getInstance();
    print('IDUser được lưu: ${mapResponse['IDUser']}');
    pref.setString('name', mapResponse['Name']);
    pref.setInt('iduser', mapResponse['IDUser']);
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
                'Login',
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
                  labelText: 'Password',
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
                  'Login',
                  style: TextStyle(fontSize: 16, color: AppColor.whiteColor),
                ),
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(child: Divider()),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text("or login with"),
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
