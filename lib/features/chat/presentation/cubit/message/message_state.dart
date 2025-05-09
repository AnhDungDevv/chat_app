import 'package:chat_application/features/chat/domain/entities/message_entity.dart';
import 'package:equatable/equatable.dart';

abstract class MessageState extends Equatable {
  const MessageState();
}

class MessageInitial extends MessageState {
  @override
  List<Object?> get props => [];
}

class MessageLoading extends MessageState {
  @override
  List<Object?> get props => [];
}

class MessageLoaded extends MessageState {
  final List<MessageEntity> messages;
  const MessageLoaded({required this.messages});
  @override
  List<Object?> get props => messages;
}

class MessageFailure extends MessageState {
  @override
  List<Object?> get props => [];
}
