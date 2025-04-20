import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:chat_application/features/status/domain/usecases/get_my_status_usecase.dart';
import 'package:chat_application/features/status/presentation/cubit/get_my_status/get_my_status_state.dart';

class GetMyStatusCubit extends Cubit<GetMyStatusState> {
  final GetMyStatusUseCase getMyStatusUseCase;
  GetMyStatusCubit({required this.getMyStatusUseCase})
    : super(GetMyStatusInitial());

  Future<void> getMyStatus({required String uid}) async {
    try {
      emit(GetMyStatusLoading());
      final streamResponse = getMyStatusUseCase.call(uid);
      streamResponse.listen((statuses) {
        print("Mystatuses = $statuses");
        if (statuses.isEmpty) {
          emit(const GetMyStatusLoaded(myStatus: null));
        } else {
          emit(GetMyStatusLoaded(myStatus: statuses.first));
        }
      });
    } on SocketException {
      emit(GetMyStatusFailure());
    } catch (_) {
      emit(GetMyStatusFailure());
    }
  }
}
