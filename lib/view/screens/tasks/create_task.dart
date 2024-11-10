import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:work_flow/api_constants.dart';
import 'package:work_flow/themes/primarycolor.dart';
import 'package:work_flow/view/screens/projects/info_project.dart';
import 'package:work_flow/view/widgets/app_dropdown.dart';
import 'package:work_flow/view/widgets/custom_snackbar.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class CreateTask extends StatefulWidget {
  const CreateTask({super.key});

  @override
  State<CreateTask> createState() => _CreateTaskState();
}

class _CreateTaskState extends State<CreateTask> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  List<String> listTaskType = ['Task', 'Bug', 'Feature'];
  List<String> listPriority = ['Low', 'Medium', 'High'];
  List<String> listStatus = ['To do', 'In Progress', 'Done'];
  List<String> listRequester = ['Trần Đông Vi', 'User 2', 'User 3'];

  List<dynamic> listProject = [];
  int? selectedProjectId;
  int? _selectedProject;

  String? _selectedTaskType;
  String? _selectedPriority;
  String? _selectedStatus;
  String? _selectedRequester;

  List<dynamic> listAssign = [];
  int? _selectedAssignee;
  int? selectedAssigneeId;

  DateTime _selectedDateStart = DateTime.now();
  DateTime _selectedDateEnd = DateTime.now();

  Future<void> _createTask(
      int selectedProjectId, int selectedAssigneeId) async {
    final token = await _getToken();

    final name = _titleController.text;
    final description = _descriptionController.text;
    final priority = _selectedPriority;
    final status = _selectedStatus;
    final assignee = _selectedAssignee;

    final dateStart =
        DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").format(_selectedDateStart);
    final dateEnd =
        DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").format(_selectedDateEnd);

    final response = await http.post(
      Uri.parse('$baseUrl/job/create'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'NameJob': name,
        'DescriptionJob': description,
        'Priority': priority,
        'Status': status,
        'IDUser': selectedAssigneeId,
        'TimeStart': dateStart,
        'TimeComplete': dateEnd,
      }),
    );

    if (response.statusCode == 201) {
      final responseBody = jsonDecode(response.body);

      final taskId = responseBody['IdJob'];

      print('Task ID: $taskId');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('task $taskId đã tạo thành công '),
        ),
      );
    } else {
      final errorResponseBody = jsonDecode(response.body);
      print('Error Response: $errorResponseBody');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Lỗi khi tạo task: ${response.statusCode}'),
        ),
      );
    }
  }

  Future<void> _getListProject() async {
    final token = await _getToken();
    if (token != null) {
      final response = await http.get(
        Uri.parse('$baseUrl/project/getAll'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        print('Response body: ${response.body}');
        final jsonData = jsonDecode(response.body) as List<dynamic>;

        if (mounted) {
          setState(() {
            listProject = jsonData
                .map<Map<String, dynamic>>((project) => {
                      'IdProject': project['IdProject'],
                      'NameProject': project['NameProject']?.toString() ?? '',
                    })
                .toList();
          });
        }
      } else {
        print('Failed to load projects, status code: ${response.statusCode}');
      }
    } else {
      print('Token not found');
    }
  }

  Future<void> _getListUsers() async {
    final token = await _getToken();
    if (token != null) {
      final response = await http.get(
        Uri.parse('$baseUrl/appUser/getAll'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        print('Response body: ${response.body}');
        final jsonData = jsonDecode(response.body) as List<dynamic>;

        if (mounted) {
          setState(() {
            listAssign = jsonData
                .map<Map<String, dynamic>>((user) => {
                      'IDUser': user['IDUser'],
                      'Name': user['Name']?.toString() ?? '',
                    })
                .toList();
          });
        }
      } else {
        print('Failed to load users, status code: ${response.statusCode}');
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
  void dispose() {
    _descriptionController.dispose();
    _titleController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _getListProject();
    _getListUsers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Create Task',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              SizedBox(
                height: 50,
                child: TextField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    labelText: 'Task name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  hintMaxLines: 5,
                ),
              ),
              const SizedBox(height: 16),
              AppDropdown<int>(
                label: 'Projects',
                dropdownMenuItemList: listProject
                    .map((project) => _itemDropdownProject(project))
                    .toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedProject = newValue;
                    selectedProjectId = newValue;
                  });
                },
                hint: "Chọn Project",
                value: _selectedProject,
              ),
              // const SizedBox(height: 16),
              // AppDropdown<String>(
              //   label: 'Task type',
              //   dropdownMenuItemList: listTaskType
              //       .map(
              //         (e) => _itemDropdown(e),
              //       )
              //       .toList(),
              //   onChanged: (newValue) {
              //     setState(() {
              //       _selectedTaskType = newValue;
              //     });
              //   },
              //   hint: 'Task type',
              //   value: _selectedTaskType,
              // ),
              const SizedBox(height: 16),
              AppDropdown<String>(
                label: 'Priority',
                dropdownMenuItemList: listPriority
                    .map(
                      (e) => _itemDropdown(e),
                    )
                    .toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedPriority = newValue;
                  });
                },
                hint: "Chọn Priority",
                value: _selectedPriority,
              ),
              const SizedBox(height: 16),
              AppDropdown<String>(
                label: 'Status',
                dropdownMenuItemList: listStatus
                    .map(
                      (e) => _itemDropdown(e),
                    )
                    .toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedStatus = newValue;
                  });
                },
                hint: "Chọn Status",
                value: _selectedStatus,
              ),
              // const SizedBox(height: 16),
              // AppDropdown<String>(
              //   label: 'Người yêu cầu',
              //   dropdownMenuItemList: listRequester
              //       .map(
              //         (e) => _itemDropdown(e),
              //       )
              //       .toList(),
              //   onChanged: (newValue) {
              //     setState(() {
              //       _selectedRequester = newValue;
              //     });
              //   },
              //   hint: 'Người yêu cầu',
              //   value: _selectedRequester,
              // ),
              const SizedBox(height: 16),
              AppDropdown<int>(
                label: 'Chỉ định xử lý',
                dropdownMenuItemList:
                    listAssign.map((user) => _itemDropdownUser(user)).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedAssignee = newValue;
                    selectedAssigneeId = newValue;
                  });
                },
                hint: "Chỉ định xử lý",
                value: _selectedAssignee,
              ),
              const SizedBox(height: 16),
              InkWell(
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: _selectedDateStart ?? DateTime.now(),
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2030),
                  );

                  if (date != null) {
                    final time = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.fromDateTime(
                          _selectedDateStart ?? DateTime.now()),
                    );

                    if (time != null) {
                      setState(() {
                        _selectedDateStart = DateTime(
                          date.year,
                          date.month,
                          date.day,
                          time.hour,
                          time.minute,
                        );
                      });
                    }
                  }
                },
                child: AppDropdown<String>(
                  label: 'Ngày bắt đầu',
                  dropdownMenuItemList: [],
                  onChanged: (newValue) {},
                  hint: _selectedDateStart == null
                      ? ''
                      : DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
                          .format(_selectedDateStart),
                  value: _selectedDateStart == null
                      ? ''
                      : DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
                          .format(_selectedDateStart),
                ),
              ),
              const SizedBox(height: 16),
              InkWell(
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: _selectedDateEnd ?? DateTime.now(),
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2030),
                  );

                  if (date != null) {
                    final time = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.fromDateTime(
                          _selectedDateEnd ?? DateTime.now()),
                    );

                    if (time != null) {
                      setState(() {
                        _selectedDateEnd = DateTime(
                          date.year,
                          date.month,
                          date.day,
                          time.hour,
                          time.minute,
                        );
                      });
                    }
                  }
                },
                child: AppDropdown<String>(
                  label: 'Ngày kết thúc',
                  dropdownMenuItemList: [],
                  onChanged: (newValue) {},
                  hint: _selectedDateEnd == null
                      ? ''
                      : DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
                          .format(_selectedDateEnd),
                  value: _selectedDateEnd == null
                      ? ''
                      : DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
                          .format(_selectedDateEnd),
                ),
              ),

              const SizedBox(height: 16),
              InkWell(
                onTap: () async {
                  if (_titleController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Vui lòng nhập tên task!")),
                    );
                    return;
                  }

                  if (_descriptionController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Vui lòng nhập mô tả!")),
                    );
                    return;
                  }

                  if (_selectedProject == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Vui lòng chọn Project!")),
                    );
                    return;
                  }

                  if (_selectedPriority == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Vui lòng chọn Priority!")),
                    );
                    return;
                  }

                  if (_selectedStatus == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Vui lòng chọn Status!")),
                    );
                    return;
                  }

                  if (selectedAssigneeId == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Vui lòng chọn người xử lý!")),
                    );
                    return;
                  }

                  if (_selectedDateStart == null || _selectedDateEnd == null) {
                    String message = "Vui lòng chọn";
                    if (_selectedDateStart == null) message += " ngày bắt đầu";
                    if (_selectedDateEnd == null) {
                      message += _selectedDateStart == null
                          ? " và ngày kết thúc!"
                          : " ngày kết thúc!";
                    }

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(message)),
                    );
                    return;
                  }

                  await _createTask(selectedProjectId!, selectedAssigneeId!);
                  Navigator.pop(context);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColor.primaryColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Center(
                    child: Text(
                      'Create Task',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  DropdownMenuItem<String> _itemDropdown(String e) {
    return DropdownMenuItem(
      value: e,
      child: Container(
        child: Text(
          e,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 12,
            fontWeight: FontWeight.normal,
          ),
        ),
      ),
    );
  }
}

DropdownMenuItem<int> _itemDropdownProject(Map<String, dynamic> project) {
  return DropdownMenuItem<int>(
    value: project['IdProject'],
    child: Text(
      project['NameProject'],
      style: const TextStyle(
        color: Colors.black,
        fontSize: 12,
        fontWeight: FontWeight.normal,
      ),
    ),
  );
}

DropdownMenuItem<int> _itemDropdownUser(Map<String, dynamic> user) {
  return DropdownMenuItem<int>(
    value: user['IDUser'],
    child: Text(
      user['Name'],
      style: const TextStyle(
        color: Colors.black,
        fontSize: 12,
        fontWeight: FontWeight.normal,
      ),
    ),
  );
}
