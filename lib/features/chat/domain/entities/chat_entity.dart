import 'package:equatable/equatable.dart';

class ChatEntity extends Equatable {
  final String? id;
  final String? senderId;
  final String? recipientId;
  final String? senderName;
  final String? recipientName;
  final String? recentTextMessage;
  final DateTime? createdAt;
  final String? senderProfile;
  final String? recipientProfile;
  final num? totalUnReadMessages;

  const ChatEntity({
    this.id,
    this.senderId,
    this.recipientId,
    this.senderName,
    this.recipientName,
    this.recentTextMessage,
    this.createdAt,
    this.senderProfile,
    this.recipientProfile,
    this.totalUnReadMessages,
  });

  @override
  List<Object?> get props => [
    id,
    senderId,
    recipientId,
    senderName,
    recipientName,
    recentTextMessage,
    createdAt,
    senderProfile,
    recipientProfile,
    totalUnReadMessages,
  ];
}
