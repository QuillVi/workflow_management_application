import 'package:flutter/material.dart';
import 'package:work_flow/services/api_fecth_total_job_receiced.dart';

class FecthTotalJobReceicedReponsitory {
  final ApiFecthTotalJobReceiced apiFecthTotalJobReceiced;

  FecthTotalJobReceicedReponsitory(this.apiFecthTotalJobReceiced);

  Future<int> fetchTotalJobsReceived(BuildContext context) async {
    return await apiFecthTotalJobReceiced.fetchTotalJobsReceived(context);
  }
}
