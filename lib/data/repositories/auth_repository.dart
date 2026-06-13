import 'package:dio/dio.dart';
import '../../core/network/api_client.dart';
import '../models/auth_response_model.dart';
import '../models/user_model.dart';

class AuthRepository {
  final ApiClient _apiClient;

  AuthRepository({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();

  Map<String, dynamic> _safeMap(dynamic data) {
    if (data is Map<String, dynamic>) return data;
    return {};
  }

  Future<AuthResponseModel> login({
    required String email,
    required String password,
  }) async {
    final response = await _apiClient.login({'email': email, 'password': password});
    return AuthResponseModel.fromJson(_safeMap(response.data));
  }

  Future<AuthResponseModel> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    String? phone,
  }) async {
    final body = <String, dynamic>{
      'email': email,
      'password': password,
      'firstName': firstName,
      'lastName': lastName,
    };
    if (phone != null && phone.isNotEmpty) body['phone'] = phone;
    final response = await _apiClient.register(body);
    return AuthResponseModel.fromJson(_safeMap(response.data));
  }

  Future<UserModel> getProfile() async {
    final response = await _apiClient.getMe();
    final data = _safeMap(response.data);
    // Handle { data: {...} } wrapping
    final userData = data.containsKey('data') && data['data'] is Map
        ? data['data'] as Map<String, dynamic>
        : data;
    return UserModel.fromJson(userData);
  }
}
