import 'package:flutter/material.dart';
import 'package:work_flow/services/api_fetch_job_status.dart';

class FecthJobStatusReponsitory {
  final ApiFecthJobStatus apiFecthJobStatus;

  FecthJobStatusReponsitory(this.apiFecthJobStatus);

  Future<Map<String, dynamic>> fetchJobData(BuildContext context) async {
    return await apiFecthJobStatus.fetchJobData(context);
  }
}
