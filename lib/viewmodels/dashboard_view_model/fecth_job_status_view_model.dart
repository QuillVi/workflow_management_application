import 'package:flutter/material.dart';
import 'package:work_flow/repositorys/fecth_job_status_reponsitory.dart';

class FecthJobStatusViewModel extends ChangeNotifier {
  final FecthJobStatusReponsitory fecthJobStatusReponsitory;

  Map<String, dynamic> _jobStatus = {};
  bool _isLoading = false;
  String? _errorMessage;

  Map<String, dynamic> get jobStatus => _jobStatus;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  FecthJobStatusViewModel(this.fecthJobStatusReponsitory);

  Future<void> fetchJobData(BuildContext context) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      _jobStatus = await fecthJobStatusReponsitory.fetchJobData(context);
      print('Dữ liệu sau khi call API job status: $_jobStatus');
    } catch (error) {
      _errorMessage = 'Lỗi tải dữ liệu: $error';
    }

    _isLoading = false;
    notifyListeners();
  }
}
