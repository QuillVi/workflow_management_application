import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:work_flow/api_constants.dart';
import 'package:http/http.dart' as http;

class CategoryViewJobTodo extends StatefulWidget {
  const CategoryViewJobTodo({super.key});

  @override
  State<CategoryViewJobTodo> createState() => _CategoryViewJobTodoState();
}

class _CategoryViewJobTodoState extends State<CategoryViewJobTodo> {
  bool _isEditing = false;
  String _title = 'Jobs Đang thực hiện';
  late Future<int> totalJobsToDo;

  Future<List<Map<String, dynamic>>> fetchTotalJobsToDo() async {
    try {
      // Lấy token và IDUser từ SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      final idUser = prefs.getInt('IDUser');

      if (token == null || token.isEmpty) {
        throw Exception('Token không tồn tại. Vui lòng đăng nhập lại.');
      }

      if (idUser == null) {
        throw Exception('IDUser không tồn tại.');
      }

      // Gọi API
      final url = Uri.parse('$baseUrl/job/getjobstodo/$idUser');
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      // Kiểm tra trạng thái phản hồi
      if (response.statusCode != 200) {
        throw Exception('Lỗi khi gọi API: ${response.statusCode}');
      }

      // Phân tích dữ liệu JSON
      final responseData = json.decode(response.body);

      if (responseData['success'] != true || responseData['data'] == null) {
        throw Exception('Dữ liệu trả về không hợp lệ.');
      }

      // Trích xuất dữ liệu công việc
      final jobs = (responseData['data'] as List).map((job) {
        return {
          'IDJob': job['IDJob'],
          'NameJob': job['NameJob'],
          'TimeStart': job['TimeStart'],
          'Status': job['Status'],
        };
      }).toList();

      return jobs;
    } catch (error) {
      print('Lỗi khi lấy công việc: $error');
      return [];
    }
  }

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  @override
  void initState() {
    super.initState();
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FutureBuilder<List<Map<String, dynamic>>>(
                future: fetchTotalJobsToDo(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('Lỗi: ${snapshot.error}'),
                    );
                  } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                    // Hiển thị danh sách các công việc
                    return Column(
                      children: snapshot.data!.map((job) {
                        return buildShipmentCard(
                          id: job['IDJob'].toString(),
                          namejob: job['NameJob'],
                          date: job['TimeStart']
                              .substring(0, 10), // Lấy ngày từ TimeStart
                          from:
                              'dong vi', // Thay thế bằng dữ liệu phù hợp nếu cần
                          status: job['Status'],
                        );
                      }).toList(),
                    );
                  } else {
                    return Center(
                      child: Text(
                        'Không có công việc nào với trạng thái "to do".',
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget buildShipmentCard({
  required String id,
  required String namejob,
  required String date,
  required String from,
  required String status,
}) {
  return Card(
    elevation: 4,
    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    child: Padding(
      padding: EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon hoặc hình ảnh minh họa
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.blue.shade100,
            child: Text(
              id,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.blue.shade800,
              ),
            ),
          ),
          SizedBox(width: 16),
          // Nội dung chính
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Tên công việc
                Text(
                  namejob,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 8),
                // Ngày bắt đầu
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: 16,
                      color: Colors.grey,
                    ),
                    SizedBox(width: 8),
                    Text(
                      date,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                // Nguồn gốc công việc
                Row(
                  children: [
                    Icon(
                      Icons.location_pin,
                      size: 16,
                      color: Colors.grey,
                    ),
                    SizedBox(width: 8),
                    Text(
                      from,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                // Trạng thái
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: status == 'to do'
                        ? Colors.orange.shade100
                        : Colors.green.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    status.toUpperCase(),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: status == 'to do'
                          ? Colors.orange.shade800
                          : Colors.green.shade800,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
