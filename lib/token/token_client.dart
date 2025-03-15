import 'package:shared_preferences/shared_preferences.dart';

class Tokenclient {
  Future<void> updateToken(String newToken) async {
    final prefs = await SharedPreferences.getInstance();
    final currentIDUser = prefs.getInt('IDUser');

    if (currentIDUser != null) {
      print('IDUser cũ được lưu: $currentIDUser');
    } else {
      print('Không tìm thấy IDUser cũ. Có thể chưa được lưu.');
    }

    await prefs.setString('token', newToken);

    if (currentIDUser != null) {
      await prefs.setInt('IDUser', currentIDUser);
    }

    print('Token mới đã được lưu thành công: $newToken');
  }

  Future<void> updateRefreshToken(String newRefreshToken) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('refreshToken', newRefreshToken);
    print('Refresh Token mới đã được lưu thành công: $newRefreshToken');
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<String?> getRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('refreshToken');
  }

  Future<int?> getIDUser() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('IDUser');
  }
}
