import 'package:chat_application/features/chat/domain/entities/chat_entity.dart';
import 'package:chat_application/features/chat/domain/entities/message_entity.dart';
import 'package:chat_application/features/chat/presentation/cubit/message/message_cubit.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatUtils {
  static Future<void> sendMesssage(
    BuildContext context, {
    required MessageEntity messageEntity,
    String? message,
    String? type,
    String? repliedMessage,
    String? repliedTo,
    String? repliedMessageType,
  }) async {
    BlocProvider.of<MessageCubit>(context).sendMessage(
      message: MessageEntity(
        messageId: messageEntity.messageId,
        senderId: messageEntity.senderId,
        recipientId: messageEntity.recipientId,
        senderName: messageEntity.senderName,
        recipientName: messageEntity.recipientName,
        messageType: type,
        repliedMessage: repliedMessage ?? "",
        repliedTo: repliedTo,
        repliedMessageType: repliedMessageType ?? "",
        isSeen: false,
        createdAt: DateTime.now(),
        message: message,
      ),
      chat: ChatEntity(
        senderId: messageEntity.senderId,
        recipientId: messageEntity.recipientId,
        senderName: messageEntity.senderName,
        recipientName: messageEntity.recipientName,
        senderProfile: messageEntity.senderProfile,
        recipientProfile: messageEntity.recipientProfile,
        createdAt: DateTime.now(),
        totalUnReadMessages: 0,
      ),
    );
  }
}
