import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:work_flow/viewmodels/group_view_model.dart/addMember_to_group_view_model.dart';
import 'package:work_flow/viewmodels/group_view_model.dart/create_group_addMember_view_model.dart';
import 'package:work_flow/views/group_view/group_view_model.dart';

class CreateGroup extends StatefulWidget {
  const CreateGroup({super.key});

  @override
  State<CreateGroup> createState() => _CreateGroupState();
}

class _CreateGroupState extends State<CreateGroup> {
  final TextEditingController groupNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  List<String> emailList = [];
  @override
  Widget build(BuildContext context) {
    final viewModelCreateGroup =
        Provider.of<CreateGroupAddmemberViewModel>(context);
    final viewModelAddMember = Provider.of<AddmemberToGroupViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Create Group'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: viewModelCreateGroup.groupNameController,
              decoration: InputDecoration(labelText: 'Group Name'),
            ),
            TextField(
              controller: viewModelCreateGroup.emailController,
              decoration: InputDecoration(labelText: 'Email'),
              onSubmitted: (value) {
                viewModelAddMember.addEmail(value);
              },
            ),
            Expanded(
              child: ListView.builder(
                itemCount: viewModelAddMember.emailList.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(viewModelAddMember.emailList[index]),
                    trailing: IconButton(
                      icon: Icon(Icons.remove_circle_outline),
                      onPressed: () {
                        viewModelAddMember
                            .removeEmail(viewModelAddMember.emailList[index]);
                      },
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                int? groupId = await viewModelCreateGroup
                    .createGroupAndAddMembers(1, viewModelAddMember);

                bool success = groupId != null && groupId > 0;

                if (success) {
                  if (context.mounted) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MyGroups(groupId: groupId)),
                    );
                  }
                } else {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content:
                              Text('Tạo nhóm thất bại, vui lòng thử lại!')),
                    );
                  }
                }
              },
              child: Text('Create Group and Add Members'),
            )
          ],
        ),
      ),
    );
  }
}
