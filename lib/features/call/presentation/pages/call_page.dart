import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:chat_application/features/app/theme/style.s.dart';
import 'package:chat_application/features/call/domain/entities/call_entity.dart';
import 'package:chat_application/features/call/presentation/cubit/agora/agora_cubit.dart';
import 'package:chat_application/features/call/presentation/cubit/agora/agora_state.dart';
import 'package:chat_application/features/call/presentation/cubit/call/call_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

class CallPage extends StatefulWidget {
  final CallEntity callEntity;
  const CallPage({super.key, required this.callEntity});

  @override
  State<CallPage> createState() => _CallPageState();
}

class _CallPageState extends State<CallPage> {
  late final AgoraCubit agoraCubit;

  @override
  void initState() {
    super.initState();
    agoraCubit = BlocProvider.of<AgoraCubit>(context);

    final callId = widget.callEntity.callId!;
    final tokenUrl = "http://192.168.1.6:3000/get_token?channelName=$callId";

    fetchToken(tokenUrl).then((token) {
      agoraCubit.initialize(token: token, channelName: callId);
    });
  }

  Future<String> fetchToken(String url) async {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final token = RegExp(
        r'"token"\s*:\s*"([^"]+)"',
      ).firstMatch(response.body)?.group(1);
      return token ?? '';
    } else {
      throw Exception('Failed to load token');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<AgoraCubit, AgoraState>(
        builder: (context, state) {
          if (state is AgoraInitializing || state is AgoraInitial) {
            return const Center(
              child: CircularProgressIndicator(color: tabColor),
            );
          }

          return SafeArea(
            child: Stack(
              children: [
                // Remote video
                if (agoraCubit.remoteUid != null)
                  AgoraVideoView(
                    controller: VideoViewController.remote(
                      rtcEngine: agoraCubit.engine,
                      canvas: VideoCanvas(uid: agoraCubit.remoteUid),
                      connection: RtcConnection(
                        channelId: widget.callEntity.callId!,
                      ),
                    ),
                  )
                else
                  const Center(child: Text("Waiting for user to join...")),

                // Local preview
                Positioned(
                  top: 20,
                  right: 20,
                  width: 120,
                  height: 160,
                  child: AgoraVideoView(
                    controller: VideoViewController(
                      rtcEngine: agoraCubit.engine,
                      canvas: const VideoCanvas(uid: 0),
                    ),
                  ),
                ),

                // End call button
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 24.0),
                    child: IconButton(
                      iconSize: 56,
                      icon: const Icon(Icons.call_end, color: Colors.red),
                      onPressed: () async {
                        await agoraCubit.leaveChannel();
                        BlocProvider.of<CallCubit>(context).endCall(
                          CallEntity(
                            callId: widget.callEntity.callId,
                            receiverId: widget.callEntity.receiverId,
                          ),
                        );
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
