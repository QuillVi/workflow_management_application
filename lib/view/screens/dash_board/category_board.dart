import 'package:flutter/material.dart';
import 'package:work_flow/api_constants.dart';
import 'package:work_flow/themes/primarycolor.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:work_flow/view/screens/jobs/category_view_jobs/category_view_job_completed.dart';
import 'package:work_flow/view/screens/jobs/category_view_jobs/category_view_job_todo.dart';

class CategoryBoard extends StatefulWidget {
  const CategoryBoard({super.key});

  @override
  State<CategoryBoard> createState() => _CategoryBoardState();
}

class _CategoryBoardState extends State<CategoryBoard> {
  late Future<int> totalJobsReceived;
  late Future<int> totalJobsToDo;
  Future<int> fetchTotalJobsReceived() async {
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        throw Exception('Token không tồn tại. Vui lòng đăng nhập lại.');
      }

      final prefs = await SharedPreferences.getInstance();
      final idUser = prefs.getInt('IDUser');
      if (idUser == null) {
        throw Exception('IDUser không tồn tại.');
      }

      // Gọi API
      final url = '$baseUrl/job/totaljobsinweek/$idUser';
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          return data['data']['totalJobsReceived'];
        } else {
          throw Exception(data['message'] ?? 'Lỗi khi gọi API');
        }
      } else {
        throw Exception('HTTP Error: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Error: $error');
    }
  }

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

  Future<List<Map<String, dynamic>>> fetchTotalJobsCompleted() async {
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
      final url = Uri.parse('$baseUrl/job/getjobscompleted/$idUser');
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
    totalJobsReceived = fetchTotalJobsReceived();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Danh mục',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FutureBuilder<int>(
                future: totalJobsReceived,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('Lỗi: ${snapshot.error}'),
                    );
                  } else if (snapshot.hasData) {
                    return GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      childAspectRatio: 1.4,
                      children: [
                        buildStatCard(
                          Icon(Icons.task, color: AppColor.primaryColor),
                          snapshot.data.toString(),
                          'Task',
                          AppColor.primaryColor,
                        ),
                        buildStatCard(
                          Icon(Icons.event, color: AppColor.yellowColor),
                          '0',
                          'Nghỉ phép',
                          AppColor.yellowColor,
                        ),
                        buildStatCard(
                          Icon(Icons.timer, color: AppColor.greenColor),
                          '30',
                          'Chấm công',
                          AppColor.greenColor,
                        ),
                        buildStatCard(
                          Icon(Icons.summarize, color: AppColor.redColor),
                          '136',
                          'Tổng giờ',
                          AppColor.redColor,
                        ),
                      ],
                    );
                  } else {
                    return Center(
                      child: Text('Không có dữ liệu'),
                    );
                  }
                },
              ),
              SizedBox(height: 16),
              buildSectionHeader('Đang thực hiện', onViewAll: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CategoryViewJobTodo(),
                  ),
                );
              }),
              SizedBox(height: 16),
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
                    // Chỉ lấy job đầu tiên từ dữ liệu trả về
                    final job = snapshot.data!.first;
                    return buildShipmentCard(
                      id: job['IDJob'].toString(),
                      namejob: job['NameJob'],
                      date: job['TimeStart']
                          .substring(0, 10), // Lấy ngày từ TimeStart
                      from: 'dong vi', // Thay thế bằng dữ liệu phù hợp nếu cần
                      status: job['Status'],
                    );
                  } else {
                    return Center(
                      child: Text(
                          'Không có công việc nào với trạng thái "to do".'),
                    );
                  }
                },
              ),
              SizedBox(height: 16),
              buildSectionHeader('Đã hoàn thành', onViewAll: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CategoryViewJobCompleted(),
                  ),
                );
              }),
              SizedBox(height: 16),
              FutureBuilder<List<Map<String, dynamic>>>(
                future: fetchTotalJobsCompleted(),
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
                    // Chỉ lấy job đầu tiên từ dữ liệu trả về
                    final job = snapshot.data!.first;
                    return buildShipmentCard(
                      id: job['IDJob'].toString(),
                      namejob: job['NameJob'],
                      date: job['TimeStart']
                          .substring(0, 10), // Lấy ngày từ TimeStart
                      from: 'dong vi', // Thay thế bằng dữ liệu phù hợp nếu cần
                      status: job['Status'],
                    );
                  } else {
                    return Center(
                      child: Text(
                          'Không có công việc nào với trạng thái "to do".'),
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

  Widget buildStatCard(Icon icon, String count, String label, Color color) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 3,
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          icon,
          SizedBox(width: 8),
          Text(
            count,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black54,
            ),
          ),
          SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSectionHeader(String title, {required VoidCallback onViewAll}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        GestureDetector(
          onTap: onViewAll,
          child: Text(
            'View All',
            style: TextStyle(
              fontSize: 14,
              color: Colors.blue,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget buildShipmentCard({
    required String id,
    required String namejob,
    required String date,
    required String from,
    required String status,
    bool isRecent = false,
  }) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 3,
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  SizedBox(width: 10),
                  Text(
                    id,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    namejob,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              IconButton(
                icon: Icon(isRecent ? Icons.delete : Icons.more_vert),
                onPressed: () {},
              ),
            ],
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.timer_outlined, size: 16),
              SizedBox(width: 4),
              Text(
                isRecent ? '$date' : '$date',
                style: TextStyle(
                  color: Colors.black54,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'From',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(from),
            ],
          ),
          if (!isRecent) ...[
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(status),
              ],
            ),
          ]
        ],
      ),
    );
  }
}
