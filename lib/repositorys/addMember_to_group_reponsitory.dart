import 'package:work_flow/services/api_addMember_to_group.dart';

class AddmemberToGroupReponsitory {
  final ApiAddmemberToGroup apiAddmemberToGroup = ApiAddmemberToGroup();

  Future<void> addMembers(int groupId, List<String> emailList) async {
    return await apiAddmemberToGroup.addMembersToGroup(groupId, emailList);
  }
}
