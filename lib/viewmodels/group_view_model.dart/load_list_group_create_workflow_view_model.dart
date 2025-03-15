import 'package:flutter/material.dart';
import 'package:work_flow/repositorys/load_list_group_in_create_workflow_reponsitory.dart';

class LoadListGroupCreateWorkflowViewModel extends ChangeNotifier {
  final LoadListGroupInCreateWorkflowReponsitory
      loadListGroupInCreateWorkflowReponsitory =
      LoadListGroupInCreateWorkflowReponsitory();

  List<Map<String, dynamic>> _listGroups = [];
  List<Map<String, dynamic>> get listGroups => _listGroups;

  int? _selectedGroup;
  String? _selectedGroupName;

  int? get selectedGroup => _selectedGroup;
  String? get selectedGroupName => _selectedGroupName;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> loadListGroups() async {
    _isLoading = true;
    notifyListeners();

    await loadListGroupInCreateWorkflowReponsitory.loadGroups((groups) {
      _listGroups = groups;
      _isLoading = false;
      notifyListeners();
    });
  }

  void setSelectedGroup(int? groupId, String? groupName) {
    _selectedGroup = groupId;
    _selectedGroupName = groupName;
    notifyListeners();
  }
}
