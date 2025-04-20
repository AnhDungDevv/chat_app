import 'dart:io';
import 'package:bloc/bloc.dart';
import 'dart:developer';

import 'package:chat_application/features/status/domain/usecases/get_my_status_usecase.dart';
import 'package:chat_application/features/status/presentation/cubit/get_my_status/get_my_status_state.dart';

class GetMyStatusCubit extends Cubit<GetMyStatusState> {
  final GetMyStatusUseCase getMyStatusUseCase;
  GetMyStatusCubit({required this.getMyStatusUseCase})
    : super(GetMyStatusInitial());

  Future<void> getMyStatus({required String userId}) async {
    try {
      emit(GetMyStatusLoading());
      final streamResponse = getMyStatusUseCase(userId);
      streamResponse.listen((statuses) {
        log("status ----$statuses");
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
