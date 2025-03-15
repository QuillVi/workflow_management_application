import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:work_flow/api_constants.dart';

class CreateStageInWorkflow extends StatefulWidget {
  final dynamic workflowId;
  const CreateStageInWorkflow({super.key, required this.workflowId});

  @override
  State<CreateStageInWorkflow> createState() => _CreateStageInWorkflowState();
}

class _CreateStageInWorkflowState extends State<CreateStageInWorkflow> {
  String _description = '';
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  Map<String, dynamic> jsonData = {
    'IDWorkFlow': '1',
    'Name': 'My Workflow',
  };

  Workflow? workflow;
  bool _isEditing = false;
  String _title = '';

  Future<void> _loadNameWorkflow() async {
    try {
      final token = await _getToken();
      if (token == null) {
        print('Token not found');
        _showSnackBar('Token không tồn tại, vui lòng đăng nhập lại');
        return;
      }

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
      } else if (response.statusCode == 401) {
        // Nếu token hết hạn, thử làm mới token
        print('Token hết hạn, đang làm mới token...');
        final data = jsonDecode(response.body);
        if (data.containsKey('token')) {
          await _setToken(data['token']);
          _loadNameWorkflow(); // Gọi lại hàm _loadNameWorkflow sau khi làm mới token
        } else {
          _showSnackBar('Không thể làm mới token');
          print("Không thể làm mới token.");
        }
      } else {
        print('Failed to load workflow');
      }
    } catch (error) {
      print('Error loading workflow: $error');
    }
  }

  Future<void> _createStage() async {
    try {
      final token = await _getToken();
      final name = _titleController.text;
      final description = _descriptionController.text;

      if (token == null) {
        print('Token not found');
        _showSnackBar('Token không tồn tại, vui lòng đăng nhập lại');
        return;
      }

      final response = await http.post(
        Uri.parse('$baseUrl/stage/create'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'NameStage': name,
          'DescriptionStatus': description,
          'IDWorkFlow': widget.workflowId,
        }),
      );

      if (response.statusCode == 200) {
        setState(() {
          _titleController.clear();
          _descriptionController.clear();
        });
      } else if (response.statusCode == 401) {
        // Nếu token hết hạn, thử làm mới token
        print('Token hết hạn, đang làm mới token...');
        final data = jsonDecode(response.body);
        if (data.containsKey('token')) {
          await _setToken(data['token']);
          _createStage(); // Gọi lại hàm _createStage sau khi làm mới token
        } else {
          _showSnackBar('Không thể làm mới token');
          print("Không thể làm mới token.");
        }
      } else {
        print('Failed to create stage: ${response.body}');
      }
    } catch (error) {
      print('Error creating stage: $error');
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
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _isEditing = true;
                    });
                  },
                  child: _isEditing
                      ? TextField(
                          controller: _titleController,
                          decoration: InputDecoration(
                            labelText: 'Tên Stage',
                          ),
                        )
                      : Text(
                          'Tên Stage',
                          style:
                              TextStyle(color: Colors.grey[600], fontSize: 18),
                        ),
                ),
                SizedBox(height: 20),
                _isEditing
                    ? TextFormField(
                        controller: _descriptionController,
                        decoration: InputDecoration(
                          labelText: 'Mô tả Stage',
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 5,
                      )
                    : Text(
                        'Chưa có mô tả',
                        style: TextStyle(color: Colors.grey[600], fontSize: 16),
                      ),
              ],
            ),
          ),
          const SizedBox(height: 50),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.only(right: 10),
                height: 40,
                width: 280,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: TextButton(
                  child: Text(
                    'Tạo stage',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () async {
                    _createStage();
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          )
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
