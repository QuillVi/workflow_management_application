import 'package:flutter/material.dart';
import 'package:work_flow/apiclient/restfulapi.dart';
import 'package:work_flow/token/token_client.dart';

class ApiFecthJobStatus {
  final RestfulApi restfulApi = RestfulApi();
  final tokenClient = Tokenclient();

  Future<Map<String, dynamic>> fetchJobData(BuildContext context) async {
    try {
      int? idUser = await tokenClient.getIDUser();
      if (idUser == null) {
        throw Exception('IDUser không tồn tại.');
      }

      final response = await restfulApi.httpGet(
        "/job/TotalJobsInWeek/$idUser",
        headers: {'Authorization': 'Bearer ${await tokenClient.getToken()}'},
      );

      if (response != null && response['success'] == true) {
        return {
          'totalJobsReceived': response['data']['totalJobsReceived'],
          'totalJobsTodo': response['data']['totalJobsTodo'],
          'totalJobsDone': response['data']['totalJobsDone'],
          'totalJobsBug': response['data']['totalJobsBug'],
        };
      } else {
        throw Exception(
            response != null ? response['message'] : 'Lỗi không xác định.');
      }
    } catch (error) {
      print('Lỗi khi tải dữ liệu công việc: $error');
      throw Exception('Error: $error');
    }
  }
}
