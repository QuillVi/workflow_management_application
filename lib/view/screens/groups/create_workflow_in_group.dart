import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:work_flow/api_constants.dart';
import 'package:work_flow/view/widgets/app_dropdown.dart';

class CreateWorkflowInGroup extends StatefulWidget {
  final int groupId;
  final String groupName;
  const CreateWorkflowInGroup(
      {super.key, required this.groupId, required this.groupName});

  @override
  State<CreateWorkflowInGroup> createState() => _CreateWorkflowInGroupState();
}

class _CreateWorkflowInGroupState extends State<CreateWorkflowInGroup> {
  bool _isEditing = false;
  int? selectedGroupId;
  String? selectedGroupName;

  String _description = '';
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  List<dynamic> listGroups = [];
  int? _selectedGroup;

  Future<void> createWorkflow(int selectedGroupId) async {
    final token = await _getToken();

    final name = _titleController.text;
    final description = _descriptionController.text;
    print('Token: $token');
    print('Name: $name');
    print('Description: $description');
    print('GroupID: $selectedGroupId');
    print('Stages: $stages');

    final stage = stages;

    final response = await http
        .post(
      Uri.parse('$baseUrl/workFlow/saveWorkFLow'),
      headers: {
        'Authorization': "Bearer $token",
        'Content-Type': 'application/json',
        'Connection': 'close',
      },
      body: jsonEncode({
        'name': name,
        'description': description,
        'GroupID': selectedGroupId,
        'stages': stage,
      }),
    )
        .timeout(const Duration(seconds: 60), onTimeout: () {
      throw TimeoutException('Yêu cầu đã hết thời gian chờ');
    });

    print('Name: $name');
    print('Description: $description');
    print('GroupID: $selectedGroupId');
    print('Stages: $stages');

    if (response.statusCode == 201) {
      final responseBody = jsonDecode(response.body);

      final workflowId = responseBody['workflowId'];

      print('Workflow ID: $workflowId');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text('Workflow $workflowId đã tạo thành công với các stages: '),
        ),
      );
    } else {
      final errorResponseBody = jsonDecode(response.body);
      print('Error Response: $errorResponseBody');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Lỗi khi tạo workflow: ${response.statusCode}'),
        ),
      );
    }
    //}
  }

  Future<void> _getListGroups() async {
    final token = await _getToken();
    if (token != null) {
      final response = await http.get(
        Uri.parse('$baseUrl/group/getAll'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        print('Response body: ${response.body}');
        final jsonData = jsonDecode(response.body) as List<dynamic>;

        if (mounted) {
          setState(() {
            listGroups = jsonData
                .map<Map<String, dynamic>>((group) => {
                      'GroupID': group['GroupID'],
                      'GroupName': group['GroupName']?.toString() ?? '',
                    })
                .toList();
          });
        }
      } else {
        print('Failed to load groups, status code: ${response.statusCode}');
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
    _selectedGroup = widget.groupId;
    selectedGroupName = widget.groupName;
    _getListGroups();
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _titleController.dispose();
    _stageNameController.dispose();
    _stageDescriptionController.dispose();
    super.dispose();
  }

  List<Map<String, String>> stages = [];
  TextEditingController _stageNameController = TextEditingController();
  TextEditingController _stageDescriptionController = TextEditingController();

  void _showAddStageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Thêm Stage mới'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _stageNameController,
                decoration: InputDecoration(labelText: 'Tên Stage'),
              ),
              TextField(
                controller: _stageDescriptionController,
                decoration: InputDecoration(labelText: 'Mô tả Stage'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Hủy'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  stages.add({
                    'name': _stageNameController.text,
                    'description': _stageDescriptionController.text,
                  });
                });

                _stageNameController.clear();
                _stageDescriptionController.clear();
                Navigator.of(context).pop();
              },
              child: Text('Thêm'),
            ),
          ],
        );
      },
    );
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
          'Workflow',
          style: TextStyle(color: Colors.black, fontSize: 18),
        ),
        centerTitle: true,
        actions: [],
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _isEditing = true;
                      });
                    },
                    child: _isEditing
                        ? TextField(
                            controller: _titleController,
                            decoration: InputDecoration(
                              labelText: 'Tên workflow',
                            ),
                          )
                        : Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Tên workflow',
                              style: TextStyle(
                                  color: Colors.grey[600], fontSize: 18),
                            ),
                          ),
                  ),
                  SizedBox(height: 20),
                  _isEditing
                      ? TextFormField(
                          controller: _descriptionController,
                          decoration: InputDecoration(
                            labelText: 'Mô tả workflow',
                            border: OutlineInputBorder(),
                          ),
                          maxLines: 5,
                        )
                      : Text(
                          'Chưa có mô tả',
                          style:
                              TextStyle(color: Colors.grey[600], fontSize: 16),
                        ),
                  SizedBox(height: 20),
                  AppDropdown<int>(
                    label: 'Groups',
                    dropdownMenuItemList: listGroups
                        .map((group) => _itemDropdown(group))
                        .toList(),
                    onChanged: (newValue) {
                      setState(() {
                        _selectedGroup = newValue;
                        selectedGroupName = listGroups.firstWhere((group) =>
                            group['GroupID'] == newValue)['GroupName'];
                      });
                    },
                    hint: "Chọn Groups",
                    value: _selectedGroup,
                  ),
                  SizedBox(height: 20),
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Stages',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                _showAddStageDialog(context);
                              },
                              child: Icon(Icons.add),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        ...stages.map((stage) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Stage Name: ${stage['name']}'),
                              Text('Description: ${stage['description']}'),
                              SizedBox(height: 10),
                            ],
                          );
                        }).toList(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  alignment: Alignment.center,
                  height: 50,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: TextButton(
                    child: Text(
                      'Tạo workflow',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () async {
                      if (_selectedGroup != null) {
                        await createWorkflow(_selectedGroup!);
                        Navigator.pop(context);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                'Vui lòng chọn một nhóm trước khi tạo workflow'),
                          ),
                        );
                      }
                    },
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  DropdownMenuItem<int> _itemDropdown(Map<String, dynamic> group) {
    return DropdownMenuItem<int>(
      value: group['GroupID'],
      child: Text(
        group['GroupName'],
        style: const TextStyle(
          color: Colors.black,
          fontSize: 12,
          fontWeight: FontWeight.normal,
        ),
      ),
    );
  }
}
