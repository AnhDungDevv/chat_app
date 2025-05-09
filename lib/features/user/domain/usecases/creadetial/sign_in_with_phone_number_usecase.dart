import 'package:chat_application/features/user/domain/repository/user_repository.dart';

class SignInWithPhoneNumberUseCase {
  final UserRepository repository;

  SignInWithPhoneNumberUseCase({required this.repository});

  Future<bool> call(String smsPinCode) async {
    return repository.signInWithPhoneNumber(smsPinCode);
  }
}
