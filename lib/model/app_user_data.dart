class AppUserModel {
  String? id;
  String? name;
  String? email;
  String? role;
  String? countryCode;
  String? profileImage;

  AppUserModel({
    this.id,
    this.name,
    this.email,
    this.role,
    this.countryCode,
    this.profileImage,
  });

  factory AppUserModel.fromJson(Map<String, dynamic> json) {
    return AppUserModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? '',
      countryCode: json['countryCode'] ?? '',
      profileImage: json['profileImage'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'email': email,
      'role': role,
      'countryCode': countryCode,
      'profileImage': profileImage,
    };
  }
}
