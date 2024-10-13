import 'package:flutter/material.dart';

class NotificationChats extends StatefulWidget {
  const NotificationChats({super.key});

  @override
  State<NotificationChats> createState() => _NotificationChatsState();
}

class _NotificationChatsState extends State<NotificationChats> {
  @override
  final List<Map<String, dynamic>> newNotifications = [
    {
      'name': 'Olivia Anna',
      'avatar': 'assets/avatar1.png',
      'message': 'left a comment in task',
      'project': 'Mobile App Design Project',
      'time': '31 min'
    },
    {
      'name': 'Robert Brown',
      'avatar': 'assets/avatar2.png',
      'message': 'left a comment in task',
      'project': 'Mobile App Design Project',
      'time': '31 min'
    },
    {
      'name': 'Sophia',
      'avatar': 'assets/avatar3.png',
      'message': 'left a comment in task',
      'project': 'Mobile App Design Project',
      'time': '31 min'
    },
    {
      'name': 'Anna',
      'avatar': 'assets/avatar4.png',
      'message': 'left a comment in task',
      'project': 'Mobile App Design Project',
      'time': '31 min'
    },
  ];

  final List<Map<String, dynamic>> earlierNotifications = [
    {
      'name': 'Robert Brown',
      'avatar': 'assets/avatar2.png',
      'message': 'marked the task',
      'project': 'Mobile App Design Project',
      'time': '4 hours'
    },
    {
      'name': 'Sophia',
      'avatar': 'assets/avatar3.png',
      'message': 'left a comment in task',
      'project': 'Mobile App Design Project',
      'time': '31 min'
    },
    {
      'name': 'Anna',
      'avatar': 'assets/avatar4.png',
      'message': 'left a comment in task',
      'project': 'Mobile App Design Project',
      'time': '31 min'
    },
  ];
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {},
        ),
        title: Text('Notifications'),
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          Text('New',
              style: TextStyle(
                  color: Colors.yellow,
                  fontSize: 18,
                  fontWeight: FontWeight.bold)),
          ...newNotifications.map((notification) => ListTile(
                leading: CircleAvatar(
                  backgroundImage: AssetImage(notification['avatar']),
                ),
                title: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                          text: notification['name'],
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                      TextSpan(
                          text: ' ${notification['message']} ',
                          style: TextStyle(color: Colors.white)),
                      TextSpan(
                          text: notification['project'],
                          style: TextStyle(color: Colors.yellow)),
                    ],
                  ),
                ),
                trailing: Text(notification['time'],
                    style: TextStyle(color: Colors.grey)),
              )),
          SizedBox(height: 16),
          Text('Earlier',
              style: TextStyle(
                  color: Colors.yellow,
                  fontSize: 18,
                  fontWeight: FontWeight.bold)),
          ...earlierNotifications.map((notification) => ListTile(
                leading: CircleAvatar(
                  backgroundImage: AssetImage(notification['avatar']),
                ),
                title: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                          text: notification['name'],
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                      TextSpan(
                          text: ' ${notification['message']} ',
                          style: TextStyle(color: Colors.white)),
                      TextSpan(
                          text: notification['project'],
                          style: TextStyle(color: Colors.yellow)),
                    ],
                  ),
                ),
                trailing: Text(notification['time'],
                    style: TextStyle(color: Colors.grey)),
              )),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_box, size: 40, color: Colors.yellow),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            label: 'Activity',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Setting',
          ),
        ],
        currentIndex: 4,
        selectedItemColor: Colors.yellow,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.black,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
