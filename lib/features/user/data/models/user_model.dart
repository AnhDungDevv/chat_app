import 'package:chat_application/features/user/domain/entities/user_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel extends UserEntity {
  @override
  final String? username;
  @override
  final String? email;
  @override
  final String? phoneNumber;
  @override
  final bool? isOnline;
  @override
  final String? uid;
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

  // Sửa từ 'DocumentSnapshot<Object?>' thành 'Map<String, dynamic>'
  factory UserModel.fromSnapshot(Map<String, dynamic> snapshot) {
    return UserModel(
      username: snapshot['username'],
      email: snapshot['email'],
      phoneNumber: snapshot['phoneNumber'],
      isOnline: snapshot['isOnline'],
      uid: snapshot['uid'],
      status: snapshot['status'],
      profileUrl: snapshot['profileUrl'],
    );
  }

  Map<String, dynamic> toDocument() => {
    "status": status,
    "profileUrl": profileUrl,
    "phoneNumber": phoneNumber,
    "isOnline": isOnline,
    "email": email,
    "username": username,
    "uid": uid,
  };
}
