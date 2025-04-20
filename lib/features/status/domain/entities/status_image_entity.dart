import 'package:equatable/equatable.dart';

class StatusImageEntity extends Equatable {
  final String? statusId;
  final String? url;
  final String? type;
  final List<String>? viewers;

  const StatusImageEntity({this.url, this.viewers, this.type, this.statusId});

  factory StatusImageEntity.fromJson(Map<String, dynamic> json) {
    return StatusImageEntity(
      url: json['url'],
      type: json['type'],
      viewers: List.from(json['viewers']),
    );
  }

  static Map<String, dynamic> toJsonStatic(
    StatusImageEntity statusImageEntity,
  ) => {
    "status_id": statusImageEntity.statusId,
    "url": statusImageEntity.url,
    "viewers": statusImageEntity.viewers,
    "type": statusImageEntity.type,
  };
  Map<String, dynamic> toJson() => {
    "status_id": statusId,
    "url": url,
    "viewers": viewers,
    "type": type,
  };

  @override
  List<Object?> get props => [statusId, url, viewers, type];
}
