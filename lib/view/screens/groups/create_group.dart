import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:work_flow/api_constants.dart';

class CreateGroup extends StatefulWidget {
  const CreateGroup({super.key});

  @override
  State<CreateGroup> createState() => _CreateGroupState();
}

class _CreateGroupState extends State<CreateGroup> {
  final TextEditingController groupNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  List<String> emailList = [];

  String? token;

  Future<void> createGroupAndAddMembers() async {
    token = await _getToken();

    if (token == null) {
      print('Token is null. Please login again.');
      return;
    }

    final String groupName = groupNameController.text.trim();
    final int idUser = 1;

    if (groupName.isEmpty) {
      print('Group name is required.');
      return;
    }

    if (emailController.text.isNotEmpty) {
      emailList.add(emailController.text);
      emailController.clear();
    }

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/group/create'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          'groupName': groupName,
          'IDUser': idUser,
        }),
      );

      print(response.body);
      if (response.statusCode == 201) {
        final Map<String, dynamic> data = json.decode(response.body);
        final int groupId = data['group']['GroupID'];

        print('Group created with ID: $groupId');
        await addMembersToGroup(groupId);
        Navigator.pop(context);
      } else {
        print('Failed to create group: ${response.body}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> addMembersToGroup(int groupId) async {
    print('Adding members to group with ID: $groupId');
    print('EmailList: $emailList');

    if (emailList.isEmpty) {
      print('No emails to add to the group.');
      return;
    }

    String? token = await _getToken();
    if (token == null) {
      print("Token không tồn tại, vui lòng đăng nhập lại.");
      return;
    }

    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/group/addMember'),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
            body: json.encode({
              'emails': emailList,
              'groupId': groupId,
            }),
          )
          .timeout(const Duration(seconds: 3));

      if (response.statusCode == 200) {
        print('Members added successfully!');
      } else {
        print('Failed to add members: ${response.body}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Group'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: groupNameController,
              decoration: InputDecoration(labelText: 'Group Name'),
            ),
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
              onSubmitted: (value) {
                setState(() {
                  emailList.add(value);
                  emailController.clear();
                });
              },
            ),
            Expanded(
              child: ListView.builder(
                itemCount: emailList.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(emailList[index]),
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: createGroupAndAddMembers,
              child: Text('Create Group and Add Members'),
            ),
          ],
        ),
      ),
    );
  }
}
