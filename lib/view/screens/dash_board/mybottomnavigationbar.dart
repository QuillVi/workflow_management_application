import 'package:flutter/material.dart';
import 'package:work_flow/themes/primarycolor.dart';
import 'package:work_flow/view/screens/chat/chat_dash_board.dart';
import 'package:work_flow/view/screens/tasks/my_task_dash_board.dart';
import 'package:work_flow/view/screens/dash_board/category_board.dart';
import 'package:work_flow/view/screens/dash_board/dash_board.dart';
import 'package:work_flow/view/screens/dash_board/notification.dart';
import 'package:work_flow/view/screens/dash_board/profile_board.dart';

class Mybottomnavigationbar extends StatefulWidget {
  const Mybottomnavigationbar({super.key});

  @override
  State<Mybottomnavigationbar> createState() => _MybottomnavigationbarState();
}

class _MybottomnavigationbarState extends State<Mybottomnavigationbar> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    DashBoard(),
    CategoryBoard(),
    MyTaskDashBoard(),
    NotificationsScreen(),
    ProfileBoard(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          const BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.assignment_outlined),
            label: 'Category',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.add_circle_outlined,
              color: AppColor.primaryColor,
              size: 40,
            ),
            label: '',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.notifications_outlined),
            label: 'Notify',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.person_outlined),
            label: 'Profile',
          ),
        ],
        selectedItemColor: AppColor.primaryColor,
        unselectedItemColor: AppColor.blackColor,
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
