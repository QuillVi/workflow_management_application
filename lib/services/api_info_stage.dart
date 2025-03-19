import 'package:work_flow/apiclient/restfulapi.dart';
import 'package:work_flow/token/token_client.dart';

class ApiInfoStage {
  final RestfulApi restfulApi = RestfulApi();
  final Tokenclient tokenclient = Tokenclient();

  Future<Map<String, dynamic>?> fetchStageInfo(int stageId) async {
    final String apiUrl = '/stage/$stageId';

    final token = await tokenclient.getToken();

    if (token == null) {
      print('No token available');
      return null;
    }

    try {
      final response = await restfulApi.dioGet(
        apiUrl,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response != null) {
        return response;
      } else {
        throw Exception("Failed to load stage information.");
      }
    } catch (e) {
      print('Exception: $e');
      return null;
    }
  }
}
