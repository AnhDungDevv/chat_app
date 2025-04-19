import 'package:chat_application/features/chat/domain/entities/chat_entity.dart';

class ChatModel extends ChatEntity {
  final String? chatId;
  final String? senderId;
  final String? recipientId;
  final String? senderName;
  final String? recipientName;
  final String? recentTextMessage;
  final DateTime? createdAt;
  final String? senderProfile;
  final String? recipientProfile;
  final num? totalUnReadMessages;

  const ChatModel({
    this.chatId,
    this.senderId,
    this.recipientId,
    this.senderName,
    this.recipientName,
    this.recentTextMessage,
    this.createdAt,
    this.senderProfile,
    this.recipientProfile,
    this.totalUnReadMessages,
  }) : super(
         chatId: chatId,
         senderId: senderId,
         recipientId: recipientId,
         senderName: senderName,
         recipientName: recipientName,
         senderProfile: senderProfile,
         recipientProfile: recipientProfile,
         recentTextMessage: recentTextMessage,
         createdAt: createdAt,
         totalUnReadMessages: totalUnReadMessages,
       );

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
      chatId: json['chat_id'] as String?,
      senderId: json['sender_id'] as String?,
      senderName: json['sender_name'] as String?,
      senderProfile: json['sender_profile'] as String?,
      recipientId: json['recipient_id'] as String?,
      recipientName: json['recipient_name'] as String?,
      recipientProfile: json['recipient_profile'] as String?,
      recentTextMessage: json['recent_text_message'] as String?,
      createdAt: _parseDateTime(json['created_at']),
      totalUnReadMessages: json['total_un_read_messages'] as num?,
    );
  }

  static DateTime? _parseDateTime(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    if (value is String) return DateTime.tryParse(value);
    return null;
  }

  Map<String, dynamic> toJson() => {
    'sender_id': senderId,
    'sender_name': senderName,
    'sender_profile': senderProfile,
    'recipient_id': recipientId,
    'recipient_name': recipientName,
    'recipient_profile': recipientProfile,
    'recent_text_message': recentTextMessage,
    'created_at': createdAt?.toIso8601String(),
    'total_un_read_messages': totalUnReadMessages,
  };

  ChatEntity toEntity() => ChatEntity(
    chatId: chatId,
    senderId: senderId,
    senderName: senderName,
    senderProfile: senderProfile,
    recipientId: recipientId,
    recipientName: recipientName,
    recipientProfile: recipientProfile,
    recentTextMessage: recentTextMessage,
    createdAt: createdAt,
    totalUnReadMessages: totalUnReadMessages,
  );
}
