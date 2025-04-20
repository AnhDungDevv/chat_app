import 'dart:io';
import 'package:bloc/bloc.dart';
import 'dart:developer';

import 'package:chat_application/features/status/domain/entities/status_enity.dart';
import 'package:chat_application/features/status/domain/usecases/create_status_usecase.dart';
import 'package:chat_application/features/status/domain/usecases/delete_status_usecase.dart';
import 'package:chat_application/features/status/domain/usecases/get_statuses_usecase.dart';
import 'package:chat_application/features/status/domain/usecases/seen_status_update_usecase.dart';
import 'package:chat_application/features/status/domain/usecases/update_only_image_status_usecase.dart';
import 'package:chat_application/features/status/domain/usecases/update_status_usecase.dart';
import 'package:chat_application/features/status/presentation/cubit/status/status_state.dart';

class StatusCubit extends Cubit<StatusState> {
  final CreateStatusUsecase createStatusUseCase;
  final DeleteStatusUsecase deleteStatusUseCase;
  final UpdateStatusUseCase updateStatusUseCase;
  final GetStatusesUseCase getStatusesUseCase;
  final UpdateOnlyImageStatusUseCase updateOnlyImageStatusUseCase;
  final SeenStatusUpdateUseCase seenStatusUpdateUseCase;

  StatusCubit({
    required this.createStatusUseCase,
    required this.deleteStatusUseCase,
    required this.updateOnlyImageStatusUseCase,
    required this.updateStatusUseCase,
    required this.getStatusesUseCase,
    required this.seenStatusUpdateUseCase,
  }) : super(StatusInitial());

  Future<void> getStatuses({required StatusEntity status}) async {
    try {
      emit(StatusLoading());
      final streamResponse = getStatusesUseCase(status);
      streamResponse.listen((statuses) {
        log("status ------ ----- $statuses");
        emit(StatusLoaded(statuses: statuses));
      });
    } on SocketException {
      emit(StatusFailure());
    } catch (_) {
      emit(StatusFailure());
    }
  }

  Future<void> createStatus({required StatusEntity status}) async {
    try {
      await createStatusUseCase(status);
    } on SocketException {
      emit(StatusFailure());
    } catch (_) {
      emit(StatusFailure());
    }
  }

  Future<void> deleteStatus({required StatusEntity status}) async {
    try {
      await deleteStatusUseCase(status);
    } on SocketException {
      emit(StatusFailure());
    } catch (_) {
      emit(StatusFailure());
    }
  }

  Future<void> updateStatus({required StatusEntity status}) async {
    try {
      await updateStatusUseCase(status);
    } on SocketException {
      emit(StatusFailure());
    } catch (_) {
      emit(StatusFailure());
    }
  }

  Future<void> updateOnlyImageStatus({required StatusEntity status}) async {
    try {
      await updateOnlyImageStatusUseCase(status);
    } on SocketException {
      emit(StatusFailure());
    } catch (_) {
      emit(StatusFailure());
    }
  }

  Future<void> seenStatusUpdate({
    required String statusId,
    required int imageIndex,
    required String userId,
  }) async {
    try {
      await seenStatusUpdateUseCase(statusId, imageIndex, userId);
    } on SocketException {
      emit(StatusFailure());
    } catch (_) {
      emit(StatusFailure());
    }
  }
}
