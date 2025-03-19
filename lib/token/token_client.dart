import 'package:shared_preferences/shared_preferences.dart';
import 'package:work_flow/apiclient/restfulapi.dart';

class Tokenclient {
  final RestfulApi restfulApi = RestfulApi();
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

  Future<bool> refreshAccessToken() async {
    String? refreshToken = await getRefreshToken();

    if (refreshToken == null) {
      print('❌ Không tìm thấy Refresh Token.');
      return false;
    }

    try {
      final response = await restfulApi.httpPost(
        "/common/refreshToken",
        {'refreshToken': refreshToken},
        headers: {'Content-Type': 'application/json'},
      );

      if (response != null && response.containsKey('accessToken')) {
        String newAccessToken = response['accessToken'];
        await updateToken(newAccessToken);
        print('✅ Access Token đã được làm mới thành công.');
        return true;
      } else {
        print('⚠️ API refreshToken không trả về accessToken.');
        return false;
      }
    } catch (e) {
      print('🔴 Lỗi khi làm mới Access Token: $e');
      return false;
    }
  }
}
