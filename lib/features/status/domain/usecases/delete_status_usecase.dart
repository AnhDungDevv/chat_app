import 'package:chat_application/features/status/domain/entities/status_enity.dart';
import 'package:chat_application/features/status/domain/repository/status_repository.dart';

class DeleteStatusUsecase {
  final StatusRepository repository;
  const DeleteStatusUsecase({required this.repository});
  Future<void> call(StatusEntity status) async {
    return await repository.deleteStatus(status);
  }
}
