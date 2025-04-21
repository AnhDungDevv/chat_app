import 'dart:developer';

import 'package:chat_application/features/app/constants/page_const.dart';
import 'package:chat_application/features/call/domain/entities/call_entity.dart';
import 'package:chat_application/features/call/domain/usecases/get_call_channel_id_usecase.dart';
import 'package:chat_application/features/call/presentation/cubit/call/call_cubit.dart';
import 'package:chat_application/features/chat/domain/entities/chat_entity.dart';
import 'package:chat_application/features/chat/domain/entities/message_entity.dart';
import 'package:chat_application/features/chat/presentation/cubit/message/message_cubit.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chat_application/main_injection.dart' as di;

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

  static Future<void> makeCall(
    BuildContext context, {
    required CallEntity callEntity,
  }) async {
    BlocProvider.of<CallCubit>(context)
        .makeCall(
          CallEntity(
            callerId: callEntity.callerId,
            callerName: callEntity.callerName,
            callerProfileUrl: callEntity.callerProfileUrl,
            receiverId: callEntity.receiverId,
            receiverName: callEntity.receiverName,
            receiverProfileUrl: callEntity.receiverProfileUrl,
          ),
        )
        .then((value) {
          di.sl<GetCallChannelIdUseCase>()(callEntity.callerId!).then((
            callChannelId,
          ) {
            Navigator.pushNamed(
              context,
              PageConst.callPage,
              arguments: CallEntity(
                callId: callChannelId,
                callerId: callEntity.callerId,
                receiverId: callEntity.receiverId,
              ),
            );
            BlocProvider.of<CallCubit>(context).saveCallHistory(
              CallEntity(
                callId: callChannelId,
                callerId: callEntity.callerId,
                callerName: callEntity.callerName,
                callerProfileUrl: callEntity.callerProfileUrl,
                receiverId: callEntity.receiverId,
                receiverName: callEntity.receiverName,
                receiverProfileUrl: callEntity.receiverProfileUrl,
                isCallDialed: false,
                isMissed: false,
              ),
            );
            log("callChannelId = $callChannelId");
          });
        });
  }
}
