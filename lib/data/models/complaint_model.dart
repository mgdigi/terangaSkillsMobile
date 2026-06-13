import 'user_model.dart';
import 'administrative_request_model.dart';

class ComplaintModel {
  final String id;
  final String title;
  final String description;
  final String? photoUrl;
  final double? latitude;
  final double? longitude;
  final String status;
  final String citizenId;
  final UserModel? citizen;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<ActionLogModel>? history;

  const ComplaintModel({
    required this.id,
    required this.title,
    required this.description,
    this.photoUrl,
    this.latitude,
    this.longitude,
    required this.status,
    required this.citizenId,
    this.citizen,
    required this.createdAt,
    required this.updatedAt,
    this.history,
  });

  factory ComplaintModel.fromJson(Map<String, dynamic> json) {
    return ComplaintModel(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      photoUrl: json['photoUrl']?.toString(),
      latitude: json['latitude'] != null ? double.tryParse(json['latitude'].toString()) : null,
      longitude: json['longitude'] != null ? double.tryParse(json['longitude'].toString()) : null,
      status: json['status']?.toString() ?? 'OPEN',
      citizenId: json['citizenId']?.toString() ?? '',
      citizen: json['citizen'] != null
          ? UserModel.fromJson(json['citizen'] as Map<String, dynamic>)
          : null,
      createdAt: json['createdAt'] != null ? DateTime.tryParse(json['createdAt'].toString()) ?? DateTime.now() : DateTime.now(),
      updatedAt: json['updatedAt'] != null ? DateTime.tryParse(json['updatedAt'].toString()) ?? DateTime.now() : DateTime.now(),
      history: json['history'] != null
          ? (json['history'] as List)
              .map((e) => ActionLogModel.fromJson(e as Map<String, dynamic>))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'photoUrl': photoUrl,
        'latitude': latitude,
        'longitude': longitude,
        'status': status,
        'citizenId': citizenId,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
      };

  bool get hasLocation => latitude != null && longitude != null;
}
