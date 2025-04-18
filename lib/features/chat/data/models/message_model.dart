import 'package:chat_application/features/chat/domain/entities/message_entity.dart';

class MessageModel extends MessageEntity {
  final String? senderId;
  final String? recipientId;
  final String? senderName;
  final String? recipientName;
  final String? messageType;
  final String? message;
  final DateTime? createdAt;
  final bool? isSeen;
  final String? repliedTo;
  final String? repliedMessage;
  final String? repliedMessageType;
  final String? messageId;

  const MessageModel({
    this.senderId,
    this.recipientId,
    this.senderName,
    this.recipientName,
    this.messageType,
    this.message,
    this.createdAt,
    this.isSeen,
    this.repliedTo,
    this.repliedMessage,
    this.repliedMessageType,
    this.messageId,
  }) : super(
         senderId: senderId,
         recipientId: recipientId,
         senderName: senderName,
         recipientName: recipientName,
         message: message,
         messageType: messageType,
         messageId: messageId,
         createdAt: createdAt,
         isSeen: isSeen,
         repliedTo: repliedTo,
         repliedMessage: repliedMessage,
         repliedMessageType: repliedMessageType,
       );

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      senderId: json['sender_id'] as String?,
      senderName: json['sender_name'] as String?,
      recipientId: json['recipient_id'] as String?,
      recipientName: json['sender_name'] as String?,
      createdAt: _parseDateTime(json['created_at']),
      isSeen: json['is_seen'] as bool?,
      message: json['message'] as String?,
      messageType: json['message_type'] as String?,
      repliedMessage: json['replied_message'] as String?,
      repliedTo: json['replied_to'] as String?,
      messageId: json['message_id'] as String?,
      repliedMessageType: json['replied_message_type'] as String?,
    );
  }

  static DateTime? _parseDateTime(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    if (value is String) return DateTime.tryParse(value);
    return null;
  }

  Map<String, dynamic> toJson() => {
    "sender_id": senderId,
    "sender_name": senderName,
    "recipient_id": recipientId,
    "recipient_name": recipientName,
    "created_at": createdAt?.toIso8601String(),
    "is_seen": isSeen,
    "message": message,
    "message_type": messageType,
    "replied_message": repliedMessage,
    "replied_to": repliedTo,
    "message_id": messageId,
    "replied_message_type": repliedMessageType,
  };

  MessageEntity toEntity() {
    return MessageEntity(
      senderId: senderId,
      recipientId: recipientId,
      senderName: senderName,
      recipientName: recipientName,
      message: message,
      messageType: messageType,
      messageId: messageId,
      createdAt: createdAt,
      isSeen: isSeen,
      repliedTo: repliedTo,
      repliedMessage: repliedMessage,
      repliedMessageType: repliedMessageType,
    );
  }
}
