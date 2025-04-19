import 'dart:async';

import 'package:chat_application/features/app/constants/message_type_const.dart';
import 'package:chat_application/features/chat/data/models/chat_model.dart';
import 'package:chat_application/features/chat/data/models/message_model.dart';
import 'package:chat_application/features/chat/data/source/remote/chat_remote_data_source.dart';
import 'package:chat_application/features/chat/domain/entities/chat_entity.dart';
import 'package:chat_application/features/chat/domain/entities/message_entity.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  final SupabaseClient supabaseClient;
  const ChatRemoteDataSourceImpl({required this.supabaseClient});
  @override
  Future<void> deleteChat(ChatEntity chat) async {
    try {
      await supabaseClient
          .from('chats')
          .delete()
          .eq('chat_id', chat.chatId as String);
    } catch (e) {
      print("Error occurred while delete chat: $e");
    }
  }

  @override
  Future<void> deleteMessage(MessageEntity message) async {
    print("message delete ${message.messageId}");
    try {
      await supabaseClient
          .from('messages')
          .delete()
          .eq('message_id', message.messageId as String)
          .eq('sender_id', message.senderId as String)
          .eq('message_id', message.messageId as String);
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
    supabaseClient
        .from('messages')
        .select()
        .or(
          'and(sender_id.eq.${message.senderId},recipient_id.eq.${message.recipientId}),and(sender_id.eq.${message.recipientId},recipient_id.eq.${message.senderId})',
        )
        .order('created_at', ascending: true)
        .then((data) {
          final history =
              data.map((e) => MessageModel.fromJson(e).toEntity()).toList();
          messages.addAll(history);
          controller.add(List.from(messages));
        })
        .catchError((e) {
          print("Error loading message history: $e");
        });

    final channel = supabaseClient.channel('public:messages');

    channel.onPostgresChanges(
      event: PostgresChangeEvent.all,
      schema: 'public',
      table: 'messages',
      callback: (payload) {
        final newData = payload.newRecord;
        final oldData = payload.oldRecord;

        print('Postgres payload: $payload');

        if (newData != null) {
          final newMessage = MessageModel.fromJson(newData).toEntity();

          final isRelevant =
              (newMessage.senderId == message.senderId &&
                  newMessage.recipientId == message.recipientId) ||
              (newMessage.senderId == message.recipientId &&
                  newMessage.recipientId == message.senderId);

          if (isRelevant) {
            messages.removeWhere((m) => m.messageId == newMessage.messageId);
            messages.add(newMessage);
            messages.sort((a, b) => a.createdAt!.compareTo(b.createdAt!));
            controller.add(List.from(messages));
          }
        }

        if (oldData.isNotEmpty) {
          final deletedId = oldData['message_id'];
          messages.removeWhere((m) => m.messageId == deletedId);
          controller.add(List.from(messages));
        }
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
              final oldData = payload.oldRecord;

              final newChat = ChatModel.fromJson(newData).toEntity();
              final index = chats.indexWhere((c) => c.chatId == newChat.chatId);
              if (index != -1) {
                chats[index] = newChat;
              } else {
                chats.add(newChat);
              }

              chats.sort((a, b) => b.createdAt!.compareTo(a.createdAt!));
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
    String recentTextMessage = "";

    switch (message.messageType) {
      case MessageTypeConst.photoMessage:
        recentTextMessage = 'Photo';
        break;
      case MessageTypeConst.videoMessage:
        recentTextMessage = ' Video';
        break;
      case MessageTypeConst.audioMessage:
        recentTextMessage = ' Audio';
        break;
      case MessageTypeConst.gifMessage:
        recentTextMessage = 'GIF';
        break;
      default:
        recentTextMessage = message.message!;
    }

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
