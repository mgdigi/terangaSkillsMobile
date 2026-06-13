class AuthResponseModel {
  final String accessToken;
  final Map<String, dynamic> user;

  const AuthResponseModel({
    required this.accessToken,
    required this.user,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? json;
    
    final token = data['access_token']?.toString() ??
        data['accessToken']?.toString() ??
        data['token']?.toString() ??
        '';
        
    return AuthResponseModel(
      accessToken: token,
      user: data['user'] != null ? Map<String, dynamic>.from(data['user'] as Map) : {},
    );
  }

  Map<String, dynamic> toJson() => {
        'access_token': accessToken,
        'user': user,
      };
}
