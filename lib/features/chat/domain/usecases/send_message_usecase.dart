import 'package:chat_application/features/chat/domain/entities/chat_entity.dart';
import 'package:chat_application/features/chat/domain/entities/message_entity.dart';
import 'package:chat_application/features/chat/domain/repository/chat_reponsitory.dart';

class SendMessageUsecase {
  final ChatReponsitory reponsitory;
  SendMessageUsecase({required this.reponsitory});
  Future<void> call(ChatEntity chat, MessageEntity message) async {
    return await reponsitory.sendMessage(chat, message);
  }
}
