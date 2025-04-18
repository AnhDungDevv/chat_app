import 'package:chat_application/features/chat/data/source/remote/chat_remote_data_source.dart';
import 'package:chat_application/features/chat/domain/entities/chat_entity.dart';
import 'package:chat_application/features/chat/domain/entities/message_entity.dart';
import 'package:chat_application/features/chat/domain/repository/chat_reponsitory.dart';

class ChatReponsitoryImpl implements ChatReponsitory {
  final ChatRemoteDataSource chatRemoteDataSource;
  ChatReponsitoryImpl({required this.chatRemoteDataSource});
  @override
  Future<void> deleteChat(ChatEntity chat) async =>
      await chatRemoteDataSource.deleteChat(chat);

  @override
  Future<void> deleteMessage(MessageEntity message) async =>
      await chatRemoteDataSource.deleteMessage(message);

  @override
  Stream<List<MessageEntity>> getMessages(MessageEntity message) =>
      chatRemoteDataSource.getMessages(message);

  @override
  Stream<List<ChatEntity>> getMyChat(ChatEntity chat) =>
      chatRemoteDataSource.getMyChat(chat);

  @override
  Future<void> sendMessage(ChatEntity chat, MessageEntity message) async =>
      await chatRemoteDataSource.sendMessage(chat, message);
}
