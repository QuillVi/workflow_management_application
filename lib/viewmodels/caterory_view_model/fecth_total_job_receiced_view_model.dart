import 'package:flutter/material.dart';
import 'package:work_flow/repositorys/fecth_total_job_receiced_reponsitory.dart';

class FecthTotalJobReceicedViewModel extends ChangeNotifier {
  final FecthTotalJobReceicedReponsitory fecthTotalJobReceicedReponsitory;

  int _totalJobsReceived = 0;
  bool _isLoading = false;
  String? _errorMessage;

  FecthTotalJobReceicedViewModel(this.fecthTotalJobReceicedReponsitory);

  int get totalJobsReceived => _totalJobsReceived;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchTotalJobsReceived(BuildContext context) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _totalJobsReceived = await fecthTotalJobReceicedReponsitory
          .fetchTotalJobsReceived(context);
      print('Total Jobs Received: $_totalJobsReceived');
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
