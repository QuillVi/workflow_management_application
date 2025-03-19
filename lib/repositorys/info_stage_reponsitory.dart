import 'package:work_flow/services/api_info_stage.dart';

class InfoStageReponsitory {
  final ApiInfoStage apiInfoStage = ApiInfoStage();

  Future<Map<String, dynamic>?> getStageInfo(int stageId) async {
    try {
      final stageInfo = await apiInfoStage.fetchStageInfo(stageId);

      if (stageInfo != null) {
        return stageInfo;
      } else {
        throw Exception('Không thể lấy thông tin Stage');
      }
    } catch (e) {
      print('Error in InfoStageRepository: $e');
      return null;
    }
  }
}
