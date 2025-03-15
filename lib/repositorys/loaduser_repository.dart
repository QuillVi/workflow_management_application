import 'package:work_flow/services/api_load_user_client.dart';

class LoaduserRepository {
  final ApiLoaduserClient apiLoaduserClient;

  LoaduserRepository(this.apiLoaduserClient);

  Future<dynamic> loadUsers() async {
    return await apiLoaduserClient.loadUsers();
  }
}
