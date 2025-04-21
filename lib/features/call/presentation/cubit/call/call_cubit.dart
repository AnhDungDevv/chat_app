import 'dart:io';

import 'package:chat_application/features/call/domain/entities/call_entity.dart';
import 'package:chat_application/features/call/domain/usecases/end_call_usecase.dart';
import 'package:chat_application/features/call/domain/usecases/get_user_calling_usecase.dart';
import 'package:chat_application/features/call/domain/usecases/make_call_usecase.dart';
import 'package:chat_application/features/call/domain/usecases/save_call_history_usecase.dart';
import 'package:chat_application/features/call/domain/usecases/update_call_history_status_usecase.dart';
import 'package:chat_application/features/call/presentation/cubit/call/call_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CallCubit extends Cubit<CallState> {
  final GetUserCallingUseCase getUserCallingUseCase;
  final MakeCallUseCase makeCallUseCase;
  final EndCallUseCase endCallUseCase;
  final SaveCallHistoryUseCase saveCallHistoryUseCase;
  final UpdateCallHistoryStatusUseCase updateCallHistoryStatusUseCase;
  CallCubit({
    required this.endCallUseCase,
    required this.makeCallUseCase,
    required this.getUserCallingUseCase,
    required this.saveCallHistoryUseCase,
    required this.updateCallHistoryStatusUseCase,
  }) : super(CallInitial());

  Future<void> getUserCalling(String id) async {
    try {
      final streamResponse = getUserCallingUseCase(id);

      streamResponse.listen((userCall) {
        if (userCall.isEmpty) {
          emit(const CallDialed(userCall: CallEntity()));
        } else {
          emit(CallDialed(userCall: userCall.first));
        }
      });
    } on SocketException {
      emit(CallFailed());
    } catch (_) {
      emit(CallFailed());
    }
  }

  Future<void> makeCall(CallEntity call) async {
    emit(IsCalling());
    try {
      await makeCallUseCase.call(call);
    } on SocketException {
      emit(CallFailed());
    } catch (_) {
      emit(CallFailed());
    }
  }

  Future<void> endCall(CallEntity call) async {
    emit(IsCalling());
    try {
      await endCallUseCase.call(call);
    } on SocketException {
      emit(CallFailed());
    } catch (_) {
      emit(CallFailed());
    }
  }

  Future<void> saveCallHistory(CallEntity call) async {
    emit(IsCalling());
    try {
      await saveCallHistoryUseCase.call(call);
    } on SocketException {
      emit(CallFailed());
    } catch (_) {
      emit(CallFailed());
    }
  }

  Future<void> updateCallHistoryStatus(CallEntity call) async {
    emit(IsCalling());
    try {
      await updateCallHistoryStatusUseCase.call(call);
    } on SocketException {
      emit(CallFailed());
    } catch (_) {
      emit(CallFailed());
    }
  }
}
