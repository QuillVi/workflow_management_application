import 'package:flutter/material.dart';
import 'package:work_flow/repositorys/load_workflow_in_groupId_reponsitory.dart';

class LoadWorkflowInGroupidViewModel extends ChangeNotifier {
  final LoadWorkflowInGroupidReponsitory loadWorkflowInGroupidReponsitory =
      LoadWorkflowInGroupidReponsitory();

  List<dynamic> _workflows = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<dynamic> get workflows => _workflows;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchWorkflows(int groupId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _workflows =
          await loadWorkflowInGroupidReponsitory.getWorkflowsByGroupId(groupId);
    } catch (e) {
      _errorMessage = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }
}
