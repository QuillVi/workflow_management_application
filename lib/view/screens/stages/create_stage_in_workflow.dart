import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class CreateStageInWorkflow extends StatefulWidget {
  final dynamic workflowId;
  const CreateStageInWorkflow({super.key, required this.workflowId});

  @override
  State<CreateStageInWorkflow> createState() => _CreateStageInWorkflowState();
}

class _CreateStageInWorkflowState extends State<CreateStageInWorkflow> {
  String baseUrl = 'http://192.168.1.3:3000/api';

  Map<String, dynamic> jsonData = {
    'IDWorkFlow': '1',
    'Name': 'My Workflow',
  };

  Workflow? workflow;
  bool _isEditing = false;
  String _title = '';

  Future<void> _loadNameWorkflow() async {
    final token = await _getToken();

    if (token != null) {
      final response = await http.get(
        Uri.parse('$baseUrl/workFlow/${widget.workflowId}'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        setState(() {
          _title = jsonData['Name'] ?? 'No Title';
        });
      } else {
        print('Failed to load workflow');
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
    _loadNameWorkflow();
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
            onPressed: () {
              // Xử lý menu
            },
          ),
        ],
      ),
    );
  }
}

class Workflow {
  final String IDWorkflow;
  final String Name;
  Workflow({required this.IDWorkflow, required this.Name});

  factory Workflow.fromJson(Map<String, dynamic> json) {
    return Workflow(
      IDWorkflow: json['IDWorkFlow'],
      Name: json['Name'],
    );
  }
}
