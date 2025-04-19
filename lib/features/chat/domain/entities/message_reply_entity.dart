class MessageReplayEntity {
  final String? message;
  final String? userId;
  final String? username;
  final String? messageType;
  final bool? isMe;

  MessageReplayEntity({
    this.message,
    this.username,
    this.userId,
    this.messageType,
    this.isMe,
  });
}
