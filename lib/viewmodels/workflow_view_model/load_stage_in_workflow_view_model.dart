import 'package:flutter/material.dart';
import 'package:work_flow/repositorys/load_stage_in_workflow_reponsitory.dart';

class LoadStageInWorkflowViewModel extends ChangeNotifier {
  final LoadStageInWorkflowReponsitory loadStageInWorkflowReponsitory =
      LoadStageInWorkflowReponsitory();

  final Map<int, List<Map<String, dynamic>>> _stagesMap = {};
  final Map<int, bool> _loadingMap = {};
  final Map<int, String> _errorMap = {};

  List<Map<String, dynamic>> getStages(int workflowId) {
    return _stagesMap[workflowId] ?? [];
  }

  bool isLoading(int workflowId) {
    return _loadingMap[workflowId] ?? false;
  }

  String getErrorMessage(int workflowId) {
    return _errorMap[workflowId] ?? '';
  }

  Future<void> loadStages(int workflowId) async {
    if (_stagesMap.containsKey(workflowId)) return;

    _loadingMap[workflowId] = true;
    _errorMap[workflowId] = '';
    notifyListeners();

    try {
      final fetchedStages = await loadStageInWorkflowReponsitory
          .getStagesByWorkflowId(workflowId);
      _stagesMap[workflowId] = fetchedStages;
      print("Full stages data: $fetchedStages");
    } catch (e) {
      _errorMap[workflowId] = "❌ Lỗi khi tải stages: $e";
    }

    _loadingMap[workflowId] = false;
    notifyListeners();
  }
}
