import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:work_flow/themes/primarycolor.dart';
import 'package:work_flow/view/screens/login_app/login.dart';
import 'package:http/http.dart' as http;
import 'dart:io';

class Rigister extends StatefulWidget {
  const Rigister({super.key});

  @override
  State<Rigister> createState() => _RigisterState();
}

class _RigisterState extends State<Rigister> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  void register(String name, String email, String password,
      String confirmPassword) async {
    try {
      final response =
          await post(Uri.parse('http://192.168.1.3:3000/api/register'), body: {
        'name': name,
        'username': email,
        'password': password,
        'password_confirmation': confirmPassword,
      });

      if (response.statusCode == 200) {
        print('Tài khoản được tạo thành công!');
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Login()),
        );
      } else {
        print('Tạo tài khoản thất bại!');
      }
    } catch (e) {
      if (e is SocketException) {
        print('Lỗi kết nối đến server!');
      } else {
        print('Lỗi: ${e.toString()}');
      }
    }
  }

  @override
  void dispose() {
    // Dọn dẹp bộ điều khiển khi widget bị hủy
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Tạo tài khoản',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Họ và tên',
                  border: OutlineInputBorder(),
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
                ),
                obscureText: true,
              ),
              SizedBox(height: 20),
              TextField(
                controller: confirmPasswordController,
                decoration: InputDecoration(
                  labelText: 'Nhập lại mật khẩu',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  register(
                    nameController.text.toString(),
                    emailController.text.toString(),
                    passwordController.text.toString(),
                    confirmPasswordController.text.toString(),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.primaryColor, // Màu nền của nút
                  padding: EdgeInsets.symmetric(vertical: 15),
                  minimumSize: Size(double.infinity, 50), // Chiều rộng của nút
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                child: Text(
                  'Tạo tài khoản',
                  style: TextStyle(fontSize: 16, color: AppColor.whiteColor),
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Bạn đã có tài khoản?'),
                  SizedBox(width: 5),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Login(),
                        ),
                      );
                    },
                    child: Text(
                      'đăng nhập',
                      style: TextStyle(
                        color: AppColor.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
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
