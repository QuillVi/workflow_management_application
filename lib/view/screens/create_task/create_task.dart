import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:work_flow/themes/primarycolor.dart';
import 'package:work_flow/view/widgets/app_dropdown.dart';
import 'package:work_flow/view/widgets/custom_snackbar.dart';
import 'package:intl/intl.dart';

class CreateTask extends StatefulWidget {
  const CreateTask({super.key});

  @override
  State<CreateTask> createState() => _CreateTaskState();
}

class _CreateTaskState extends State<CreateTask> {
  List<String> listProject = ['MICXM APP', 'Project 2', 'Project 3'];
  List<String> listTaskType = ['Task', 'Bug', 'Feature'];
  List<String> listPriority = ['Low', 'Medium', 'High'];
  List<String> listStatus = ['To do', 'In Progress', 'Done'];
  List<String> listRequester = ['Trần Đông Vi', 'User 2', 'User 3'];
  List<String> listAssign = ['Van Phu', 'User 2', 'User 3'];

  String? _selectedProject;
  String? _selectedTaskType;
  String? _selectedPriority;
  String? _selectedStatus;
  String? _selectedRequester;
  String? _selectedAssignee;

  DateTime _selectedDateStart = DateTime.now();
  DateTime _selectedDateEnd = DateTime.now();

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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(
              height: 50,
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'Task name *',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            AppDropdown<String>(
              label: 'Project',
              dropdownMenuItemList: listProject
                  .map(
                    (e) => _itemDropdown(e),
                  )
                  .toList(),
              onChanged: (newValue) {
                setState(() {
                  _selectedProject = newValue;
                });
              },
              hint: "Chọn Project",
              value: _selectedProject,
            ),
            const SizedBox(height: 16),
            AppDropdown<String>(
              label: 'Task type',
              dropdownMenuItemList: listTaskType
                  .map(
                    (e) => _itemDropdown(e),
                  )
                  .toList(),
              onChanged: (newValue) {
                setState(() {
                  _selectedTaskType = newValue;
                });
              },
              hint: 'Task type',
              value: _selectedTaskType,
            ),
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
            const SizedBox(height: 16),
            AppDropdown<String>(
              label: 'Người yêu cầu',
              dropdownMenuItemList: listRequester
                  .map(
                    (e) => _itemDropdown(e),
                  )
                  .toList(),
              onChanged: (newValue) {
                setState(() {
                  _selectedRequester = newValue;
                });
              },
              hint: 'Người yêu cầu',
              value: _selectedRequester,
            ),
            const SizedBox(height: 16),
            AppDropdown<String>(
              label: 'Chỉ định xử lý',
              dropdownMenuItemList: listAssign
                  .map(
                    (e) => _itemDropdown(e),
                  )
                  .toList(),
              onChanged: (newValue) {
                setState(() {
                  _selectedAssignee = newValue;
                });
              },
              hint: 'Chỉ định xử lý',
              value: _selectedAssignee,
            ),
            const SizedBox(height: 16),
            InkWell(
              onTap: () {
                showDatePicker(
                  context: context,
                  initialDate: _selectedDateStart,
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2030),
                ).then((picked) {
                  if (picked != null) {
                    setState(() {
                      _selectedDateStart = picked;
                    });
                  }
                });
              },
              child: AppDropdown<String>(
                label: 'Ngày bắt đầu',
                dropdownMenuItemList: [],
                onChanged: (newValue) {},
                hint: _selectedDateStart == null
                    ? ''
                    : DateFormat('dd-MM-yyyy').format(_selectedDateStart),
                value: _selectedDateStart == null
                    ? ''
                    : DateFormat('dd-MM-yyyy').format(_selectedDateStart),
              ),
            ),
            const SizedBox(height: 16),
            InkWell(
              onTap: () {
                showDatePicker(
                  context: context,
                  initialDate: _selectedDateEnd,
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2030),
                ).then((picked) {
                  if (picked != null) {
                    setState(() {
                      _selectedDateEnd = picked;
                    });
                  }
                });
              },
              child: AppDropdown<String>(
                label: 'Ngày kết thúc',
                dropdownMenuItemList: [],
                onChanged: (newValue) {},
                hint: _selectedDateEnd == null
                    ? ''
                    : DateFormat('dd-MM-yyyy').format(_selectedDateEnd),
                value: _selectedDateEnd == null
                    ? ''
                    : DateFormat('dd-MM-yyyy').format(_selectedDateEnd),
              ),
            ),
            const SizedBox(height: 16),
            const Spacer(),
            InkWell(
              onTap: () {
                ShowSnackBarCustom.showSnackBar(
                    this.context,
                    'Success',
                    AppColor.greenColor,
                    const Icon(
                      Icons.check,
                      color: Colors.white,
                    ));
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                width: double.infinity,
                decoration: BoxDecoration(
                    color: AppColor.primaryColor,
                    borderRadius: BorderRadius.circular(16)),
                child: const Center(
                  child: Text('Create Task',
                      style: TextStyle(fontSize: 16, color: Colors.white)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  DropdownMenuItem<String> _itemDropdown(String e) {
    return DropdownMenuItem(
      value: e,
      child: Container(
        //    color: Colors.white,
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
