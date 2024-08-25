import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final List<Map<String, dynamic>> notifications = [
    {
      "section": "New",
      "items": [
        {"name": "Cathy Lerner", "action": "liked your post", "time": "7s ago"},
        {
          "name": "Marvin Anderson",
          "action": "Started following you",
          "time": "30s ago"
        },
        {
          "name": "Timothy Coffey",
          "action": "Commented: Impressive App design...",
          "time": "6m ago"
        },
      ]
    },
    {
      "section": "Today",
      "items": [
        {"name": "Jimmy Love", "action": "liked your post", "time": "14m ago"},
        {
          "name": "Sha Gaines",
          "action": "Started following you",
          "time": "30m ago"
        },
        {
          "name": "Ronald Shores",
          "action": "Commented: Impressive App design...",
          "time": "1h ago"
        },
        {
          "name": "Eileen Conners",
          "action": "Started following you",
          "time": "2h ago"
        },
        {
          "name": "Earl Garcia",
          "action": "Started following you",
          "time": "3h ago"
        },
        {
          "name": "Earl Garcia, Nancy Maio, and 20 others",
          "action": "Started following you",
          "time": "8h ago"
        },
      ]
    },
    {
      "section": "This Week",
      "items": [
        {
          "name": "Ivey Wilson",
          "action": "Started following you",
          "time": "2d ago"
        },
        {
          "name": "Bradley Dame",
          "action": "Started following you",
          "time": "3d ago"
        },
      ]
    },
    {
      "section": "This Month",
      "items": [
        {
          "name": "Tom Joy",
          "action": "Started following you",
          "time": "2w ago"
        },
        {
          "name": "Francis Fidler",
          "action": "Started following you",
          "time": "3w ago"
        },
      ]
    },
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        actions: [
          CircleAvatar(
            backgroundImage: AssetImage('lib/images/user.png'),
          ),
          SizedBox(width: 16),
        ],
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final section = notifications[index];
          return NotificationSection(
            title: section["section"],
            items: section["items"],
          );
        },
      ),
    );
  }
}

class NotificationSection extends StatelessWidget {
  final String title;
  final List<Map<String, String>> items;

  const NotificationSection({
    required this.title,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.grey[700],
          ),
        ),
        SizedBox(height: 10),
        ...items.map((item) => NotificationItem(
              name: item["name"]!,
              action: item["action"]!,
              time: item["time"]!,
            )),
        SizedBox(height: 20),
      ],
    );
  }
}

class NotificationItem extends StatelessWidget {
  final String name;
  final String action;
  final String time;

  const NotificationItem({
    required this.name,
    required this.action,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            CircleAvatar(
              backgroundImage: AssetImage('lib/images/user.png'),
              radius: 25,
            ),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: name,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        TextSpan(
                          text: ' $action',
                          style: TextStyle(color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    time,
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(Icons.more_vert),
              onPressed: () {},
            ),
          ],
        ),
        Divider(),
      ],
    );
  }
}
