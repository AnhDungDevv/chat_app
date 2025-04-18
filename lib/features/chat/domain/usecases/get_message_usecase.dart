import 'package:chat_application/features/chat/domain/entities/message_entity.dart';
import 'package:chat_application/features/chat/domain/repository/chat_reponsitory.dart';

class GetMessageUsecase {
  final ChatReponsitory reponsitory;
  GetMessageUsecase({required this.reponsitory});
  Stream<List<MessageEntity>> call(MessageEntity message) {
    return reponsitory.getMessages(message);
  }
}
