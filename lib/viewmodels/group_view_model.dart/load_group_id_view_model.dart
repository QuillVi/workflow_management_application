import 'package:flutter/material.dart';
import 'package:work_flow/repositorys/load_group_id_reponsitory.dart';
import 'package:work_flow/views/group_view/info_group_view.dart';

class LoadGroupIdViewModel extends ChangeNotifier {
  final LoadGroupIdReponsitory loadGroupIdReponsitory =
      LoadGroupIdReponsitory();

  bool _isEditing = false;
  String _title = '';
  bool _isLoading = false;
  Group? _group;

  bool get isEditing => _isEditing;
  String get title => _title;
  bool get isLoading => _isLoading;
  Group? get group => _group;

  void setEditing(bool value) {
    _isEditing = value;
    notifyListeners();
  }

  void setTitle(String newTitle) {
    _title = newTitle;
    notifyListeners();
  }

  Future<void> fetchGroupById(String groupId) async {
    if (groupId.isEmpty) {
      print('❌ groupId không được để trống');
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      final fetchedGroup = await loadGroupIdReponsitory.getGroupById(groupId);
      if (fetchedGroup != null) {
        _group = fetchedGroup;
        _title = fetchedGroup.GroupName;
      } else {
        print('⚠️ Không tìm thấy nhóm với ID: $groupId');
      }
    } catch (e) {
      print('❌ Lỗi khi tải nhóm: $e');
    }

    _isLoading = false;
    notifyListeners();
  }
}
