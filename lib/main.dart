import 'package:flutter/material.dart';
import 'package:work_flow/view/screens/dash_board/mybottomnavigationbar.dart';
import 'package:work_flow/view/screens/login_app/rigister.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Rigister(),
    );
  }
}
