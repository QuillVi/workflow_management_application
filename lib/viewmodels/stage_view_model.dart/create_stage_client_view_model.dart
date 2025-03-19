import 'package:flutter/material.dart';
import 'package:work_flow/repositorys/create_stage_reponsitory.dart';

class CreateStageClientViewModel extends ChangeNotifier {
  final CreateStageReponsitory createStageReponsitory =
      CreateStageReponsitory();

  bool _isLoading = false;
  bool _isEditing = false;
  String? _errorMessage;

  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  bool get isLoading => _isLoading;
  bool get isEditing => _isEditing;
  String? get errorMessage => _errorMessage;

  void toggleEditing() {
    _isEditing = !_isEditing;
    notifyListeners();
  }

  void initControllers() {
    titleController.text = '';
    descriptionController.text = '';
  }

  Future<bool> createStage({required int workflowId}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await createStageReponsitory.createStage(
        nameStage: titleController.text.trim(),
        descriptionStatus: descriptionController.text.trim(),
        workflowId: workflowId,
      );
      print('dữ liệu khi cal api: $response');

      if (response != null && response.containsKey('IdStage')) {
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = "Không thể tạo Stage. Vui lòng thử lại!";
      }
    } catch (e) {
      _errorMessage = "Lỗi khi tạo Stage: $e";
    }

    _isLoading = false;
    notifyListeners();
    return false;
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }
}
