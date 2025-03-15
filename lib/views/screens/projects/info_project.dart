import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:work_flow/api_constants.dart';

class InfoProject extends StatefulWidget {
  final dynamic projectId;
  const InfoProject({super.key, required this.projectId});

  @override
  State<InfoProject> createState() => _InfoProjectState();
}

class _InfoProjectState extends State<InfoProject> {
  bool _isEditing = false;
  String _title = '';

  Project? project;

  Future<void> _loadProject() async {
    final token = await _getToken();

    if (token != null) {
      final response = await http.get(
        Uri.parse('$baseUrl/project/${widget.projectId}'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        setState(() {
          _title = jsonData['NameProject'] ?? 'No Title';
        });
      } else if (response.statusCode == 401) {
        // Token hết hạn, thử làm mới token và gửi lại yêu cầu
        print('Token expired, refreshing...');
        final data = jsonDecode(response.body);
        if (data.containsKey('token')) {
          await _setToken(data['token']); // Lưu lại token mới
          _loadProject(); // Thử lại sau khi có token mới
        } else {
          print('Failed to refresh token');
        }
      } else {
        print('Failed to load project: ${response.statusCode}');
      }
    } else {
      print('Token not found');
    }
  }

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<void> _setToken(String newToken) async {
    final prefs = await SharedPreferences.getInstance();

    if (prefs.containsKey('token')) {
      await prefs.remove('token');
    }
    await prefs.setString('token', newToken);

    print("Token mới đã được lưu thành công: $newToken");
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  void initState() {
    super.initState();
    _loadProject();
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
              child: Container(
                child: Text('data'),
              ),
            ),
          ],
        ));
  }
}

class Project {
  final String IdProject;
  final String NameProject;
  Project({required this.IdProject, required this.NameProject});

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      IdProject: json['IdProject'],
      NameProject: json['NameProject'],
    );
  }
}
