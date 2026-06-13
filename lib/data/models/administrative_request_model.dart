import 'user_model.dart';

class AdministrativeRequestModel {
  final String id;
  final String type;
  final String title;
  final String description;
  final dynamic data;
  final List<String> attachments;
  final String status;
  final String citizenId;
  final UserModel? citizen;
  final String? assignedAgentId;
  final UserModel? assignedAgent;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<ActionLogModel>? history;

  const AdministrativeRequestModel({
    required this.id,
    required this.type,
    required this.title,
    required this.description,
    this.data,
    required this.attachments,
    required this.status,
    required this.citizenId,
    this.citizen,
    this.assignedAgentId,
    this.assignedAgent,
    required this.createdAt,
    required this.updatedAt,
    this.history,
  });

  factory AdministrativeRequestModel.fromJson(Map<String, dynamic> json) {
    return AdministrativeRequestModel(
      id: json['id']?.toString() ?? '',
      type: json['type']?.toString() ?? 'OTHER',
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      data: json['data'],
      attachments: json['attachments'] != null ? List<String>.from(json['attachments'] as List) : [],
      status: json['status']?.toString() ?? 'PENDING',
      citizenId: json['citizenId']?.toString() ?? '',
      citizen: json['citizen'] != null
          ? UserModel.fromJson(json['citizen'] as Map<String, dynamic>)
          : null,
      assignedAgentId: json['assignedAgentId'] as String?,
      assignedAgent: json['assignedAgent'] != null
          ? UserModel.fromJson(json['assignedAgent'] as Map<String, dynamic>)
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
        'type': type,
        'title': title,
        'description': description,
        'data': data,
        'attachments': attachments,
        'status': status,
        'citizenId': citizenId,
        'assignedAgentId': assignedAgentId,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
      };
}

class ActionLogModel {
  final String id;
  final String action;
  final String? description;
  final String actorId;
  final UserModel? actor;
  final DateTime createdAt;

  const ActionLogModel({
    required this.id,
    required this.action,
    this.description,
    required this.actorId,
    this.actor,
    required this.createdAt,
  });

  factory ActionLogModel.fromJson(Map<String, dynamic> json) {
    return ActionLogModel(
      id: json['id']?.toString() ?? '',
      action: json['action']?.toString() ?? '',
      description: json['description']?.toString(),
      actorId: json['actorId']?.toString() ?? '',
      actor: json['actor'] != null
          ? UserModel.fromJson(json['actor'] as Map<String, dynamic>)
          : null,
      createdAt: json['createdAt'] != null ? DateTime.tryParse(json['createdAt'].toString()) ?? DateTime.now() : DateTime.now(),
    );
  }
}
