import 'package:chat_application/features/status/domain/entities/status_enity.dart';
import 'package:equatable/equatable.dart';

abstract class StatusState extends Equatable {
  const StatusState();
}

class StatusInitial extends StatusState {
  @override
  List<Object> get props => [];
}

class StatusLoading extends StatusState {
  @override
  List<Object> get props => [];
}

class StatusLoaded extends StatusState {
  final List<StatusEntity> statuses;

  const StatusLoaded({required this.statuses});
  @override
  List<Object> get props => [statuses];
}

class StatusFailure extends StatusState {
  @override
  List<Object> get props => [];
}
