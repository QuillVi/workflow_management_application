import 'package:flutter/material.dart';
import 'package:work_flow/repositorys/load_workflow_id_reponsitory.dart';
import 'package:work_flow/models/workflow_model/workflow_model.dart';

class LoadWorkflowIdViewModel extends ChangeNotifier {
  final LoadWorkflowIdReponsitory loadWorkflowIdReponsitory =
      LoadWorkflowIdReponsitory();

  bool _isEditing = false;
  bool get isEditing => _isEditing;

  String _title = '';
  String get title => _title;

  Workflow? _workflow;
  Workflow? get workflow => _workflow;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> fetchWorkflow(int workflowId) async {
    _isLoading = true;
    notifyListeners();

    _workflow = await loadWorkflowIdReponsitory.getWorkflowById(workflowId);

    if (_workflow != null) {
      _title = _workflow!.Name;
    }

    _isLoading = false;
    notifyListeners();
  }

  void enableEditing() {
    _isEditing = true;
    notifyListeners();
  }

  void disableEditing() {
    _isEditing = false;
    notifyListeners();
  }

  void updateTitle(String newTitle) {
    _title = newTitle;
    notifyListeners();
  }
}
