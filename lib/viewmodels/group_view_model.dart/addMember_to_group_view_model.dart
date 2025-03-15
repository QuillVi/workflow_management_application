import 'package:flutter/material.dart';
import 'package:work_flow/repositorys/addMember_to_group_reponsitory.dart';

class AddmemberToGroupViewModel extends ChangeNotifier {
  final AddmemberToGroupReponsitory addmemberToGroupReponsitory =
      AddmemberToGroupReponsitory();

  bool _isLoading = false;
  String _errorMessage = '';
  List<String> _emailList = [];

  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  List<String> get emailList => _emailList;

  void addEmail(String email) {
    if (email.isNotEmpty && !_emailList.contains(email)) {
      _emailList.add(email);
      notifyListeners();
    }
  }

  void removeEmail(String email) {
    _emailList.remove(email);
    notifyListeners();
  }

  Future<void> addMembersToGroup(int groupId) async {
    if (_emailList.isEmpty) {
      _errorMessage = 'Danh sách email trống!';
      notifyListeners();
      return;
    }

    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      await addmemberToGroupReponsitory.addMembers(groupId, _emailList);
      print('✅ Thành viên đã được thêm vào nhóm $groupId');
      _emailList.clear();
    } catch (e) {
      _errorMessage = '🔴 Lỗi khi thêm thành viên: $e';
      print(_errorMessage);
    }

    _isLoading = false;
    notifyListeners();
  }
}
