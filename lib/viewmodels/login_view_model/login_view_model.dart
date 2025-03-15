import 'package:flutter/material.dart';
import 'package:work_flow/repositorys/login_reponsitory.dart';

class LoginViewModel extends ChangeNotifier {
  final LoginRepository loginRepository = LoginRepository();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool keepLoggedIn = false;
  bool obscureText = true;
  bool isLoading = false;

  void toggleObscureText() {
    obscureText = !obscureText;
    notifyListeners();
  }

  Future<void> login(BuildContext context) async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Vui lòng nhập đầy đủ email và mật khẩu!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    isLoading = true;
    notifyListeners();

    await loginRepository.login(
        emailController.text, passwordController.text, context);

    isLoading = false;
    notifyListeners();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
