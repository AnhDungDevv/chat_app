import 'package:chat_application/features/user/domain/entities/contact-entity.dart';
import 'package:chat_application/features/user/domain/repository/user_repository.dart';

class GetDeviceNumberUseCase {
  final UserRepository repository;

  GetDeviceNumberUseCase({required this.repository});

  Future<List<ContactEntity>> call() async {
    return repository.getDeviceNumber();
  }
}
