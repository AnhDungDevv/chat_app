import 'package:chat_application/features/call/domain/entities/call_entity.dart';

class CallModel extends CallEntity {
  final String? callId;
  final String? callerId;
  final String? callerName;
  final String? callerProfileUrl;

  final String? receiverId;
  final String? receiverName;
  final String? receiverProfileUrl;
  final bool? isCallDialed;
  final bool? isMissed;
  final DateTime? createdAt;

  const CallModel({
    this.callId,
    this.callerId,
    this.callerName,
    this.callerProfileUrl,
    this.receiverId,
    this.receiverName,
    this.receiverProfileUrl,
    this.isCallDialed,
    this.isMissed,
    this.createdAt,
  }) : super(
         callerId: callerId,
         callerName: callerName,
         callerProfileUrl: callerProfileUrl,
         callId: callId,
         isCallDialed: isCallDialed,
         receiverId: receiverId,
         receiverName: receiverName,
         receiverProfileUrl: receiverProfileUrl,
         isMissed: isMissed,
         createdAt: createdAt,
       );

  factory CallModel.fromJson(Map<String, dynamic> json) {
    return CallModel(
      callId: json['call_id'] as String?,
      callerId: json['caller_id'] as String?,
      callerName: json['caller_name'] as String?,
      callerProfileUrl: json['caller_profile_url'] as String?,
      receiverId: json['receiver_id'] as String?,
      receiverName: json['receiver_name'] as String?,
      receiverProfileUrl: json['receiver_profile_url'] as String?,
      isCallDialed: json['is_call_dialed'] as bool?,
      isMissed: json['is_missed'] as bool?,
      createdAt:
          json['created_at'] == null
              ? null
              : DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'call_id': callId,
      'caller_id': callerId,
      'caller_name': callerName,
      'caller_profile_url': callerProfileUrl,
      'receiver_id': receiverId,
      'receiver_name': receiverName,
      'receiver_profile_url': receiverProfileUrl,
      'is_call_dialed': isCallDialed,
      'is_missed': isMissed,
      'created_at': createdAt?.toIso8601String(),
    };
  }
}
