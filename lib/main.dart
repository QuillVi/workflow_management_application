import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:work_flow/view/screens/dash_board/mybottomnavigationbar.dart';
import 'package:work_flow/view/screens/dash_board/user_bottomnavigationbar.dart';
import 'package:work_flow/view/screens/splash_creen/splash_creen_word_group_1.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isSplashDone = false;
  bool? _isLoggedIn;
  String? _userRole;

  @override
  void initState() {
    super.initState();
    _startSplashScreen();
  }

  Future<void> _startSplashScreen() async {
    await Future.delayed(const Duration(seconds: 2));

    final loggedIn = await isLoggedIn();
    final role = await getUserRole();

    setState(() {
      _isSplashDone = true;
      _isLoggedIn = loggedIn;
      _userRole = role;
    });
  }

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token') != null;
  }

  Future<String?> getUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('role');
  }

  @override
  Widget build(BuildContext context) {
    if (!_isSplashDone) {
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
                    image: const DecorationImage(
                      image: AssetImage('lib/images/managetment.png'),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                const Text(
                  'App Management',
                  style: TextStyle(fontSize: 15),
                ),
              ],
            ),
          ),
          nextScreen: SplashCreenWordGroup1(),
          splashTransition: SplashTransition.fadeTransition,
          backgroundColor: Colors.white,
        ),
      );
    } else {
      // if (_isLoggedIn == true) {
      //   return MaterialApp(
      //     debugShowCheckedModeBanner: false,
      //     home: (_userRole == 'admin')
      //         ? Mybottomnavigationbar()
      //         : UserBottomNavigationBar(),
      //   );
      // } else {
      //   return MaterialApp(
      //     debugShowCheckedModeBanner: false,
      //     home: SplashCreenWordGroup1(),
      //   );
      // }
      if (_isLoggedIn == true) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Mybottomnavigationbar(),
        );
      } else {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          home: SplashCreenWordGroup1(),
        );
      }
    }
  }
}
