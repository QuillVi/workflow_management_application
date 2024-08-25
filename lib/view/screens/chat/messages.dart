import 'package:flutter/material.dart';
import 'package:work_flow/themes/primarycolor.dart';

class Messages extends StatefulWidget {
  const Messages({super.key});

  @override
  State<Messages> createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        backgroundColor: whiteColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: blackColor),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: AssetImage('lib/images/user.png'),
            ),
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Olivia Anna',
                  style: TextStyle(color: blackColor),
                ),
                Text('Online',
                    style: TextStyle(fontSize: 12, color: blackColor)),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.video_call,
              color: whiteColor,
            ),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.call, color: blackColor),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(10),
              children: [
                ChatBubble(
                  text: 'Hi, please check the new task.',
                  isSender: false,
                ),
                ChatBubble(
                  text: 'Hi, please check the new task.',
                  isSender: true,
                  seen: true,
                ),
                ChatBubble(
                  text: 'Got it. Thanks.',
                  isSender: false,
                ),
                ChatBubble(
                  text:
                      'Hi, please check the last task, that I have completed.',
                  isSender: false,
                ),
                ChatBubble(
                  text: 'Got it. Will check it soon.',
                  isSender: true,
                  seen: true,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.menu, color: buleColor),
                  onPressed: () {},
                ),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: greyColor,
                      hintText: 'Type a message',
                      hintStyle: TextStyle(color: Colors.grey[600]),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send, color: buleColor),
                  onPressed: () {},
                ),
                IconButton(
                  icon: Icon(Icons.mic, color: buleColor),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ChatBubble extends StatelessWidget {
  final String text;
  final bool isSender;
  final bool seen;

  const ChatBubble({
    Key? key,
    required this.text,
    this.isSender = false,
    this.seen = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isSender ? Colors.blue : greyColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment:
              isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(
              text,
              style: TextStyle(color: isSender ? whiteColor : blackColor),
            ),
            if (isSender && seen)
              Text(
                'Seen',
                style: TextStyle(color: whiteColor, fontSize: 10),
              ),
          ],
        ),
      ),
    );
  }
}
