import 'dart:io';

import 'package:chat_application/features/chat/domain/entities/chat_entity.dart';
import 'package:chat_application/features/chat/domain/entities/message_entity.dart';
import 'package:chat_application/features/chat/domain/usecases/delete_message_usecase.dart';
import 'package:chat_application/features/chat/domain/usecases/get_message_usecase.dart';
import 'package:chat_application/features/chat/domain/usecases/send_message_usecase.dart';
import 'package:chat_application/features/chat/presentation/cubit/message/message_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MessageCubit extends Cubit<MessageState> {
  final DeleteMessageUsecase deleteMessageUsecase;
  final SendMessageUsecase sendMessageUsecase;
  final GetMessageUsecase getMessageUsecase;

  MessageCubit({
    required this.deleteMessageUsecase,
    required this.sendMessageUsecase,
    required this.getMessageUsecase,
  }) : super(MessageInitial());

  Future<void> getMessages({required MessageEntity message}) async {
    try {
      emit(MessageLoading());
      getMessageUsecase(message).listen(
        (messages) {
          emit(MessageLoaded(messages: messages));
        },
        onError: (e) {
          emit(MessageFailure());
        },
      );
    } on SocketException {
      emit(MessageFailure());
    } catch (e) {
      emit(MessageFailure());
    }
  }

  Future<void> deleteMessage({required MessageEntity message}) async {
    try {
      await deleteMessageUsecase(message);
    } on SocketException {
      emit(MessageFailure());
    } catch (e) {
      emit(MessageFailure());
    }
  }

  Future<void> sendMessage({
    required ChatEntity chat,
    required MessageEntity message,
  }) async {
    try {
      await sendMessageUsecase(chat,message);
    } on SocketException {
      emit(MessageFailure());
    } catch (e) {
      emit(MessageFailure());
    }
  }
}
