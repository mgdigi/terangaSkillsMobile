import 'package:dio/dio.dart';
import '../../core/network/api_client.dart';
import '../models/complaint_model.dart';

class ComplaintRepository {
  final ApiClient _apiClient;

  ComplaintRepository({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient();

  List<dynamic> _extractList(dynamic data) {
    if (data is List) return data;
    if (data is Map<String, dynamic>) {
      if (data['data'] is List) return data['data'] as List;
      if (data['items'] is List) return data['items'] as List;
      if (data['results'] is List) return data['results'] as List;
      if (data.containsKey('id')) return [data];
    }
    return [];
  }

  Map<String, dynamic> _extractMap(dynamic data) {
    if (data is Map<String, dynamic>) {
      if (data.containsKey('data') && data['data'] is Map) {
        return data['data'] as Map<String, dynamic>;
      }
      return data;
    }
    return {};
  }

  Future<ComplaintModel> createComplaint({
    required String title,
    required String description,
    double? latitude,
    double? longitude,
    MultipartFile? file,
  }) async {
    final map = <String, dynamic>{
      'title': title,
      'description': description,
    };
    if (latitude != null) map['latitude'] = latitude.toString();
    if (longitude != null) map['longitude'] = longitude.toString();
    if (file != null) map['file'] = file;
    final formData = FormData.fromMap(map);
    final response = await _apiClient.createComplaint(formData);
    return ComplaintModel.fromJson(_extractMap(response.data));
  }

  Future<List<ComplaintModel>> getAllComplaints() async {
    final response = await _apiClient.getComplaints();
    return _extractList(response.data)
        .map((e) => ComplaintModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<ComplaintModel>> getMyComplaints() async {
    final response = await _apiClient.getMyComplaints();
    return _extractList(response.data)
        .map((e) => ComplaintModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<ComplaintModel> getComplaint(String id) async {
    final response = await _apiClient.getComplaint(id);
    return ComplaintModel.fromJson(_extractMap(response.data));
  }

  Future<ComplaintModel> updateStatus(String id, String status) async {
    final response = await _apiClient.updateComplaintStatus(id, status);
    return ComplaintModel.fromJson(_extractMap(response.data));
  }

  Future<void> deleteComplaint(String id) => _apiClient.deleteComplaint(id);
}
