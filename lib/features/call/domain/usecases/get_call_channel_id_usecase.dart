import 'package:chat_application/features/call/domain/repository/call_repository.dart';

class GetCallChannelIdUseCase {
  final CallRepository repository;

  const GetCallChannelIdUseCase({required this.repository});

  Future<String> call(String id) async {
    return await repository.getCallChannelId(id);
  }
}
