import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:work_flow/views/screens/stages/create_stage_in_workflow.dart';
import 'package:work_flow/views/screens/stages/stage_info_in_workflow.dart';
import 'package:work_flow/views/screens/workflows/create_workflow.dart';
import 'package:http/http.dart' as http;
import 'package:work_flow/views/screens/workflows/info_workflow.dart';
import 'package:work_flow/api_constants.dart';

class CreateWorkflow extends StatefulWidget {
  const CreateWorkflow({super.key});

  @override
  State<CreateWorkflow> createState() => _CreateWorkflowState();
}

class _CreateWorkflowState extends State<CreateWorkflow> {
  List _workflows = [];
  List _stages = [];

  Future<void> _loadWorkflows() async {
    final token = await _getToken();

    if (token != null) {
      try {
        final response = await http.get(
          Uri.parse('$baseUrl/workFlow/getAll'),
          headers: {
            'Authorization': 'Bearer $token',
          },
        );

        if (response.statusCode == 200) {
          final jsonData = jsonDecode(response.body);
          setState(() {
            _workflows = jsonData;
          });
          // Load stages after workflows are loaded
          _loadStages();
        } else if (response.statusCode == 401) {
          print('Token hết hạn, đang làm mới token...');
          // Token hết hạn, thực hiện làm mới token
          final data = jsonDecode(response.body);
          if (data.containsKey('token')) {
            await _setToken(data['token']); // Lưu token mới
            _loadWorkflows(); // Thực hiện lại yêu cầu với token mới
          } else {
            print('Không thể làm mới token');
          }
        } else {
          print(
              'Failed to load workflows, status code: ${response.statusCode}');
          print('Response body: ${response.body}');
        }
      } catch (e) {
        print('Error loading workflows: $e');
      }
    } else {
      print('Token not found');
    }
  }

  Future<void> _loadStages() async {
    final token = await _getToken();

    if (token != null) {
      try {
        final response = await http.get(
          Uri.parse('$baseUrl/stage/getAll'),
          headers: {
            'Authorization': 'Bearer $token',
          },
        );

        if (response.statusCode == 200) {
          final jsonData = jsonDecode(response.body);
          setState(() {
            _stages = jsonData;
          });
        } else if (response.statusCode == 401) {
          print('Token hết hạn, đang làm mới token...');
          // Token hết hạn, thực hiện làm mới token
          final data = jsonDecode(response.body);
          if (data.containsKey('token')) {
            await _setToken(data['token']); // Lưu token mới
            _loadStages(); // Thực hiện lại yêu cầu với token mới
          } else {
            print('Không thể làm mới token');
          }
        } else {
          print('Failed to load stages');
        }
      } catch (e) {
        print('Error loading stages: $e');
      }
    } else {
      print('Token not found');
    }
  }

  List<String> _getStagesForWorkflow(int idWorkFlow) {
    return _stages
        .where((stage) => stage['IDWorkFlow'] == idWorkFlow)
        .map<String>((stage) => stage['NameStage'])
        .toList();
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

  void initState() {
    super.initState();
    _loadWorkflows();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
          'Workflow của bạn',
          style: TextStyle(color: Colors.black, fontSize: 18),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add, color: Colors.black),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CreateNewWorkflow(),
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.notifications_none_outlined, color: Colors.black),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.more_vert, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _workflows.length,
        itemBuilder: (context, index) {
          final workflow = _workflows[index];
          final stages = _getStagesForWorkflow(workflow['IDWorkFlow']);
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            workflow['Name'] ?? '',
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                          SizedBox(width: 8),
                          PopupMenuButton(
                            icon: const Icon(Icons.more_horiz,
                                color: Colors.white),
                            itemBuilder: (context) => [
                              PopupMenuItem(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text('Xem workflow'),
                                    const Icon(Icons.visibility),
                                  ],
                                ),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => InfoCreateWorkflow(
                                        workflowId:
                                            workflow['IDWorkFlow'] ?? '',
                                      ),
                                    ),
                                  );
                                },
                              ),
                              PopupMenuItem(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text('Thêm stage'),
                                    const Icon(Icons.table_chart_outlined),
                                  ],
                                ),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          CreateStageInWorkflow(
                                        workflowId:
                                            workflow['IDWorkFlow'] ?? '',
                                      ),
                                    ),
                                  );
                                },
                              ),
                              PopupMenuItem(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text('Xoá workflow'),
                                    const Icon(Icons.delete_outline),
                                  ],
                                ),
                                onTap: () {},
                              ),
                            ],
                          )
                        ],
                      ),
                      SizedBox(height: 8),
                      Text(
                        workflow['Description'] ?? '',
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                      const SizedBox(height: 8),
                      Column(
                        children: [
                          Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.grey[800],
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: stages.length,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Stages(
                                          stageInfo: {
                                            'NameStage': stages[index]
                                          },
                                        ),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 4.0),
                                    padding: const EdgeInsets.all(8.0),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[700],
                                      borderRadius: BorderRadius.circular(5),
                                      border: Border.all(color: Colors.white),
                                    ),
                                    child: Text(
                                      'Stage: ${stages[index]}',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
