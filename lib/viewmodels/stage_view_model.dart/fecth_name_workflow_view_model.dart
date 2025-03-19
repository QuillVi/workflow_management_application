import 'package:flutter/material.dart';
import 'package:work_flow/models/workflow_model/workflow_model.dart';
import 'package:work_flow/repositorys/load_workflow_id_reponsitory.dart';

class FecthNameWorkflowViewModel extends ChangeNotifier {
  final LoadWorkflowIdReponsitory loadWorkflowIdReponsitory =
      LoadWorkflowIdReponsitory();

  bool _isEditing = false;
  String _title = '';
  Workflow? _workflow;
  bool _isLoading = false;

  bool get isEditing => _isEditing;
  String get title => _title;
  Workflow? get workflow => _workflow;
  bool get isLoading => _isLoading;

  void setTitle(String newTitle) {
    _title = newTitle;
    notifyListeners();
  }

  void toggleEditing() {
    _isEditing = !_isEditing;
    notifyListeners();
  }

  Future<void> fetchNameWorkflow(int workflowId) async {
    _isLoading = true;
    notifyListeners();

    _workflow = await loadWorkflowIdReponsitory.getWorkflowById(workflowId);
    print('📌 Phản hồi từ API: ${_workflow?.toString()}');

    setTitle(_workflow?.Name ?? 'Không có tên');

    _isLoading = false;
    notifyListeners();
  }
}
