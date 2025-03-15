import 'package:flutter/material.dart';
import 'package:work_flow/repositorys/load_workflow_in_groupId_reponsitory.dart';

class LoadWorkflowInGroupidViewModel extends ChangeNotifier {
  final LoadWorkflowInGroupidReponsitory loadWorkflowInGroupidReponsitory =
      LoadWorkflowInGroupidReponsitory();

  bool _isLoading = false;
  bool _hasWorkflows = false;
  List<String> _workflowNames = [];

  bool get isLoading => _isLoading;
  bool get hasWorkflows => _hasWorkflows;
  List<String> get workflowNames => _workflowNames;

  Future<void> fetchWorkflowsByGroupId(int groupId) async {
    _isLoading = true;
    notifyListeners();

    try {
      final fetchedWorkflows =
          await loadWorkflowInGroupidReponsitory.getWorkflowsByGroupId(groupId);

      if (fetchedWorkflows != null && fetchedWorkflows.isNotEmpty) {
        _workflowNames = fetchedWorkflows;
        _hasWorkflows = true;
      } else {
        _workflowNames = [];
        _hasWorkflows = false;
      }
    } catch (e) {
      print('❌ Lỗi khi tải workflows: $e');
      _workflowNames = [];
      _hasWorkflows = false;
    }

    _isLoading = false;
    notifyListeners();
  }
}
