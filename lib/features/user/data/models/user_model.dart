import 'package:chat_application/features/user/domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  final String? userId;
  @override
  final String? username;
  @override
  final String? email;
  @override
  final String? phoneNumber;
  @override
  final bool? isOnline;
  @override
  final String? status;
  @override
  final String? profileUrl;

  const UserModel({
    this.username,
    this.email,
    this.phoneNumber,
    this.isOnline,
    this.userId,
    this.status,
    this.profileUrl,
  }) : super(
         username: username,
         email: email,
         userId: userId,
         profileUrl: profileUrl,
         phoneNumber: phoneNumber,
         isOnline: isOnline,
         status: status,
       );
  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
      userId: entity.userId,
      username: entity.username,
      email: entity.email,
      phoneNumber: entity.phoneNumber,
      isOnline: entity.isOnline,
      status: entity.status,
      profileUrl: entity.profileUrl,
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      username: json['username'],
      email: json['email'],
      phoneNumber: json['phone_number'],
      isOnline: json['is_online'],
      userId: json['user_id'],
      status: json['status'],
      profileUrl: json['profile_url'],
    );
  }

  Map<String, dynamic> toJson() => {
    "status": status,
    "profile_url": profileUrl,
    "phone_number": phoneNumber,
    "is_online": isOnline,
    "email": email,
    "username": username,
    "user_id": userId,
  };
}
