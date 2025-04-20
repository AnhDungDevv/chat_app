import 'package:chat_application/features/status/domain/entities/status_enity.dart';
import 'package:chat_application/features/status/domain/repository/status_repository.dart';

class CreateStatusUsecase {
  final StatusRepository repository;
  const CreateStatusUsecase({required this.repository});

  Future<void> call(StatusEntity status) async {
    return await repository.createStatus(status);
  }
}
