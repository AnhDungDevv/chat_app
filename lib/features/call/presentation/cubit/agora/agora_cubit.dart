import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:chat_application/features/app/constants/agora_config_const.dart';
import 'package:chat_application/features/call/presentation/cubit/agora/agora_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AgoraCubit extends Cubit<AgoraState> {
  static final AgoraCubit _instance = AgoraCubit._internal();
  factory AgoraCubit() => _instance;
  AgoraCubit._internal() : super(AgoraInitial());

  late final RtcEngine _engine;
  int? _remoteUid;

  Future<void> initialize({
    required String token,
    required String channelName,
  }) async {
    emit(AgoraInitializing());

    _engine = createAgoraRtcEngine();
    await _engine.initialize(RtcEngineContext(appId: AgoraConfig.agoraAppId));
    await _engine.enableVideo();

    _engine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int uid) {
          emit(AgoraJoined());
        },
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
          _remoteUid = remoteUid;
          emit(AgoraRemoteJoined(remoteUid));
        },

        onUserOffline: (
          RtcConnection connection,
          int remoteUid,
          UserOfflineReasonType reason,
        ) {
          _remoteUid = null;
          emit(AgoraRemoteLeft());
        },
      ),
    );

    await _engine.joinChannel(
      token: token,
      channelId: channelName,
      uid: 0,
      options: const ChannelMediaOptions(),
    );
  }

  Future<void> leaveChannel() async {
    await _engine.leaveChannel();
    await _engine.release();
    emit(AgoraLeft());
  }

  RtcEngine get engine => _engine;
  int? get remoteUid => _remoteUid;
}
