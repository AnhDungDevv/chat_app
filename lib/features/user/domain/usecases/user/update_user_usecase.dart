import 'package:chat_application/features/user/domain/entities/user_entity.dart';
import 'package:chat_application/features/user/domain/repository/user_repository.dart';

class UpdateUserUseCase {
  final UserRepository repository;

  UpdateUserUseCase({required this.repository});

  Future<void> call(UserEntity user) async {
    return repository.updateUser(user);
  }
}
