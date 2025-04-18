import 'package:chat_application/features/chat/domain/entities/chat_entity.dart';
import 'package:equatable/equatable.dart';

abstract class ChatState extends Equatable {
  const ChatState();
}

class ChatInitial extends ChatState {
  @override
  List<Object?> get props => [];
}

class ChatLoading extends ChatState {
  @override
  List<Object?> get props => [];
}

class ChatLoaded extends ChatState {
  final List<ChatEntity> chats;
  const ChatLoaded({required this.chats});
  @override
  List<Object?> get props => chats;
}

class ChatFailure extends ChatState {
  final String? error;
  const ChatFailure(this.error);
  @override
  List<Object?> get props => [error];
}
