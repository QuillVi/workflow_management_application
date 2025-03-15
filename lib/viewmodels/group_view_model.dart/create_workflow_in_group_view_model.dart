import 'package:flutter/material.dart';
import 'package:work_flow/repositorys/create_workflow_in_group_reponsitory.dart';

class CreateWorkflowInGroupViewModel extends ChangeNotifier {
  final CreateWorkflowInGroupReponsitory createWorkflowInGroupReponsitory =
      CreateWorkflowInGroupReponsitory();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isEditing = false;
  bool get isEditing => _isEditing;

  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  List<Map<String, String>> _stages = [];
  List<Map<String, String>> get stages => _stages;

  final TextEditingController stageNameController = TextEditingController();
  final TextEditingController stageDescriptionController =
      TextEditingController();

  void addStage(String name, String description) {
    _stages.add({'name': name, 'description': description});
    print("✅ Stage Added: $_stages");
    notifyListeners();
  }

  void clearStages() {
    _stages.clear();
    notifyListeners();
  }

  void clearInputFields() {
    titleController.clear();
    descriptionController.clear();
    stageNameController.clear();
    stageDescriptionController.clear();
  }

  Future<int?> createWorkflow(int selectedGroupId) async {
    final String name = titleController.text.trim();
    final String description = descriptionController.text.trim();

    if (name.isEmpty || description.isEmpty) {
      print('⚠️ Vui lòng nhập đủ thông tin Workflow!');
      return null;
    }

    _isLoading = true;
    notifyListeners();

    try {
      int? workflowId = await createWorkflowInGroupReponsitory.createWorkflow(
        name,
        description,
        selectedGroupId,
        _stages,
      );

      if (workflowId != null) {
        print("✅ Workflow được tạo thành công với ID: $workflowId");
        clearInputFields();
        clearStages();
      }

      return workflowId;
    } catch (e) {
      print("❌ Lỗi khi tạo workflow: $e");
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setEditing(bool value) {
    _isEditing = value;
    notifyListeners();
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    stageNameController.dispose();
    stageDescriptionController.dispose();
    super.dispose();
  }
}
