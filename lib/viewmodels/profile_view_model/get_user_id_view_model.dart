import 'package:flutter/material.dart';
import 'package:work_flow/repositorys/get_user_id_reponsitory.dart';

class GetUserIdViewModel extends ChangeNotifier {
  final GetUserIdReponsitory getUserIdReponsitory = GetUserIdReponsitory();

  String _name = "";
  String _username = "";
  bool _isLoading = false;
  String? _errorMessage;

  String get name => _name;
  String get username => _username;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> getUserProfile() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await getUserIdReponsitory.getUserProfile((name, username) {
        _name = name;
        _username = username;
        print('User data: $name, $username');
      });
    } catch (e) {
      _errorMessage = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }
}
