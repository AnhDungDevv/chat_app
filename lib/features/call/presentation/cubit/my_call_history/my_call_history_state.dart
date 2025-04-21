import 'package:chat_application/features/call/domain/entities/call_entity.dart';
import 'package:equatable/equatable.dart';

abstract class MyCallHistoryState extends Equatable {
  const MyCallHistoryState();
}

class MyCallHistoryInitial extends MyCallHistoryState {
  @override
  List<Object> get props => [];
}

class MyCallHistoryLoading extends MyCallHistoryState {
  @override
  List<Object> get props => [];
}

class MyCallHistoryLoaded extends MyCallHistoryState {
  final List<CallEntity> myCallHistory;

  const MyCallHistoryLoaded({required this.myCallHistory});
  @override
  List<Object> get props => [myCallHistory];
}

class MyCallHistoryFailure extends MyCallHistoryState {
  @override
  List<Object> get props => [];
}
