import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:work_flow/token/token_client.dart';

const String baseUrl = "http://192.168.1.2:3000/api";
final Tokenclient tokenClient = Tokenclient();

class RestfulApi {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: baseUrl,
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  ));

  // ========================= HTTP METHODS =========================

  /// Xử lý request chung cho HTTP
  Future<dynamic> _httpRequest(Future<http.Response> Function() request) async {
    try {
      final response = await request();

      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body);
      }

      if (response.statusCode == 401) {
        print('Access Token hết hạn. Gọi API refreshToken...');

        String? refreshToken = await tokenClient.getRefreshToken();
        if (refreshToken == null) {
          throw Exception(
              "Refresh token không tồn tại, yêu cầu đăng nhập lại.");
        }

        // Gọi API refresh token
        final refreshResponse = await httpPost("/common/refreshToken", {
          'refreshToken': refreshToken,
        });

        if (refreshResponse != null &&
            refreshResponse.containsKey('accessToken')) {
          await tokenClient.updateToken(refreshResponse['accessToken']);
          print('Access Token mới đã được cập nhật.');

          // Gọi lại API sau khi cập nhật token
          return await _httpRequest(request);
        } else {
          throw Exception('API refreshToken không trả về accessToken.');
        }
      }

      throw Exception("HTTP Error: ${response.statusCode} - ${response.body}");
    } catch (e) {
      throw Exception("HTTP Request Error: $e");
    }
  }

  /// GET request using HTTP
  Future<dynamic> httpGet(String endpoint,
      {Map<String, String>? headers}) async {
    return _httpRequest(() => http.get(
          Uri.parse('$baseUrl$endpoint'),
          headers: headers ?? {"Content-Type": "application/json"},
        ));
  }

  /// POST request using HTTP
  Future<dynamic> httpPost(String endpoint, Map<String, dynamic> body,
      {Map<String, String>? headers}) async {
    return _httpRequest(() => http.post(
          Uri.parse('$baseUrl$endpoint'),
          headers: headers ?? {"Content-Type": "application/json"},
          body: jsonEncode(body),
        ));
  }

  /// PUT request using HTTP
  Future<dynamic> httpPut(String endpoint, Map<String, dynamic> body,
      {Map<String, String>? headers}) async {
    return _httpRequest(() => http.put(
          Uri.parse('$baseUrl$endpoint'),
          headers: headers ?? {"Content-Type": "application/json"},
          body: jsonEncode(body),
        ));
  }

  /// DELETE request using HTTP
  Future<dynamic> httpDelete(String endpoint,
      {Map<String, String>? headers}) async {
    return _httpRequest(() => http.delete(
          Uri.parse('$baseUrl$endpoint'),
          headers: headers ?? {"Content-Type": "application/json"},
        ));
  }

  // ========================= DIO METHODS =========================

  /// Xử lý request chung cho Dio
  Future<dynamic> _dioRequest(Future<Response> Function() request) async {
    try {
      final response = await request();
      return response.data;
    } catch (e) {
      throw Exception("Dio Request Error: $e");
    }
  }

  /// GET request using Dio
  Future<dynamic> dioGet(String endpoint,
      {Map<String, dynamic>? headers}) async {
    return _dioRequest(
        () => _dio.get(endpoint, options: Options(headers: headers)));
  }

  /// POST request using Dio
  Future<dynamic> dioPost(String endpoint, Map<String, dynamic> body,
      {Map<String, dynamic>? headers}) async {
    return _dioRequest(() =>
        _dio.post(endpoint, data: body, options: Options(headers: headers)));
  }

  /// PUT request using Dio
  Future<dynamic> dioPut(String endpoint, Map<String, dynamic> body,
      {Map<String, dynamic>? headers}) async {
    return _dioRequest(() =>
        _dio.put(endpoint, data: body, options: Options(headers: headers)));
  }

  /// DELETE request using Dio
  Future<dynamic> dioDelete(String endpoint,
      {Map<String, dynamic>? headers}) async {
    return _dioRequest(
        () => _dio.delete(endpoint, options: Options(headers: headers)));
  }
}
