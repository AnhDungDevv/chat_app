import 'package:agora_uikit/agora_uikit.dart';
import 'package:chat_application/features/app/constants/agora_config_const.dart';
import 'package:chat_application/features/call/presentation/cubit/agora/agora_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AgoraCubit extends Cubit<AgoraState> {
  static final AgoraCubit _instance = AgoraCubit._internal();

  factory AgoraCubit() => _instance;
  AgoraClient? _client;
  AgoraCubit._internal() : super(AgoraInitial());

  Future<void> initialize({String? tokenUrl, String? channelName}) async {
    if (_client == null) {
      _client = AgoraClient(
        agoraConnectionData: AgoraConnectionData(
          appId: AgoraConfig.agoraAppId,
          channelName: channelName!,
          tokenUrl: tokenUrl,
        ),
      );
      await _client!.initialize();
    }
  }

  Future<void> leaveChannel() async {
    if (_client != null) {
      await _client!.engine.leaveChannel();
      await _client!.engine.release();
      _client = null;
    }
  }

  AgoraClient? get getAgoraClient => _client;
}
