import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:chat_application/features/call/domain/usecases/get_my_call_history_usecase.dart';
import 'package:chat_application/features/call/presentation/cubit/my_call_history/my_call_history_state.dart';

class MyCallHistoryCubit extends Cubit<MyCallHistoryState> {
  final GetMyCallHistoryUseCase getMyCallHistoryUseCase;
  MyCallHistoryCubit({required this.getMyCallHistoryUseCase})
    : super(MyCallHistoryInitial());

  Future<void> getMyCallHistory({required String id}) async {
    emit(MyCallHistoryLoading());
    try {
      final streamResponse = getMyCallHistoryUseCase.call(id);
      streamResponse.listen((myCallHistory) {
        emit(MyCallHistoryLoaded(myCallHistory: myCallHistory));
      });
    } on SocketException {
      emit(MyCallHistoryFailure());
    } catch (_) {
      emit(MyCallHistoryFailure());
    }
  }
}
