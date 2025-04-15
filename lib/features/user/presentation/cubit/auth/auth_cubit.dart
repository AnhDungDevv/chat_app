import 'package:chat_application/features/user/domain/usecases/creadetial/get_current_uid_usecase.dart';
import 'package:chat_application/features/user/domain/usecases/creadetial/is_sign_in_usecase.dart';
import 'package:chat_application/features/user/domain/usecases/creadetial/sign_out_usecase.dart';
import 'package:chat_application/features/user/presentation/cubit/auth/auth_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthCubit extends Cubit<AuthState> {
  final GetCurrentUidUsecase getCurrentUidUsecase;
  final IsSignInUsecase isSignInUsecase;
  final SignOutUseCase signOutUseCase;
  AuthCubit({
    required this.getCurrentUidUsecase,
    required this.isSignInUsecase,
    required this.signOutUseCase,
  }) : super(AuthInitial());

  Future<void> appStarted() async {
    try {
      bool isSignIn = await isSignInUsecase();
      if (isSignIn) {
        final uid = await getCurrentUidUsecase();
        emit(Authenticated(uid: uid));
      } else {
        emit(UnAuthenticated());
      }
    } catch (e) {
      emit(UnAuthenticated());
    }
  }

  Future<void> loggeddIn() async {
    try {
      final uid = await getCurrentUidUsecase();
      emit(Authenticated(uid: uid));
    } catch (e) {
      emit(UnAuthenticated());
    }
  }

  Future<void> loggedOut() async {
    try {
      await signOutUseCase();
      emit(UnAuthenticated());
    } catch (e) {
      emit(UnAuthenticated());
    }
  }
}
