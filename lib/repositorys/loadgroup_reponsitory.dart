import 'package:work_flow/services/api_load_group_client.dart';

class LoadgroupReponsitory {
  final ApiLoadGroupClient apiLoadGroupClient = ApiLoadGroupClient();

  Future<dynamic> loadGroup() async {
    return await apiLoadGroupClient.loadGroup();
  }
}
