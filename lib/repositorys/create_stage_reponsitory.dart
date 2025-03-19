import 'package:work_flow/services/api_create_stage_client.dart';

class CreateStageReponsitory {
  final ApiCreateStageClient apiCreateStageClient = ApiCreateStageClient();

  Future<Map<String, dynamic>?> createStage({
    required String nameStage,
    required String descriptionStatus,
    required int workflowId,
  }) async {
    return await apiCreateStageClient.createStage(
      nameStage: nameStage,
      descriptionStatus: descriptionStatus,
      workflowId: workflowId,
    );
  }
}
