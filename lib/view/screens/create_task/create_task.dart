import 'package:flutter/material.dart';
import 'package:work_flow/themes/primarycolor.dart';
import 'package:work_flow/view/widgets/app_dropdown.dart';
import 'package:work_flow/view/widgets/custom_snackbar.dart';

class CreateTask extends StatefulWidget {
  const CreateTask({super.key});

  @override
  State<CreateTask> createState() => _CreateTaskState();
}

class _CreateTaskState extends State<CreateTask> {
  String? _selectedProject = 'MICXM APP';
  String? _selectedTaskType = 'Task';
  String? _selectedPriority = 'Low';
  String? _selectedStatus = 'To do';
  String? _selectedRequester = 'Trần Đông Vi';
  String? _selectedAssignee = 'Trần Đông Vi';

  List<String> listAssign = ['Assignee 1', 'Assignee 2', 'Assignee 3'];
  List<String> listRequester = ['Requester 1', 'Requester 2', 'Requester 3'];
  List<String> listPriority = ['Low', 'Medium', 'High'];
  List<String> listStatus = ['To do', 'In progress', 'Done'];
  List<String> listTaskType = ['Task', 'Bug'];
  List<String> listProject = ['MICXM APP', 'MICXM APP 2', 'MICXM APP 3'];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
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

            //SizedBox(height: 32),
            Spacer(),
            ElevatedButton(
              onPressed: () {},
              child: Text('Create Task',
                  style: TextStyle(fontSize: 18, color: Colors.white)),
              style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 130),
                  textStyle: TextStyle(fontSize: 18),
                  backgroundColor: AppColor.primaryColor),
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
