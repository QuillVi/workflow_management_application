import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:work_flow/api_constants.dart';

class CreateProject extends StatefulWidget {
  const CreateProject({super.key});

  @override
  State<CreateProject> createState() => _CreateProjectState();
}

class _CreateProjectState extends State<CreateProject> {
  final TextEditingController infoProjectController = TextEditingController();
  final TextEditingController nameProjectController = TextEditingController();

  Future<void> _createProject() async {
    try {
      final token = await _getToken();
      if (token == null) {
        _showSnackBar('Token is null. Please login again.');
        return;
      }

      final String infoProject = infoProjectController.text;
      final String nameProject = nameProjectController.text;
      final int idUser = 1;
      final int idJob = 1;
      final int groupId = 44;

      final response = await http.post(
        Uri.parse('$baseUrl/project/create'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'InfoProject': infoProject,
          'NameProject': nameProject,
          'IDUser': idUser,
          'IDJob': idJob,
          'GroupID': groupId,
          'Progress': 'Hoàn thành',
        }),
      );

      if (response.statusCode == 201) {
        _showSnackBar('Project created successfully');
        Navigator.pop(context);
      } else if (response.statusCode == 401) {
        // Token hết hạn, thử làm mới token và gửi lại yêu cầu
        print('Token expired, refreshing...');
        final data = jsonDecode(response.body);
        if (data.containsKey('token')) {
          await _setToken(data['token']);
          _createProject(); // Thử lại sau khi làm mới token
        } else {
          _showSnackBar('Failed to refresh token');
          print("Failed to refresh token.");
        }
      } else {
        _showSnackBar('Failed to create project: ${response.body}');
      }
    } catch (e) {
      _showSnackBar('Failed to create project: $e');
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
  void dispose() {
    infoProjectController.dispose();
    nameProjectController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Project'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nameProjectController,
              decoration: const InputDecoration(labelText: 'Name Project'),
            ),
            TextField(
              controller: infoProjectController,
              decoration: const InputDecoration(labelText: 'Project Info'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _createProject,
              child: const Text('Create Project'),
            ),
          ],
        ),
      ),
    );
  }
}
