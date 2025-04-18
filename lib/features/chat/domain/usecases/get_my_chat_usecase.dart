import 'package:chat_application/features/chat/domain/entities/chat_entity.dart';
import 'package:chat_application/features/chat/domain/repository/chat_reponsitory.dart';

class GetMyChatUsecase {
  final ChatReponsitory reponsitory;
  GetMyChatUsecase({required this.reponsitory});
  Stream<List<ChatEntity>> call(ChatEntity chat) {
    return reponsitory.getMyChat(chat);
  }
}
