import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:work_flow/api_constants.dart';
import 'package:work_flow/view/screens/jobs/job.dart';
import 'package:work_flow/view/screens/projects/create_project.dart';
import 'dart:convert';
import 'info_project.dart';

class Project extends StatefulWidget {
  const Project({super.key});

  @override
  State<Project> createState() => _ProjectState();
}

class _ProjectState extends State<Project> {
  bool _isEditing = false;
  String _title = 'Projects';
  List _projects = [];
  List _jobInProjects = [];
  bool _isLoading = true;
  List<int> _projectIds = [];

  Future<void> _loadProjects() async {
    final token = await _getToken();
    if (token != null) {
      final response = await http.get(
        Uri.parse('$baseUrl/project/getAll'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        setState(() {
          _projects = jsonData;

          // _projectIds =
          //     List<int>.from(jsonData.map((project) => project['IdProject']));
        });
      } else {
        print('Failed to load projects');
      }
    } else {
      print('Token not found');
    }
  }

  // Future<void> _loadJobInProject() async {
  //   setState(() {
  //     _isLoading = true;
  //   });
  //   try {
  //     final token = await _getToken();
  //     final headers = {
  //       'Content-Type': 'application/json; charset=UTF-8',
  //       'Authorization': 'Bearer $token',
  //     };
  //     final response = await http.get(
  //       Uri.parse('$baseUrl/project/getJobsInGroup/$_projectIds'),
  //       headers: headers,
  //     );

  //     print(response.body);

  //     if (response.statusCode == 200) {
  //       final contentType = response.headers['content-type'];
  //       if (contentType != null && contentType.contains('application/json')) {
  //         final jsonData = jsonDecode(response.body);
  //         setState(() {
  //           _jobInProjects = jsonData;
  //         });
  //       }
  //     } else {
  //       print('Failed to load jobs in project');
  //     }
  //   } catch (e) {
  //     print('Error loading jobs in project: $e');
  //   } finally {
  //     setState(() {
  //       _isLoading = false;
  //     });
  //   }
  // }

  @override
  void initState() {
    super.initState();
    _loadProjects();
  }

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
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
          Container(
            child: PopupMenuButton(
              icon: const Icon(Icons.more_vert, color: Colors.black),
              itemBuilder: (context) => [
                PopupMenuItem(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Tạo Jobs'),
                      const Icon(Icons.table_chart_outlined),
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Job(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
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
                        builder: (context) => CreateProject(),
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
                          'Tạo Project',
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
                          'Xoá Project',
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
              child: _projects.isNotEmpty
                  ? ListView.builder(
                      itemCount: _projects.length,
                      itemBuilder: (context, index) {
                        final project = _projects[index];
                        final projectName =
                            project['NameProject'] ?? 'Không có tên dự án';

                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => InfoProject(
                                  projectId: project['IdProject'] ?? '',
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
                                    projectName,
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
