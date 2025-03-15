import 'package:work_flow/services/api_load_group_client.dart';

class LoadListGroupInCreateWorkflowReponsitory {
  final ApiLoadGroupClient apiLoadGroupClient = ApiLoadGroupClient();

  Future<void> loadGroups(
      Function(List<Map<String, dynamic>>) updateGroups) async {
    final groups = await apiLoadGroupClient.loadGroup();
    final parsedGroups = groups
        .map<Map<String, dynamic>>((group) => {
              'GroupID': group['GroupID'],
              'GroupName': group['GroupName']?.toString() ?? '',
            })
        .toList();
    updateGroups(parsedGroups);
  }
}
