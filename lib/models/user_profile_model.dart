class UserProfileModel {
  final String userId;
  final String fullName;
  final String email;
  final bool admin;

  UserProfileModel({
    required this.userId,
    required this.email,
    required this.fullName,
    required this.admin,
  });

  static UserProfileModel fromJson(Map<String, dynamic> json, String userId) {
    return UserProfileModel(
      userId: userId,
      email: json['email'],
      fullName: json['fullname'],
      admin: json['admin'] ?? false,
    );
  }

  UserProfileModel copyWith(Map<String, dynamic> json) {
    return UserProfileModel(
      userId: userId,
      email: email,
      fullName: json['fullname'] ?? fullName,
      admin: admin,
    );
  }
}
