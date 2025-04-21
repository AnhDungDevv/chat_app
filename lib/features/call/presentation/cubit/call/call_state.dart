import 'package:chat_application/features/call/domain/entities/call_entity.dart';
import 'package:equatable/equatable.dart';

abstract class CallState extends Equatable {
  const CallState();
}

class CallInitial extends CallState {
  @override
  List<Object> get props => [];
}

class IsCalling extends CallState {
  @override
  List<Object> get props => [];
}

class CallDialed extends CallState {
  final CallEntity userCall;

  const CallDialed({required this.userCall});
  @override
  List<Object> get props => [userCall];
}

class CallFailed extends CallState {
  @override
  List<Object> get props => [];
}
