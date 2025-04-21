import 'package:chat_application/features/call/domain/entities/call_entity.dart';
import 'package:chat_application/features/call/domain/repository/call_repository.dart';

class EndCallUseCase {
  final CallRepository repository;

  const EndCallUseCase({required this.repository});

  Future<void> call(CallEntity call) async {
    return await repository.endCall(call);
  }
}
