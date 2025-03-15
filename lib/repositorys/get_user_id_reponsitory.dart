import 'package:work_flow/services/api_get_user_id.dart';

class GetUserIdReponsitory {
  final ApiGetUserId apiGetUserId = ApiGetUserId();

  Future<void> getUserProfile(Function(String, String) updateUser) async {
    return await apiGetUserId.getUserProfile(updateUser);
  }
}
