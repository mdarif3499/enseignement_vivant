import 'package:enseignement_vivant/constant/app_api_end_point.dart';

class AppUserModel {
  String? id;
  String? name;
  String? email;
  String? role;
  String? subrole;
  String? countryCode;
  String? profileImage;
  String? status;
  bool? verified;
  List<String>? fcmTokens;
  List<String>? permissions;
  String? createdAt;
  String? updatedAt;

  AppUserModel({
    this.id,
    this.name,
    this.email,
    this.role,
    this.subrole,
    this.countryCode,
    this.profileImage,
    this.status,
    this.verified,
    this.fcmTokens,
    this.permissions,
    this.createdAt,
    this.updatedAt,
  });

  factory AppUserModel.fromJson(Map<String, dynamic> json) {
    String profileImg = json['image']?.toString() ?? json['profileImage']?.toString() ?? '';
    if (profileImg.isNotEmpty && !profileImg.startsWith('http')) {
      if (profileImg.startsWith('/files/')) {
        profileImg = "${AppApiEndPoint.instance.domain}$profileImg";
      } else if (profileImg.startsWith('/')) {
        profileImg = "${AppApiEndPoint.instance.imageBaseUrl}$profileImg";
      } else {
        profileImg = "${AppApiEndPoint.instance.imageBaseUrl}/$profileImg";
      }
    }

    return AppUserModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? '',
      subrole: json['subrole'] ?? '',
      countryCode: json['countryCode'] ?? '',
      profileImage: profileImg,
      status: json['status'] ?? '',
      verified: json['verified'] ?? false,
      fcmTokens: json['fcmTokens'] != null ? List<String>.from(json['fcmTokens']) : [],
      permissions: json['permissions'] != null ? List<String>.from(json['permissions']) : [],
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'email': email,
      'role': role,
      'subrole': subrole,
      'countryCode': countryCode,
      'profileImage': profileImage,
      'status': status,
      'verified': verified,
      'fcmTokens': fcmTokens,
      'permissions': permissions,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
