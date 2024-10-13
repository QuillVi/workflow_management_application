import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:work_flow/api_constants.dart';

class CreateNewWorkflow extends StatefulWidget {
  const CreateNewWorkflow({super.key});

  @override
  State<CreateNewWorkflow> createState() => _CreateNewWorkflowState();
}

class _CreateNewWorkflowState extends State<CreateNewWorkflow> {
  bool _isEditing = false;

  String _description = '';
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  Future<void> createWorkflow() async {
    final token = await _getToken();
    final name = _titleController.text;
    final description = _descriptionController.text;

    if (token != null) {
      final response = await http.post(
        Uri.parse('$baseUrl/workflow/create'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'Name': name,
          'Description': description,
          'IDUser': 1,
        }),
      );

      if (response.statusCode == 201) {
        final responseBody = jsonDecode(response.body);
        final Name = responseBody['Name'];
        final Description = responseBody['Description'];

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$Name đã tạo thành công'),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi khi tạo workflow: ${response.statusCode}'),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Token không tồn tại, vui lòng đăng nhập lại'),
        ),
      );
    }
  }

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _titleController.dispose();
    super.dispose();
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
        title: Text(
          'Workflow',
          style: TextStyle(color: Colors.black, fontSize: 18),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Thêm Stage',
                  style: TextStyle(color: Colors.black, fontSize: 12),
                ),
              ],
            ),
            onPressed: () {},
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
                            labelText: 'Tên workflow',
                          ),
                        )
                      : Text(
                          'Tên workflow',
                          style:
                              TextStyle(color: Colors.grey[600], fontSize: 18),
                        ),
                ),
                SizedBox(height: 20),
                _isEditing
                    ? TextFormField(
                        controller: _descriptionController,
                        decoration: InputDecoration(
                          labelText: 'Mô tả workflow',
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
                    'Tạo workflow',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () async {
                    createWorkflow();
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
