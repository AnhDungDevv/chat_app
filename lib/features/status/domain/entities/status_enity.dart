import 'package:chat_application/features/status/domain/entities/status_image_entity.dart';
import 'package:equatable/equatable.dart';

class StatusEntity extends Equatable {
  final String? statusId;
  final String? imageUrl;
  final String? userId;
  final String? username;
  final String? profileUrl;
  final DateTime? createdAt;
  final String? phoneNumber;
  final String? caption;
  final List<StatusImageEntity>? stories;

  const StatusEntity({
    this.statusId,
    this.imageUrl,
    this.userId,
    this.username,
    this.profileUrl,
    this.createdAt,
    this.phoneNumber,
    this.caption,
    this.stories,
  });

  @override
  List<Object?> get props => [
    statusId,
    imageUrl,
    userId,
    username,
    profileUrl,
    createdAt,
    phoneNumber,
    caption,
    stories,
  ];
}
