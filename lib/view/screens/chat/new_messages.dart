import 'package:flutter/material.dart';
import 'package:work_flow/themes/primarycolor.dart';

class NewMessages extends StatefulWidget {
  const NewMessages({super.key});

  @override
  State<NewMessages> createState() => _NewMessagesState();
}

class _NewMessagesState extends State<NewMessages> {
  @override
  final Map<String, List<String>> contacts = {
    'A': ['Amelia', 'Alexander', 'Avery', 'Asher'],
    'B': ['Berrett', 'Benjamin', 'Brayden', 'Braxton'],
    'C': ['Charlotte', 'Camelia'],
    'D': ['Daniel', 'Dylan', 'Dylan', 'Dylan'],
    'E': ['Ethan', 'Elena'],
    'F': ['Felix', 'Faith'],
    'G': ['Grace', 'Giovanni', 'Giselle', 'Gael'],
  };
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      appBar: AppBar(
        backgroundColor: AppColor.whiteColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColor.blackColor),
          onPressed: () {},
        ),
        title:
            Text('New Messages', style: TextStyle(color: AppColor.blackColor)),
        actions: [
          IconButton(
            icon: Icon(Icons.edit, color: AppColor.blackColor),
            onPressed: () {},
          )
        ],
        centerTitle: true,
      ),
      body: ListView(
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundColor: AppColor.buleColor,
              child: Icon(Icons.group, color: AppColor.whiteColor),
            ),
            title: Text('Create a Group',
                style: TextStyle(color: AppColor.blackColor)),
            onTap: () {},
          ),
          for (var letter in contacts.keys) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                letter,
                style: TextStyle(
                    color: AppColor.buleColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
            ),
            for (var name in contacts[letter]!) ...[
              ListTile(
                leading: CircleAvatar(
                  backgroundImage: AssetImage('lib/images/user.png'),
                ),
                title: Text(name, style: TextStyle(color: AppColor.blackColor)),
              )
            ]
          ],
        ],
      ),
    );
  }
}
