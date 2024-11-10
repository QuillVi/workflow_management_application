import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:work_flow/api_constants.dart';
import 'package:work_flow/view/screens/groups/create_workflow_in_group.dart';
import 'package:work_flow/view/screens/workflows/create_workflow.dart';

class InfoGroup extends StatefulWidget {
  final dynamic groupId;
  const InfoGroup({super.key, required this.groupId});

  @override
  State<InfoGroup> createState() => _InfoGroupState();
}

class _InfoGroupState extends State<InfoGroup> {
  bool _isEditing = false;
  String _title = '';

  Group? group;
  List<String> _workflowNames = [];

  Future<void> _loadGroup() async {
    final token = await _getToken();

    if (token != null) {
      final response = await http.get(
        Uri.parse('$baseUrl/group/${widget.groupId}'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        setState(() {
          _title = jsonData['GroupName'] ?? 'No Title';
        });
      } else {
        print('Failed to load group');
      }
    } else {
      print('Token not found');
    }
  }

  Future<void> _loadWorkflows() async {
    final token = await _getToken();

    if (token != null) {
      final response = await http.get(
          Uri.parse('$baseUrl/userWorkFlow/getByGroupID/${widget.groupId}'),
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          });
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = jsonDecode(response.body);

        setState(() {
          _workflowNames =
              jsonData.map((item) => item['Name'] as String).toList();
        });
      } else {
        print('Failed to load workflows');
      }
    } else {
      print('Token not found');
    }
  }

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  @override
  void initState() {
    super.initState();
    _loadGroup();
    _loadWorkflows();
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
            icon: Icon(Icons.add, color: Colors.black),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CreateWorkflowInGroup(
                    groupId: widget.groupId,
                    groupName: _title,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: _workflowNames.isNotEmpty
                ? ListView.builder(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    itemCount: _workflowNames.length,
                    itemBuilder: (context, index) {
                      final workflowName = _workflowNames[index].isNotEmpty
                          ? _workflowNames[index]
                          : 'No Name Workflow';

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Material(
                          elevation: 2,
                          borderRadius: BorderRadius.circular(12),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 16),
                            tileColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            title: Text(
                              workflowName,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.black87,
                              ),
                            ),
                            trailing: const Icon(Icons.arrow_forward_ios,
                                size: 16, color: Colors.blueAccent),
                          ),
                        ),
                      );
                    },
                  )
                : const Center(child: CircularProgressIndicator()),
          ),
        ],
      ),
    );
  }
}

class Group {
  final String IDGroup;
  final String GroupName;
  Group({required this.IDGroup, required this.GroupName});

  factory Group.fromJson(Map<String, dynamic> json) {
    return Group(
      IDGroup: json['IDGroup'],
      GroupName: json['GroupName'],
    );
  }
}
