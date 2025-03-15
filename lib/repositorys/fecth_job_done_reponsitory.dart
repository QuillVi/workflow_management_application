import 'package:flutter/material.dart';
import 'package:work_flow/services/api_fecth_job_done.dart';

class FecthJobDoneReponsitory {
  final ApiFecthJobDone apiFecthJobDone = ApiFecthJobDone();

  Future<List<Map<String, dynamic>>> fetchJobsDone(BuildContext context) async {
    return await apiFecthJobDone.fetchJobsDone(context);
  }
}
