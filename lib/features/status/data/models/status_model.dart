import 'package:chat_application/features/status/domain/entities/status_enity.dart';
import 'package:chat_application/features/status/domain/entities/status_image_entity.dart';

class StatusModel extends StatusEntity {
  final String? statusId;
  final String? imageUrl;
  final String? userId;
  final String? username;
  final String? profileUrl;
  final DateTime? createdAt;
  final String? phoneNumber;
  final String? caption;
  final List<StatusImageEntity>? stories;

  const StatusModel({
    this.statusId,
    this.imageUrl,
    this.userId,
    this.username,
    this.profileUrl,
    this.createdAt,
    this.phoneNumber,
    this.caption,
    this.stories,
  }) : super(
         statusId: statusId,
         imageUrl: imageUrl,
         userId: userId,
         username: username,
         profileUrl: profileUrl,
         createdAt: createdAt,
         phoneNumber: phoneNumber,
         caption: caption,
         stories: stories,
       );

  factory StatusModel.fromJson(Map<String, dynamic> map) {
    final storiesRaw = map['stories'] as List<dynamic>?;

    return StatusModel(
      statusId: map['status_id'] as String?,
      imageUrl: map['image_url'] as String?,
      userId: map['user_id'] as String?,
      username: map['username'] as String?,
      profileUrl: map['profile_url'] as String?,
      createdAt:
          map['created_at'] != null ? DateTime.parse(map['created_at']) : null,
      phoneNumber: map['phone_number'] as String?,
      caption: map['caption'] as String?,
      stories:
          storiesRaw != null
              ? storiesRaw.map((e) => StatusImageEntity.fromJson(e)).toList()
              : [],
    );
  }

  Map<String, dynamic> toJson() => {
    "image_url": imageUrl,
    "user_id": userId,
    "username": username,
    "profile_url": profileUrl,
    "created_at": createdAt?.toIso8601String(),
    "phone_number": phoneNumber,
    "caption": caption,
  };
  StatusEntity toEntity() {
    return StatusEntity(
      statusId: statusId,
      imageUrl: imageUrl,
      userId: userId,
      username: username,
      profileUrl: profileUrl,
      createdAt: createdAt,
      phoneNumber: phoneNumber,
      caption: caption,
      stories: stories,
    );
  }
}
