import 'package:flutter/material.dart';
import 'package:work_flow/repositorys/info_stage_reponsitory.dart';

class InfoStageViewModel extends ChangeNotifier {
  final InfoStageReponsitory infoStageReponsitory = InfoStageReponsitory();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  Map<String, dynamic>? _stageInfo;
  Map<String, dynamic>? get stageInfo => _stageInfo;

  bool _isEditing = false;
  bool get isEditing => _isEditing;

  String _title = '';
  String get title => _title;

  Future<void> loadStageInfo(int stageId) async {
    _isLoading = true;
    _errorMessage = ''; // Xóa lỗi cũ
    notifyListeners();

    try {
      final stageData = await infoStageReponsitory.getStageInfo(stageId);
      print("Stage data from API: $stageData");

      if (stageData != null && stageData.isNotEmpty) {
        _stageInfo = stageData;
        _title = _stageInfo!['NameStage'].toString();
        _errorMessage = '';
      } else {
        _errorMessage = 'Không thể tải thông tin Stage';
      }
    } catch (e) {
      _errorMessage = 'Lỗi khi tải thông tin: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void toggleEditing() {
    _isEditing = !_isEditing;
    notifyListeners();
  }

  void updateTitle(String newTitle) {
    _title = newTitle;
    notifyListeners();
  }
}
