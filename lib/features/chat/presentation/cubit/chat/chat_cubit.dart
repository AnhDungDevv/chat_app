import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:chat_application/features/chat/domain/entities/chat_entity.dart';
import 'package:chat_application/features/chat/domain/usecases/delete_my_chat_usecase.dart';
import 'package:chat_application/features/chat/domain/usecases/get_my_chat_usecase.dart';
import 'package:chat_application/features/chat/presentation/cubit/chat/chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  final GetMyChatUsecase getMyChatUsecase;
  final DeleteMyChatUsecase deleteMyChatUsecase;

  ChatCubit({required this.getMyChatUsecase, required this.deleteMyChatUsecase})
    : super(ChatInitial());

  Future<void> getMyChats({required ChatEntity chat}) async {
    try {
      emit(ChatLoading());
      getMyChatUsecase(chat).listen((chats) {
        emit(ChatLoaded(chats: chats));
      }, onError: (e) => emit(ChatFailure(e.toString())));
    } on SocketException {
      emit(ChatFailure('Something went wrong'));
    } catch (e) {
      print("eror : ----- $e");
      emit(ChatFailure('Something went wrong'));
    }
  }

  Future<void> deleteChat({required ChatEntity chat}) async {
    try {
      await deleteMyChatUsecase(chat);
    } on SocketException {
      emit(ChatFailure('Something went delete chat'));
    } catch (e) {
      emit(ChatFailure('Something went delete chat'));
    }
  }
}
