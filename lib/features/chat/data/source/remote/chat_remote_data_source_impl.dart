import 'dart:async';

import 'package:chat_application/features/app/constants/message_type_const.dart';
import 'package:chat_application/features/chat/data/models/chat_model.dart';
import 'package:chat_application/features/chat/data/models/message_model.dart';
import 'package:chat_application/features/chat/data/source/remote/chat_remote_data_source.dart';
import 'package:chat_application/features/chat/domain/entities/chat_entity.dart';
import 'package:chat_application/features/chat/domain/entities/message_entity.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  final SupabaseClient supabaseClient;
  const ChatRemoteDataSourceImpl({required this.supabaseClient});
  @override
  Future<void> deleteChat(ChatEntity chat) async {
    try {
      await supabaseClient.from('chats').delete().eq('id', chat.id as String);
    } catch (e) {
      print("Error occurred while delete chat: $e");
    }
  }

  @override
  Future<void> deleteMessage(MessageEntity message) async {
    try {
      await supabaseClient
          .from('messages')
          .delete()
          .eq('id', message.messageId as String);
    } catch (e) {
      print("Error occurred while delete mesage: $e");
    }
  }

  Future<void> addToChat(ChatEntity chat) async {
    final myNewChat =
        ChatModel(
          createdAt: chat.createdAt,
          senderProfile: chat.senderProfile,
          recipientProfile: chat.recipientProfile,
          recentTextMessage: chat.recentTextMessage,
          recipientName: chat.recipientName,
          senderName: chat.senderName,
          recipientId: chat.recipientId,
          senderId: chat.senderId,
          totalUnReadMessages: chat.totalUnReadMessages,
        ).toJson();
    final otherNewChat =
        ChatModel(
          createdAt: chat.createdAt,
          senderProfile: chat.recipientProfile,
          recipientProfile: chat.senderProfile,
          recentTextMessage: chat.recentTextMessage,
          recipientName: chat.senderName,
          senderName: chat.recipientName,
          recipientId: chat.senderId,
          senderId: chat.recipientId,
          totalUnReadMessages: chat.totalUnReadMessages,
        ).toJson();

    try {
      final existingChat =
          await supabaseClient
              .from('chats')
              .select()
              .eq('sender_id', chat.senderId as String)
              .eq('recipient_id', chat.recipientId as String)
              .maybeSingle();

      if (existingChat == null) {
        await supabaseClient.from('chats').insert(myNewChat);
        await supabaseClient.from('chats').insert(otherNewChat);
      } else {
        await supabaseClient
            .from('chats')
            .update(myNewChat)
            .eq('sender_id', chat.senderId as String)
            .eq('recipient_id', chat.recipientId as String);
        await supabaseClient
            .from('chats')
            .update(otherNewChat)
            .eq('sender_id', chat.recipientId as String)
            .eq('recipient_id', chat.senderId as String);
      }
    } catch (e) {
      print("Error occurred while adding/updating chat: $e");
    }
  }

  Future<void> sendMessageBaseOnType(MessageEntity message) async {
    String messageId = const Uuid().v1();
    final newMessage =
        MessageModel(
          senderId: message.senderId,
          recipientId: message.recipientId,
          senderName: message.senderName,
          recipientName: message.recipientName,
          createdAt: message.createdAt,
          repliedTo: message.repliedTo,
          repliedMessage: message.repliedMessage,
          isSeen: message.isSeen,
          messageType: message.messageType,
          message: message.message,
          messageId: messageId,
          repliedMessageType: message.repliedMessageType,
        ).toJson();
    try {
      await supabaseClient.from('messages').insert(newMessage);
    } catch (e) {
      print("Error occurred while sending message: $e");
    }
  }

  @override
  Stream<List<MessageEntity>> getMessages(MessageEntity message) {
    final controller = StreamController<List<MessageEntity>>();
    final List<MessageEntity> messages = [];

    final channel = supabaseClient.channel('public:messages');

    channel.onPostgresChanges(
      event: PostgresChangeEvent.all,
      schema: 'public',
      filter:
          'sender_id=eq.${message.senderId},recipient_id=eq.${message.recipientId}'
              as PostgresChangeFilter,
      callback: (payload) {
        final newData = payload.newRecord;
        final newMessage = MessageModel.fromJson(newData).toEntity();
        messages.add(newMessage);
        controller.add(List.from(messages));
      },
    );

    channel.subscribe();

    controller.onCancel = () {
      supabaseClient.removeChannel(channel);
    };
    return controller.stream;
  }

  @override
  Stream<List<ChatEntity>> getMyChat(ChatEntity chat) {
    final controller = StreamController<List<ChatEntity>>();
    final userId = chat.senderId;

    final List<ChatEntity> chats = [];
    supabaseClient
        .from('chats')
        .select()
        .eq('sender_id', userId.toString())
        .order('created_at', ascending: false)
        .then((response) {
          final initialChats =
              (response as List)
                  .map((e) => ChatModel.fromJson(e).toEntity())
                  .toList();

          chats.addAll(initialChats);
          controller.add(List.from(chats));
        });

    final channel =
        supabaseClient.channel('public:chats')
          ..onPostgresChanges(
            event: PostgresChangeEvent.all,
            schema: 'public',
            table: 'chats',
            filter: PostgresChangeFilter(
              column: 'sender_id',
              value: userId,
              type: PostgresChangeFilterType.eq,
            ),

            callback: (payload) {
              final newData = payload.newRecord;
              final newChat = ChatModel.fromJson(newData).toEntity();
              chats.add(newChat);
              controller.add(List.from(chats));
            },
          )
          ..subscribe();

    controller.onCancel = () {
      supabaseClient.removeChannel(channel);
    };
    return controller.stream;
  }

  @override
  Future<void> sendMessage(ChatEntity chat, MessageEntity message) async {
    await sendMessageBaseOnType(message);
    final recentTextMessage = _getRecentTextMessage(message);

    await addToChat(
      ChatEntity(
        createdAt: chat.createdAt,
        senderProfile: chat.senderProfile,
        recipientProfile: chat.recipientProfile,
        recentTextMessage: recentTextMessage,
        recipientName: chat.recipientName,
        senderName: chat.senderName,
        recipientId: chat.recipientId,
        senderId: chat.senderId,
        totalUnReadMessages: chat.totalUnReadMessages,
      ),
    );
  }
}

String _getRecentTextMessage(MessageEntity message) {
  switch (message.messageType) {
    case MessageTypeConst.photoMessage:
      return '📷 Photo';
    case MessageTypeConst.videoMessage:
      return '📸 Video';
    case MessageTypeConst.audioMessage:
      return '🎵 Audio';
    case MessageTypeConst.gifMessage:
      return 'GIF';
    default:
      return message.message ?? '';
  }
}
