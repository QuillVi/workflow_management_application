import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:work_flow/api_constants.dart';
import 'package:http/http.dart' as http;

class CreateJob extends StatefulWidget {
  const CreateJob({super.key});

  @override
  State<CreateJob> createState() => _CreateJobState();
}

class _CreateJobState extends State<CreateJob> {
  bool _isEditing = false;

  String _description = '';
  final TextEditingController _namejobController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  Future<void> createJob() async {
    final token = await _getToken();
    if (token == null) {
      _showSnackBar('Token is null. Please login again.');
      return;
    }
    final name = _namejobController.text;
    final description = _descriptionController.text;
    final int IDStage = 1;

    if (token != null) {
      final response = await http.post(
        Uri.parse('$baseUrl/job/create'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'NameJob': name,
          'DescriptionJob': description,
          'IDStage': 1,
        }),
      );

      if (response.statusCode == 201) {
        final responseBody = jsonDecode(response.body);
        final Name = responseBody['NameJob'];
        final Description = responseBody['DescriptionJob'];

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$Name đã tạo thành công'),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi khi tạo job: ${response.statusCode}'),
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

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _namejobController.dispose();
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
          'Job',
          style: TextStyle(color: Colors.black, fontSize: 18),
        ),
        centerTitle: true,
        actions: [],
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
                          controller: _namejobController,
                          decoration: InputDecoration(
                            labelText: 'Tên Job',
                          ),
                        )
                      : Text(
                          'Tên Job',
                          style:
                              TextStyle(color: Colors.grey[600], fontSize: 18),
                        ),
                ),
                SizedBox(height: 20),
                _isEditing
                    ? TextFormField(
                        controller: _descriptionController,
                        decoration: InputDecoration(
                          labelText: 'Mô tả job',
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
                    'Tạo job',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () async {
                    createJob();
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
