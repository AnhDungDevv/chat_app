import 'package:chat_application/features/user/domain/entities/user_entity.dart';
import 'package:equatable/equatable.dart';

abstract class UserState extends Equatable {
  const UserState();
}

class UserInitial extends UserState {
  @override
  List<Object> get props => [];
}

class UserLoading extends UserState {
  @override
  List<Object> get props => [];
}

class UserLoaded extends UserState {
  final List<UserEntity> users;

  const UserLoaded({required this.users});
  @override
  List<Object> get props => [users];
}

class UserFailure extends UserState {
  @override
  List<Object> get props => [];
}
