import 'package:equatable/equatable.dart';

abstract class AgoraState extends Equatable {
  const AgoraState();
}

class AgoraInitial extends AgoraState {
  @override
  List<Object> get props => [];
}
