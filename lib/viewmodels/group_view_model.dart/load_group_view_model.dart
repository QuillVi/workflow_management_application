import 'package:flutter/material.dart';
import 'package:work_flow/repositorys/loadgroup_reponsitory.dart';

class LoadGroupViewModel extends ChangeNotifier {
  final LoadgroupReponsitory loadgroupReponsitory = LoadgroupReponsitory();

  List<dynamic> groupList = [];
  bool isLoading = false;

  List<dynamic> getGroupList() => groupList;
  bool getIsLoading() => isLoading;

  Future<void> fetchGroups() async {
    isLoading = true;
    notifyListeners();

    try {
      final response = await loadgroupReponsitory.loadGroup();

      if (response.isNotEmpty) {
        groupList = List.from(response);
        print('Danh sách nhóm đã cập nhật: $groupList');
      } else {
        print('API trả về danh sách nhóm rỗng.');
      }
    } catch (e) {
      print('Lỗi khi lấy danh sách nhóm: $e');
    }

    isLoading = false;
    notifyListeners();
  }
}
