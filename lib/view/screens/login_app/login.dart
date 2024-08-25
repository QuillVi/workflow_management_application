import 'package:flutter/material.dart';
import 'package:work_flow/themes/primarycolor.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool keepLoggedIn = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
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
                ),
                obscureText: true,
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Checkbox(
                    value: keepLoggedIn,
                    onChanged: (bool? value) {
                      setState(() {
                        keepLoggedIn = value ?? false;
                      });
                    },
                  ),
                  Text('Giữ đăng nhập'),
                ],
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Xử lý khi nhấn nút "Đăng nhập"
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor, // Màu nền của nút
                  padding: EdgeInsets.symmetric(vertical: 15),
                  minimumSize: Size(double.infinity, 50), // Chiều rộng của nút
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                child: Text(
                  'Đăng nhập',
                  style: TextStyle(fontSize: 16, color: whiteColor),
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
                      radius: 30, // Kích thước của hình tròn
                      backgroundImage: AssetImage(
                          'lib/images/face.png'), // Hình ảnh của Facebook
                    ),
                    iconSize: 10, // Kích thước của IconButton
                    onPressed: () {
                      // Xử lý khi nhấn vào đăng nhập bằng Facebook
                    },
                  ),
                  SizedBox(width: 30),
                  IconButton(
                    icon: CircleAvatar(
                      radius: 30, // Kích thước của hình tròn
                      backgroundImage: AssetImage(
                          'lib/images/google.png'), // Hình ảnh của gg
                    ),
                    iconSize: 10, // Kích thước của IconButton
                    onPressed: () {
                      // Xử lý khi nhấn vào đăng nhập bằng gg
                    },
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
