import 'package:flutter/material.dart';
import 'package:work_flow/repositorys/loaduser_repository.dart';

class LoaduserViewModel extends ChangeNotifier {
  final LoaduserRepository loaduserRepository;

  LoaduserViewModel(this.loaduserRepository);

  List<dynamic> _loadUsers = [];

  Future loadUsers() async {
    _loadUsers = await loaduserRepository.loadUsers();

    print('du lieu sao khi call api user: $_loadUsers');
    notifyListeners();
    return _loadUsers;
  }
}
