import 'package:chat_application/features/chat/domain/entities/chat_entity.dart';
import 'package:chat_application/features/chat/domain/repository/chat_reponsitory.dart';

class DeleteMyChatUsecase {
  final ChatReponsitory reponsitory;
  DeleteMyChatUsecase({required this.reponsitory});
  Future<void> call(ChatEntity chat) async {
    return await reponsitory.deleteChat(chat);
  }
}
