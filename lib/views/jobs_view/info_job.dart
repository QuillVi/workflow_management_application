import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:work_flow/api_constants.dart';

class InfoJob extends StatefulWidget {
  final dynamic jobId;
  const InfoJob({super.key, required this.jobId});

  @override
  State<InfoJob> createState() => _InfoJobState();
}

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class _InfoJobState extends State<InfoJob> {
  bool _isEditing = false;
  String _title = '';
  Job? job;
  late String selectedStatus;
  final List<String> statusOptions = [
    "to-do",
    "in-progress",
    "review",
    "done",
    "bug"
  ];

  Future<void> _loadJobs(BuildContext context) async {
    try {
      final token = await _getToken();
      final refreshToken = await _getRefreshToken();

      final response = await http.get(
        Uri.parse('$baseUrl/job/${widget.jobId}'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        setState(() {
          job = Job.fromJson(jsonData);
          _title = job?.NameJob ?? 'No Title';
        });
      } else if (response.statusCode == 401) {
        print('Access Token hết hạn. Gọi API refreshToken...');

        final refreshResponse = await http.post(
          Uri.parse('$baseUrl/common/refreshToken'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'refreshToken': refreshToken}),
        );

        if (refreshResponse.statusCode == 200) {
          final refreshData = jsonDecode(refreshResponse.body);
          if (refreshData.containsKey('accessToken')) {
            await _updateToken(refreshData['accessToken']);
            print('Access Token mới đã được cập nhật.');
            return _loadJobs(
                context); // Thử lại sau khi cập nhật Access Token mới
          } else {
            throw Exception('API refreshToken không trả về accessToken.');
          }
        } else {
          throw Exception(
              'Failed to refresh token. Status code: ${refreshResponse.statusCode}');
        }
      } else {
        throw Exception(
            'Failed to fetch data. Status code: ${response.statusCode}');
      }
    } catch (error) {
      if (error.toString().contains('Vui lòng đăng nhập lại')) {
        print('Đã chuyển hướng đến màn hình đăng nhập');
      }
      throw Exception('Error: $error');
    }
  }

  Future<void> updateJobStatus(String newStatus) async {
    final url = Uri.parse("$baseUrl/job/updateJobStatus/${widget.jobId}");

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("token");

      if (token == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text("Lỗi: Không tìm thấy token, vui lòng đăng nhập lại!")),
        );
        return;
      }

      final bodyData = jsonEncode({"Status": newStatus});

      final response = await http.put(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: bodyData,
      );

      print("🔹 Response Status Code: ${response.statusCode}");
      print("🔹 Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData["success"]) {
          setState(() {
            selectedStatus = newStatus;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Cập nhật trạng thái thành công!")),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text("Cập nhật thất bại: ${responseData['message']}")),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  "Lỗi khi gọi API: ${response.statusCode} - ${response.body}")),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Lỗi: ${error.toString()}")),
      );
    }
  }

  Future<void> _updateToken(String newToken) async {
    final prefs = await SharedPreferences.getInstance();

    final currentIDUser = prefs.getInt('IDUser');

    if (currentIDUser != null) {
      print('IDUser cũ được lưu: $currentIDUser');
    } else {
      print('Không tìm thấy IDUser cũ. Có thể chưa được lưu.');
    }

    await prefs.setString('token', newToken);

    if (currentIDUser != null) {
      await prefs.setInt('IDUser', currentIDUser);
    }

    print('Token mới đã được lưu thành công: $newToken');
  }

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<String?> _getRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('refreshToken');
  }

  @override
  void initState() {
    super.initState();
    _loadJobs(context);
    selectedStatus = statusOptions.first;
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
      body: job == null
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle("Description"),
                  _buildInfoCard([
                    _buildDescription(job!.DescriptionJob ?? 'No Description'),
                  ]),
                  SizedBox(height: 20),
                  _buildSectionTitle("Job Information"),
                  _buildInfoCard([
                    _buildInfoRow("Job ID", job!.IDJob.toString()),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Status:",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                        DropdownButton<String>(
                          value: statusOptions.contains(selectedStatus)
                              ? selectedStatus
                              : null,
                          items: statusOptions.map((status) {
                            return DropdownMenuItem(
                              value: status,
                              child: Text(status),
                            );
                          }).toList(),
                          onChanged: (newStatus) {
                            if (newStatus != null) {
                              setState(() {
                                selectedStatus = newStatus;
                              });
                              updateJobStatus(newStatus);
                            }
                          },
                        )
                      ],
                    ),
                    _buildInfoRow("Priority", job!.Priority ?? 'Null'),
                  ]),
                  SizedBox(height: 20),
                  _buildSectionTitle("User Information"),
                  _buildInfoCard([
                    _buildInfoRow("Assigned User ID",
                        job!.IDUserAssign?.toString() ?? 'Null'),
                    _buildInfoRow("Performer User ID",
                        job!.IDUserPerform?.toString() ?? 'Null'),
                    _buildInfoRow("Creator User ID",
                        job!.IDCreator?.toString() ?? 'Null'),
                  ]),
                  SizedBox(height: 20),
                  _buildSectionTitle("Time Task"),
                  _buildInfoCard([
                    _buildInfoRow("Start Time", job!.TimeStart),
                    _buildInfoRow("Complete Time", job!.TimeComplete),
                    _buildInfoRow(
                        "Approximate Time", job!.approximateTime ?? 'Null'),
                  ]),
                  SizedBox(height: 20),
                  _buildSectionTitle("Project Details"),
                  _buildInfoCard([
                    _buildInfoRow(
                        "Project ID", job!.IDProject?.toString() ?? 'Null'),
                    _buildInfoRow(
                        "Workflow ID", job!.IDWorkFLow?.toString() ?? 'Null'),
                    _buildInfoRow("Group ID", job!.GroupID.toString()),
                  ]),
                ],
              ),
            ),
    );
  }
}

