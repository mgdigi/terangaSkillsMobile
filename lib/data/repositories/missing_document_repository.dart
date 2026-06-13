import 'package:dio/dio.dart';
import '../../core/network/api_client.dart';
import '../models/missing_document_model.dart';

class MissingDocumentRepository {
  final ApiClient _apiClient;

  MissingDocumentRepository({ApiClient? apiClient})
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

  Future<MissingDocumentModel> create({
    required String title,
    required String description,
    String? lastSeenLocation,
    double? latitude,
    double? longitude,
    MultipartFile? file,
  }) async {
    final map = <String, dynamic>{
      'title': title,
      'description': description,
    };
    if (lastSeenLocation != null) map['lastSeenLocation'] = lastSeenLocation;
    if (latitude != null) map['latitude'] = latitude.toString();
    if (longitude != null) map['longitude'] = longitude.toString();
    if (file != null) map['file'] = file;
    final formData = FormData.fromMap(map);
    final response = await _apiClient.createMissingDocument(formData);
    return MissingDocumentModel.fromJson(_extractMap(response.data));
  }

  Future<List<MissingDocumentModel>> getAll() async {
    final response = await _apiClient.getMissingDocuments();
    return _extractList(response.data)
        .map((e) => MissingDocumentModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<MissingDocumentModel> getById(String id) async {
    final response = await _apiClient.getMissingDocument(id);
    return MissingDocumentModel.fromJson(_extractMap(response.data));
  }

  Future<MissingDocumentModel> updateStatus(String id, String status) async {
    final response = await _apiClient.updateMissingDocumentStatus(id, status);
    return MissingDocumentModel.fromJson(_extractMap(response.data));
  }

  Future<void> delete(String id) => _apiClient.deleteMissingDocument(id);
}
