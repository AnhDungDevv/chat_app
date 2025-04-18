import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String? userId;
  final String? username;
  final String? email;
  final String? phoneNumber;
  final bool? isOnline;
  final String? uid;
  final String? status;
  final String? profileUrl;

  const UserEntity({
    this.userId,
    this.username,
    this.email,
    this.phoneNumber,
    this.isOnline,
    this.uid,
    this.status,
    this.profileUrl,
  });

  @override
  List<Object?> get props => [
    userId,
    username,
    email,
    phoneNumber,
    isOnline,
    uid,
    status,
    profileUrl,
  ];
}
