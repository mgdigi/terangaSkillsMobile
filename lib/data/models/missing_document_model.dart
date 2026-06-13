import 'user_model.dart';
import 'administrative_request_model.dart';

class MissingDocumentModel {
  final String id;
  final String title;
  final String description;
  final String? photoUrl;
  final String? lastSeenLocation;
  final double? latitude;
  final double? longitude;
  final String status;
  final bool isVerified;
  final String reportedById;
  final UserModel? reportedBy;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<ActionLogModel>? history;

  const MissingDocumentModel({
    required this.id,
    required this.title,
    required this.description,
    this.photoUrl,
    this.lastSeenLocation,
    this.latitude,
    this.longitude,
    required this.status,
    required this.isVerified,
    required this.reportedById,
    this.reportedBy,
    required this.createdAt,
    required this.updatedAt,
    this.history,
  });

  factory MissingDocumentModel.fromJson(Map<String, dynamic> json) {
    return MissingDocumentModel(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      photoUrl: json['photoUrl']?.toString(),
      lastSeenLocation: json['lastSeenLocation']?.toString(),
      latitude: json['latitude'] != null ? double.tryParse(json['latitude'].toString()) : null,
      longitude: json['longitude'] != null ? double.tryParse(json['longitude'].toString()) : null,
      status: json['status']?.toString() ?? 'MISSING',
      isVerified: json['isVerified'] as bool? ?? false,
      reportedById: json['reportedById']?.toString() ?? '',
      reportedBy: json['reportedBy'] != null
          ? UserModel.fromJson(json['reportedBy'] as Map<String, dynamic>)
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
        'lastSeenLocation': lastSeenLocation,
        'latitude': latitude,
        'longitude': longitude,
        'status': status,
        'isVerified': isVerified,
        'reportedById': reportedById,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
      };

  bool get hasLocation => latitude != null && longitude != null;
  bool get isFound => status == 'FOUND';
}
