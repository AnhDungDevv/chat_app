import 'package:chat_application/features/chat/domain/entities/message_entity.dart';
import 'package:chat_application/features/chat/domain/repository/chat_reponsitory.dart';

class DeleteMessageUsecase {
  final ChatReponsitory reponsitory;
  DeleteMessageUsecase({required this.reponsitory});
  Future<void> call(MessageEntity message) async {
    return await reponsitory.deleteMessage(message);
  }
}
