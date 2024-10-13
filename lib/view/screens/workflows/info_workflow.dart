import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:work_flow/api_constants.dart';
import 'package:work_flow/view/screens/stages/create_stage_in_workflow.dart';

class InfoCreateWorkflow extends StatefulWidget {
  final dynamic workflowId;
  const InfoCreateWorkflow({super.key, required this.workflowId});

  @override
  State<InfoCreateWorkflow> createState() => _InfoCreateWorkflowState();
}

class _InfoCreateWorkflowState extends State<InfoCreateWorkflow> {
  Map<String, dynamic> jsonData = {
    'IDWorkFlow': '1',
    'Name': 'My Workflow',
  };

  bool _isEditing = false;
  String _title = '';

  Workflow? workflow;
  List _stages = [];

  Future<void> _loadWorkflow() async {
    final token = await _getToken();

    if (token != null) {
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
      } else {
        print('Failed to load workflow');
      }
    } else {
      print('Token not found');
    }
  }

  Future<void> _loadStagesInWorkflow() async {
    final token = await _getToken();
    if (token == null) {
      print('Token is null, please login again');
      return;
    }

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/stage/${widget.workflowId}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        setState(() {
          _stages = [jsonData];
        });
      } else {
        print('Failed to load stages: ${response.body}');
      }
    } catch (e) {
      print('Failed to load stages: $e');
    }
  }

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  @override
  void initState() {
    super.initState();
    _loadWorkflow();
    _loadStagesInWorkflow();
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
      body: _stages.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _quickActionButton(
                          Icons.check_circle, 'Thêm Stage', Colors.green),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListView.builder(
                        itemCount: _stages.length,
                        itemBuilder: (context, index) {
                          final stage = _stages[index];
                          return Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Stage',
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 16),
                                  ),
                                  const SizedBox(width: 8),
                                  const Icon(
                                    Icons.more_horiz,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              GestureDetector(
                                onTap: () {},
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[800],
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Row(
                                    children: [
                                      Text(
                                        stage['NameStage'],
                                        style: const TextStyle(
                                            color: Colors.white, fontSize: 14),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _quickActionButton(IconData icon, String text, Color color) {
    return ElevatedButton(
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
            builder: (context) =>
                CreateStageInWorkflow(workflowId: widget.workflowId),
          ),
        );
      },
      child: Column(
        children: [
          Icon(icon, color: color),
          SizedBox(height: 5),
          Container(
            width: 80,
            height: 20,
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black, fontSize: 12),
            ),
          ),
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
