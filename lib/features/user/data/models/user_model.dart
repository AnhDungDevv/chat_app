import 'package:chat_application/features/user/domain/entities/user_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel extends UserEntity {
  final String? uid;
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
    this.uid,
    this.status,
    this.profileUrl,
  }) : super(
         username: username,
         email: email,
         uid: uid,
         profileUrl: profileUrl,
         phoneNumber: phoneNumber,
         isOnline: isOnline,
         status: status,
       );

  factory UserModel.fromSnapshot(Map<String, dynamic> snapshot) {
    return UserModel(
      username: snapshot['username'],
      email: snapshot['email'],
      phoneNumber: snapshot['phone_number'],
      isOnline: snapshot['is_online'],
      uid: snapshot['uid'],
      status: snapshot['status'],
      profileUrl: snapshot['profile_url'],
    );
  }

  Map<String, dynamic> toDocument() => {
    "status": status,
    "profile_url": profileUrl,
    "phone_number": phoneNumber,
    "is_online": isOnline,
    "email": email,
    "username": username,
    "uid": uid,
  };
}
