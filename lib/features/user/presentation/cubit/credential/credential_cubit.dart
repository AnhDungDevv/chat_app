import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:chat_application/features/user/domain/entities/user_entity.dart';
import 'package:chat_application/features/user/domain/usecases/creadetial/sign_in_with_phone_number_usecase.dart';
import 'package:chat_application/features/user/domain/usecases/creadetial/verify_phone_number_usecsae.dart';
import 'package:chat_application/features/user/domain/usecases/user/create_user_usecase.dart';
import 'package:chat_application/features/user/presentation/cubit/credential/credential_state.dart';

class CredentialCubit extends Cubit<CredentialState> {
  final SignInWithPhoneNumberUseCase signInWithPhoneNumberUseCase;
  final VerifyPhoneNumberUseCase verifyPhoneNumberUseCase;
  final CreateUserUseCase createUserUseCase;
  CredentialCubit({
    required this.signInWithPhoneNumberUseCase,
    required this.verifyPhoneNumberUseCase,
    required this.createUserUseCase,
  }) : super(CredentialInitial());

  Future<void> submitVerifyPhone({required String phoneNumber}) async {
    try {
      await verifyPhoneNumberUseCase(phoneNumber);

      emit(CredentialPhoneAuthSmsReceived());
    } on SocketException catch (_) {
      emit(CredentialFailure());
    } catch (e) {
      emit(CredentialFailure());
    }
  }

  Future<void> submitSms({required String sms}) async {
    try {
      await signInWithPhoneNumberUseCase(sms);
      emit(CredentialPhoneAuthProfileInfo());
    } on SocketException catch (e) {
      print("errror : $e");

      emit(CredentialFailure());
    } catch (e) {
      print("errror : $e");

      emit(CredentialFailure());
    }
  }

  Future<void> submitProfileInfo({required UserEntity user}) async {
    try {
      await createUserUseCase(user);
      emit(CredentialSuccess());
    } on SocketException catch (e) {
      print("errror : $e");

      emit(CredentialFailure());
    } catch (e) {
      print("errror : $e");

      emit(CredentialFailure());
    }
  }
}
