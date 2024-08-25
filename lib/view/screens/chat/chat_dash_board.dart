import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:work_flow/themes/primarycolor.dart';

class ChatDashBoard extends StatefulWidget {
  const ChatDashBoard({super.key});

  @override
  State<ChatDashBoard> createState() => _ChatDashBoardState();
}

class _ChatDashBoardState extends State<ChatDashBoard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        backgroundColor: whiteColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: blackColor,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Messages',
          style: TextStyle(color: blackColor),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.edit,
              color: whiteColor,
            ),
            onPressed: () {},
          ),
        ],
        centerTitle: true,
      ),
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      foregroundColor: whiteColor,
                      backgroundColor: buleColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text('Chat'),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      foregroundColor: blackColor,
                      backgroundColor: greyColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text('Groups'),
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: ListView(
              children: [
                ChatListItem(
                  name: 'Olivia Anna',
                  message: 'Hi, please check the last task, that I...',
                  time: '31 min',
                  avatar: 'lib/images/user.png',
                ),
                ChatListItem(
                  name: 'Emna',
                  message: 'Hi, please check the last task, that I...',
                  time: '43 min',
                  avatar: 'lib/images/user.png',
                ),
                ChatListItem(
                  name: 'Robert Brown',
                  message: 'Hi, please check the last task, that I...',
                  time: '6 Nov',
                  avatar: 'lib/images/user.png',
                ),
                ChatListItem(
                  name: 'James',
                  message: 'Hi, please check the last task, that I...',
                  time: '8 Dec',
                  avatar: 'lib/images/user.png',
                ),
                ChatListItem(
                  name: 'Sophia',
                  message: 'Hi, please check the last task, that I...',
                  time: '27 Dec',
                  avatar: 'lib/images/user.png',
                ),
                ChatListItem(
                  name: 'Isabella',
                  message: 'Hi, please check the last task, that I...',
                  time: '31 min',
                  avatar: 'lib/images/user.png',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ChatListItem extends StatelessWidget {
  final String name;
  final String message;
  final String time;
  final String avatar;

  const ChatListItem({
    Key? key,
    required this.name,
    required this.message,
    required this.time,
    required this.avatar,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: AssetImage(avatar),
      ),
      title: Text(
        name,
        style: TextStyle(color: blackColor),
      ),
      subtitle: Text(
        message,
        style: TextStyle(color: Colors.grey),
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            time,
            style: TextStyle(color: Colors.grey),
          ),
          if (time.contains('min'))
            Icon(
              Icons.circle,
              color: greenColor,
              size: 12,
            ),
        ],
      ),
    );
  }
}
