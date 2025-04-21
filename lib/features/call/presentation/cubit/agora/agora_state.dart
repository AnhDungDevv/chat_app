abstract class AgoraState {}

class AgoraInitial extends AgoraState {}

class AgoraInitializing extends AgoraState {}

class AgoraJoined extends AgoraState {}

class AgoraRemoteJoined extends AgoraState {
  final int uid;
  AgoraRemoteJoined(this.uid);
}

class AgoraRemoteLeft extends AgoraState {}

class AgoraLeft extends AgoraState {}
