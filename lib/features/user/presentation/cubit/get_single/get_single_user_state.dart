import 'package:chat_application/features/user/domain/entities/user_entity.dart';
import 'package:equatable/equatable.dart';

abstract class GetSingleUserState extends Equatable {
  const GetSingleUserState();
}

class GetSingleUserInitial extends GetSingleUserState {
  @override
  List<Object> get props => [];
}

class GetSingleUserLoading extends GetSingleUserState {
  @override
  List<Object> get props => [];
}

class GetSingleUserLoaded extends GetSingleUserState {
  final UserEntity singleUser;

  const GetSingleUserLoaded({required this.singleUser});
  @override
  List<Object> get props => [singleUser];
}

class GetSingleUserFailure extends GetSingleUserState {
  @override
  List<Object> get props => [];
}
