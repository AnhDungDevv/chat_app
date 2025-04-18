import 'package:chat_application/features/user/domain/entities/user_entity.dart';
import 'package:chat_application/features/user/domain/usecases/user/get_all_users_usecase.dart';
import 'package:chat_application/features/user/domain/usecases/user/update_user_usecase.dart';
import 'package:chat_application/features/user/presentation/cubit/user/user_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserCubit extends Cubit<UserState> {
  final UpdateUserUseCase updateUserUseCase;
  final GetAllUsersUseCase getAllUsersUseCase;
  UserCubit({required this.updateUserUseCase, required this.getAllUsersUseCase})
    : super(UserInitial());
  Future<void> getAllUsers() async {
    emit(UserLoading());
    final streamResponse = getAllUsersUseCase();
    streamResponse.listen((users) {
      emit(UserLoaded(users: users));
    });
  }

  Future<void> updateUser({required UserEntity user}) async {
    try {
      await updateUserUseCase(user);
    } catch (e) {
      emit(UserFailure());
    }
  }
}
