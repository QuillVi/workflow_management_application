import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:work_flow/viewmodels/group_view_model.dart/create_workflow_in_group_view_model.dart';
import 'package:work_flow/viewmodels/group_view_model.dart/load_list_group_create_workflow_view_model.dart';
import 'package:work_flow/views/widgets/app_dropdown.dart';

class CreateWorkflowInGroup extends StatefulWidget {
  final int groupId;
  final String groupName;
  const CreateWorkflowInGroup(
      {super.key, required this.groupId, required this.groupName});

  @override
  State<CreateWorkflowInGroup> createState() => _CreateWorkflowInGroupState();
}

class _CreateWorkflowInGroupState extends State<CreateWorkflowInGroup> {
  List<Map<String, String>> stages = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final viewModel = context.read<LoadListGroupCreateWorkflowViewModel>();
      viewModel.loadListGroups();
      viewModel.setSelectedGroup(widget.groupId, widget.groupName);
    });
  }

  void _showAddStageDialog(BuildContext context) {
    final createWorkflowViewModel =
        Provider.of<CreateWorkflowInGroupViewModel>(context, listen: false);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Thêm Stage mới'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: createWorkflowViewModel.stageNameController,
                decoration: InputDecoration(labelText: 'Tên Stage'),
              ),
              TextField(
                controller: createWorkflowViewModel.stageDescriptionController,
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
                final name =
                    createWorkflowViewModel.stageNameController.text.trim();
                final description = createWorkflowViewModel
                    .stageDescriptionController.text
                    .trim();

                if (name.isNotEmpty && description.isNotEmpty) {
                  createWorkflowViewModel.addStage(name, description);
                  createWorkflowViewModel.clearInputFields();
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Vui lòng nhập đầy đủ thông tin')),
                  );
                }
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
    final createWorkflowViewModel =
        Provider.of<CreateWorkflowInGroupViewModel>(context);
    final loadListGroupInCreateWorkflowViewModel =
        Provider.of<LoadListGroupCreateWorkflowViewModel>(context);
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
                      createWorkflowViewModel.setEditing(true);
                    },
                    child: createWorkflowViewModel.isEditing
                        ? TextField(
                            controller: createWorkflowViewModel.titleController,
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
                  createWorkflowViewModel.isEditing
                      ? TextFormField(
                          controller:
                              createWorkflowViewModel.descriptionController,
                          decoration: InputDecoration(
                            labelText: 'Mô tả workflow',
                            border: OutlineInputBorder(),
                          ),
                          maxLines: 5,
                        )
                      : Text(
                          createWorkflowViewModel
                                  .descriptionController.text.isNotEmpty
                              ? createWorkflowViewModel
                                  .descriptionController.text
                              : 'Chưa có mô tả',
                          style:
                              TextStyle(color: Colors.grey[600], fontSize: 16),
                        ),
                  SizedBox(height: 20),
                  AppDropdown<int>(
                    label: 'Groups',
                    dropdownMenuItemList: loadListGroupInCreateWorkflowViewModel
                        .listGroups
                        .map((group) => _itemDropdown(group))
                        .toList(),
                    onChanged: (newValue) {
                      final selectedGroup =
                          loadListGroupInCreateWorkflowViewModel.listGroups
                              .firstWhere(
                        (group) => group['GroupID'] == newValue,
                        orElse: () =>
                            {'GroupID': null, 'GroupName': 'Không xác định'},
                      );

                      loadListGroupInCreateWorkflowViewModel.setSelectedGroup(
                        selectedGroup['GroupID'],
                        selectedGroup['GroupName'],
                      );
                    },
                    hint: "Chọn Groups",
                    value: loadListGroupInCreateWorkflowViewModel.selectedGroup,
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
                        Consumer<CreateWorkflowInGroupViewModel>(
                          builder: (context, createWorkflowViewModel, child) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children:
                                  createWorkflowViewModel.stages.map((stage) {
                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 5),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Stage Name: ${stage['name']}',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                          'Description: ${stage['description']}'),
                                      Divider(), // Tạo khoảng cách giữa các stage
                                    ],
                                  ),
                                );
                              }).toList(),
                            );
                          },
                        ),
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
                child: Consumer2<CreateWorkflowInGroupViewModel,
                    LoadListGroupCreateWorkflowViewModel>(
                  builder: (context, createWorkflowViewModel,
                      loadListGroupInCreateWorkflowViewModel, child) {
                    return Container(
                      alignment: Alignment.center,
                      height: 50,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: TextButton(
                          child: createWorkflowViewModel.isLoading
                              ? CircularProgressIndicator(color: Colors.white)
                              : Text(
                                  'Tạo workflow',
                                  style: TextStyle(color: Colors.white),
                                ),
                          onPressed: () async {
                            if (loadListGroupInCreateWorkflowViewModel
                                    .selectedGroup !=
                                null) {
                              final workflowId =
                                  await createWorkflowViewModel.createWorkflow(
                                loadListGroupInCreateWorkflowViewModel
                                    .selectedGroup!,
                              );

                              if (workflowId != null) {
                                Navigator.pop(context);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        'Tạo workflow thất bại. Vui lòng thử lại!'),
                                  ),
                                );
                              }
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      'Vui lòng chọn một nhóm trước khi tạo workflow'),
                                ),
                              );
                            }
                          }),
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