Widget _buildSectionTitle(String title) {
  return Text(
    title,
    style: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
      color: Colors.blueAccent,
    ),
  );
}

Widget _buildInfoCard(List<Widget> children) {
  return Container(
    padding: EdgeInsets.all(12.0),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
      boxShadow: [
        BoxShadow(
          color: Colors.black26,
          blurRadius: 4,
          offset: Offset(0, 2),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    ),
  );
}

Widget _buildInfoRow(String label, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontSize: 16, color: Colors.grey[600])),
        Text(value,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
      ],
    ),
  );
}

Widget _buildDescription(String description) {
  return Text(
    description,
    style: TextStyle(fontSize: 16, color: Colors.grey[800]),
    textAlign: TextAlign.justify,
  );
}

class Job {
  final int IDJob;
  final String Status;
  final int IDUserAssign;
  final int IDUserPerform;
  final int IDCreator;
  final String TimeComplete;
  final String TimeStart;
  final String DescriptionJob;
  final String? approximateTime;
  final String NameJob;
  final int? IDPriorityLevel;
  final String Priority;
  final int? IDListFollower;
  final int IDProject;
  final int? IDWorkFLow;
  final int? GroupID;

  Job({
    required this.IDJob,
    required this.Status,
    required this.IDUserAssign,
    required this.IDUserPerform,
    required this.IDCreator,
    required this.TimeComplete,
    required this.TimeStart,
    required this.DescriptionJob,
    this.approximateTime,
    required this.NameJob,
    this.IDPriorityLevel,
    required this.Priority,
    this.IDListFollower,
    required this.IDProject,
    this.IDWorkFLow,
    this.GroupID,
  });

  factory Job.fromJson(Map<String, dynamic> json) {
    return Job(
      IDJob: json['IDJob'],
      Status: json['Status'],
      IDUserAssign: json['IDUserAssign'],
      IDUserPerform: json['IDUserPerform'],
      IDCreator: json['IDCreator'],
      TimeComplete: json['TimeComplete'],
      TimeStart: json['TimeStart'],
      DescriptionJob: json['DescriptionJob'],
      approximateTime: json['approximateTime'],
      NameJob: json['NameJob'],
      IDPriorityLevel: json['IDPriorityLevel'],
      Priority: json['Priority'],
      IDListFollower: json['IDListFollower'],
      IDProject: json['IDProject'],
      IDWorkFLow: json['IDWorkFLow'],
      GroupID: json['GroupID'],
    );
  }
}
