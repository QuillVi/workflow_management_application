import 'package:flutter/foundation.dart';
import 'package:work_flow/repositorys/load_workflow_client_reponsitory.dart';

class LoadWorkflowClientViewModel extends ChangeNotifier {
  final LoadWorkflowClientReponsitory loadWorkflowClientReponsitory =
      LoadWorkflowClientReponsitory();

  List _workflows = [];
  bool _isLoading = false;

  List get workflows => _workflows;
  bool get isLoading => _isLoading;

  Future<void> loadWorkflows() async {
    _isLoading = true;
    notifyListeners();

    try {
      _workflows = await loadWorkflowClientReponsitory.getWorkflows();
    } catch (e) {
      print("❌ Lỗi khi tải workflows: $e");
      _workflows = [];
    }

    _isLoading = false;
    notifyListeners();
  }
}
