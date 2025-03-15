import 'package:work_flow/services/api_create_group_addMember.dart';

class CreateGroupAddmemberReponsitory {
  final ApiCreateGroupAddmember apiCreateGroupAddmember =
      ApiCreateGroupAddmember();

  Future<int?> createGroupAndAddMembers(String groupName, int idUser) async {
    return await apiCreateGroupAddmember.createGroupAndAddMembers(
        groupName, idUser);
  }
}
