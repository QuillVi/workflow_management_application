import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class InfoGroup extends StatefulWidget {
  final dynamic groupId;
  const InfoGroup({super.key, required this.groupId});

  @override
  State<InfoGroup> createState() => _InfoGroupState();
}

class _InfoGroupState extends State<InfoGroup> {
  bool _isEditing = false;
  String _title = '';
  List<Map<String, dynamic>> _members = [];

  Group? group;

  Future<void> _loadGroup() async {
    final token = await _getToken();

    if (token != null) {
      final response = await http.get(
        Uri.parse('http://192.168.1.3:3000/api/group/${widget.groupId}'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        setState(() {
          _title = jsonData['GroupName'] ?? 'No Title';
        });
      } else {
        print('Failed to load group');
      }
    } else {
      print('Token not found');
    }
  }

  Future<void> _loadMembers() async {
    final token = await _getToken();

    if (token != null) {
      final response = await http.get(
        Uri.parse(
            'http://192.168.1.3:3000/api/group/getMember/${widget.groupId}'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = jsonDecode(response.body);

        setState(() {
          _members = jsonData.cast<Map<String, dynamic>>().map((member) {
            return {
              'Name': member['Name'] ?? 'No Name',
              'Username': member['Username'] ?? 'No Username',
            };
          }).toList();
        });
      } else {
        print('Failed to load members');
      }
    } else {
      print('Token not found');
    }
  }

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  @override
  void initState() {
    super.initState();
    _loadGroup();
    _loadMembers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.close, color: Colors.black),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    _isEditing = true;
                  });
                },
                child: _isEditing
                    ? TextFormField(
                        initialValue: _title,
                        style: TextStyle(color: Colors.black, fontSize: 18),
                        onFieldSubmitted: (value) {
                          setState(() {
                            _title = value;
                            _isEditing = false;
                          });
                        },
                      )
                    : Text(
                        _title,
                        style: TextStyle(color: Colors.black, fontSize: 18),
                      ),
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.more_vert, color: Colors.black),
              onPressed: () {},
            ),
          ],
        ),
        backgroundColor: Colors.white,
        body: Column(
          children: [
            Expanded(
              child: _members.isNotEmpty
                  ? ListView.builder(
                      itemCount: _members.length,
                      itemBuilder: (context, index) {
                        final member = _members[index];
                        final name = member['Name'];
                        final username = member['Username'];

                        return ListTile(
                          title: Text(name),
                          subtitle: Text(username),
                        );
                      },
                    )
                  : Center(child: Text('No members found')),
            ),
          ],
        ));
  }
}

class Group {
  final String IDGroup;
  final String GroupName;
  Group({required this.IDGroup, required this.GroupName});

  factory Group.fromJson(Map<String, dynamic> json) {
    return Group(
      IDGroup: json['IDGroup'],
      GroupName: json['GroupName'],
    );
  }
}
