import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:work_flow/viewmodels/group_view_model.dart/load_group_id_view_model.dart';
import 'package:work_flow/viewmodels/group_view_model.dart/load_workflow_in_groupId_view_model.dart';
import 'package:work_flow/views/group_view/create_workflow_in_group_view.dart';
import 'package:work_flow/views/screens/workflows/info_workflow.dart';

class InfoGroup extends StatefulWidget {
  final dynamic groupId;
  const InfoGroup({super.key, required this.groupId});

  @override
  State<InfoGroup> createState() => _InfoGroupState();
}

class _InfoGroupState extends State<InfoGroup> {
  String _title = '';
  Group? group;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context
          .read<LoadGroupIdViewModel>()
          .fetchGroupById(widget.groupId.toString());
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context
          .read<LoadWorkflowInGroupidViewModel>()
          .fetchWorkflowsByGroupId(widget.groupId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<LoadGroupIdViewModel>(context);
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
                viewModel.setEditing(true);
              },
              child: viewModel.isEditing
                  ? TextFormField(
                      initialValue: viewModel.title,
                      style: TextStyle(color: Colors.black, fontSize: 18),
                      onFieldSubmitted: (value) {
                        viewModel.setTitle(value);
                        viewModel.setEditing(false);
                      },
                    )
                  : Text(
                      viewModel.title.isEmpty ? "Loading..." : viewModel.title,
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
      body: Consumer<LoadWorkflowInGroupidViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return Column(
            children: [
              Expanded(
                child: viewModel.hasWorkflows
                    ? ListView.builder(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        itemCount: viewModel.workflowNames.length,
                        itemBuilder: (context, index) {
                          final workflowName =
                              viewModel.workflowNames[index].isNotEmpty
                                  ? viewModel.workflowNames[index]
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
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => InfoCreateWorkflow(
                                        workflowId: workflowName,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          );
                        },
                      )
                    : const Center(
                        child: Text(
                          'Không có workflow trong Group này, hãy tạo workflow',
                          style: TextStyle(fontSize: 16, color: Colors.black54),
                        ),
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class Group {
  final int GroupID;
  final String GroupName;
  Group({required this.GroupID, required this.GroupName});

  factory Group.fromJson(Map<String, dynamic> json) {
    return Group(
      GroupID: json['GroupID'],
      GroupName: json['GroupName'],
    );
  }
}
