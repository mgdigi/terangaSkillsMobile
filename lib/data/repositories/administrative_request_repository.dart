import 'package:dio/dio.dart';
import '../../core/network/api_client.dart';
import '../models/administrative_request_model.dart';

class AdministrativeRequestRepository {
  final ApiClient _apiClient;

  AdministrativeRequestRepository({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient();

  /// Extracts a List from the response, handling both direct List and { data: [...] } formats.
  List<dynamic> _extractList(dynamic data) {
    if (data is List) return data;
    if (data is Map<String, dynamic>) {
      // Backend may wrap in { data: [...] } or { items: [...] } or { results: [...] }
      if (data['data'] is List) return data['data'] as List;
      if (data['items'] is List) return data['items'] as List;
      if (data['results'] is List) return data['results'] as List;
      // If the map itself is the single object, return it in a list
      if (data.containsKey('id')) return [data];
    }
    return [];
  }

  /// Extracts a single Map from the response, handling { data: {...} } wrapping.
  Map<String, dynamic> _extractMap(dynamic data) {
    if (data is Map<String, dynamic>) {
      if (data.containsKey('data') && data['data'] is Map) {
        return data['data'] as Map<String, dynamic>;
      }
      return data;
    }
    return {};
  }

  Future<AdministrativeRequestModel> createRequest({
    required String type,
    required String title,
    required String description,
    Map<String, dynamic>? data,
    List<MultipartFile>? files,
  }) async {
    final map = <String, dynamic>{
      'type': type,
      'title': title,
      'description': description,
    };
    if (data != null) map['data'] = data.toString();
    if (files != null && files.isNotEmpty) map['files'] = files;
    final formData = FormData.fromMap(map);
    final response = await _apiClient.createAdminRequest(formData);
    return AdministrativeRequestModel.fromJson(_extractMap(response.data));
  }

  Future<List<AdministrativeRequestModel>> getAllRequests() async {
    final response = await _apiClient.getAdminRequests();
    return _extractList(response.data)
        .map((e) =>
            AdministrativeRequestModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<AdministrativeRequestModel>> getMyRequests() async {
    final response = await _apiClient.getMyAdminRequests();
    return _extractList(response.data)
        .map((e) =>
            AdministrativeRequestModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<AdministrativeRequestModel> getRequest(String id) async {
    final response = await _apiClient.getAdminRequest(id);
    return AdministrativeRequestModel.fromJson(_extractMap(response.data));
  }

  Future<AdministrativeRequestModel> updateStatus(
      String id, String status) async {
    final response = await _apiClient.updateAdminRequestStatus(id, status);
    return AdministrativeRequestModel.fromJson(_extractMap(response.data));
  }

  Future<AdministrativeRequestModel> assignAgent(
      String id, String agentId) async {
    final response = await _apiClient.assignAgentToRequest(id, agentId);
    return AdministrativeRequestModel.fromJson(_extractMap(response.data));
  }

  Future<void> deleteRequest(String id) =>
      _apiClient.deleteAdminRequest(id);
}
