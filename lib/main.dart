import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:work_flow/view/screens/dash_board/mybottomnavigationbar.dart';
import 'package:work_flow/view/screens/splash_creen/splash_creen_word_group_1.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AnimatedSplashScreen(
          duration: 1500,
          splash: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      image: AssetImage('lib/images/managetment.png'),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                Container(
                  child: Text(
                    'App Managetment',
                    style: TextStyle(fontSize: 15),
                  ),
                ),
              ],
            ),
          ),
          nextScreen: SplashCreenWordGroup1(),
          splashTransition: SplashTransition.fadeTransition,
          backgroundColor: Colors.white),
    );
  }
}
