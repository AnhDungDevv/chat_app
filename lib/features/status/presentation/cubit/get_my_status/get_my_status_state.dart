import 'package:chat_application/features/status/domain/entities/status_enity.dart';
import 'package:equatable/equatable.dart';

abstract class GetMyStatusState extends Equatable {
  const GetMyStatusState();
}

class GetMyStatusInitial extends GetMyStatusState {
  @override
  List<Object> get props => [];
}

class GetMyStatusLoading extends GetMyStatusState {
  @override
  List<Object> get props => [];
}

class GetMyStatusLoaded extends GetMyStatusState {
  final StatusEntity? myStatus;

  const GetMyStatusLoaded({this.myStatus});
  @override
  List<Object?> get props => [myStatus];
}

class GetMyStatusFailure extends GetMyStatusState {
  @override
  List<Object> get props => [];
}
