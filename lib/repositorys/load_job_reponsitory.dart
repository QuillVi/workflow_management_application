import 'package:work_flow/services/api_load_job_client.dart';

class LoadJobReponsitory {
  final ApiLoadJobClient apiLoadJobClient = ApiLoadJobClient();

  Future<List<dynamic>> getJobs() async {
    return await apiLoadJobClient.loadJobs();
  }
}
