import 'package:chat_application/features/user/domain/usecases/user/get_single_user_usecase.dart';
import 'package:chat_application/features/user/presentation/cubit/get_single/get_single_user_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GetSingleUserCubit extends Cubit<GetSingleUserState> {
  final GetSingleUserUseCase getSingleUserUseCase;

  GetSingleUserCubit({required this.getSingleUserUseCase})
    : super(GetSingleUserInitial());

  Future<void> getSingleUser({required String userId}) async {
    emit(GetSingleUserLoading());
    final streamResponse = getSingleUserUseCase.call(userId);
    streamResponse.listen((users) {
      emit(GetSingleUserLoaded(singleUser: users.first));
    });
  }
}
