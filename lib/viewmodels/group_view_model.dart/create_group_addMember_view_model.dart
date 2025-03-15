import 'package:flutter/material.dart';
import 'package:work_flow/repositorys/create_group_addMember_reponsitory.dart';
import 'package:work_flow/viewmodels/group_view_model.dart/addMember_to_group_view_model.dart';

class CreateGroupAddmemberViewModel extends ChangeNotifier {
  final CreateGroupAddmemberReponsitory createGroupAddmemberReponsitory =
      CreateGroupAddmemberReponsitory();

  final TextEditingController groupNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<int?> createGroupAndAddMembers(
      int idUser, AddmemberToGroupViewModel addMemberViewModel) async {
    final groupName = groupNameController.text.trim();

    if (groupName.isEmpty) {
      _errorMessage = 'Tên nhóm không được để trống.';
      notifyListeners();
      return null;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final groupId = await createGroupAddmemberReponsitory
          .createGroupAndAddMembers(groupName, idUser);

      if (groupId != null) {
        print('✅ Nhóm đã tạo với ID: $groupId, tiến hành thêm thành viên...');
        await addMemberViewModel.addMembersToGroup(groupId);
      }

      _isLoading = false;
      notifyListeners();
      return groupId;
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Lỗi khi tạo nhóm: $e';
      notifyListeners();
      return null;
    }
  }

  @override
  void dispose() {
    groupNameController.dispose();
    emailController.dispose();
    super.dispose();
  }
}
