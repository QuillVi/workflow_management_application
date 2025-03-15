import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:work_flow/api_constants.dart';
import 'package:work_flow/views/screens/jobs/create_job.dart';
import 'package:work_flow/views/screens/jobs/info_job.dart';
import 'package:work_flow/views/screens/tasks/create_task.dart';

class Job extends StatefulWidget {
  const Job({super.key});

  @override
  State<Job> createState() => _JobState();
}

class _JobState extends State<Job> {
  bool _isEditing = false;
  String _title = 'Tasks';
  List _jobs = [];
  bool _isLoading = true;

  Future<void> _loadJobs() async {
    try {
      // Lấy token từ SharedPreferences
      final token = await _getToken();

      if (token == null) {
        print('Token not found');
        _showSnackBar('Token không tồn tại, vui lòng đăng nhập lại');
        return;
      }

      // Gửi yêu cầu để lấy tất cả công việc
      final response = await http.get(
        Uri.parse('$baseUrl/job/getAll'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        // Nếu mã trạng thái là 200, phân tích dữ liệu và cập nhật UI
        final jsonData = jsonDecode(response.body);
        setState(() {
          _jobs = jsonData;
        });
      } else if (response.statusCode == 401) {
        // Nếu mã trạng thái là 401, token hết hạn, thử làm mới token
        print('Token hết hạn, đang làm mới token...');
        final data = jsonDecode(response.body);
        if (data.containsKey('token')) {
          // Lưu lại token mới
          await _setToken(data['token']);
          // Gọi lại hàm _loadJobs sau khi token đã được làm mới
          _loadJobs();
        } else {
          _showSnackBar('Không thể làm mới token');
          print("Không thể làm mới token.");
        }
      } else {
        // Thông báo lỗi nếu mã trạng thái không phải 200 hoặc 401
        print('Failed to load jobs, status code: ${response.statusCode}');
        _showSnackBar('Lỗi khi tải công việc: ${response.statusCode}');
      }
    } catch (e) {
      // Bắt lỗi nếu có sự cố trong quá trình lấy dữ liệu
      print('Lỗi khi tải công việc: $e');
      _showSnackBar('Lỗi xảy ra trong quá trình tải công việc.');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  void initState() {
    super.initState();
    _loadJobs();
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
        actions: [],
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[300],
                    padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CreateTask(),
                      ),
                    );
                  },
                  child: Column(
                    children: [
                      Icon(Icons.add, color: Colors.blue),
                      SizedBox(height: 5),
                      Container(
                        width: 120,
                        height: 20,
                        child: Text(
                          'Tạo Task',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.black, fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[300],
                    padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  onPressed: () {},
                  child: Column(
                    children: [
                      Icon(Icons.delete_outline_outlined, color: Colors.red),
                      SizedBox(height: 5),
                      Container(
                        width: 120,
                        height: 20,
                        child: Text(
                          'Xoá Task',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.black, fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Expanded(
              child: _jobs.isNotEmpty
                  ? ListView.builder(
                      itemCount: _jobs.length,
                      itemBuilder: (context, index) {
                        final job = _jobs[index];
                        final jobName = job['NameJob'] ?? 'Không có tên dự án';

                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => InfoJob(
                                  jobId: job['IDJob'] ?? '',
                                ),
                              ),
                            );
                          },
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    jobName,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    )
                  : Center(
                      child: Text('Đang tải dữ liệu...'),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
