import 'package:chat_application/features/app/constants/page_const.dart';
import 'package:chat_application/features/app/global/widgets/prodile_widget.dart';
import 'package:chat_application/features/call/domain/entities/call_entity.dart';
import 'package:chat_application/features/call/domain/usecases/get_call_channel_id_usecase.dart';
import 'package:chat_application/features/call/presentation/cubit/agora/agora_cubit.dart';
import 'package:chat_application/features/call/presentation/cubit/call/call_cubit.dart';
import 'package:chat_application/features/call/presentation/cubit/call/call_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chat_application/main_injection.dart' as di;

class PickUpCallPage extends StatefulWidget {
  final String? id;
  final Widget child;

  const PickUpCallPage({super.key, required this.child, this.id});

  @override
  State<PickUpCallPage> createState() => _PickUpCallPageState();
}

class _PickUpCallPageState extends State<PickUpCallPage> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<CallCubit>(context).getUserCalling(widget.id!);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CallCubit, CallState>(
      builder: (context, state) {
        if (state is CallDialed) {
          final call = state.userCall;
          if (call.isCallDialed == false) {
            return Scaffold(
              body: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Incoming call",
                    style: TextStyle(fontSize: 30, color: Colors.white),
                  ),
                  const SizedBox(height: 40),
                  profileWidget(imageUrl: call.receiverProfileUrl),
                  const SizedBox(height: 40),
                  Text(
                    "${call.receiverName}",
                    style: const TextStyle(
                      fontSize: 25,
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 50),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () async {
                          BlocProvider.of<AgoraCubit>(
                            context,
                          ).leaveChannel().then((value) {
                            BlocProvider.of<CallCubit>(context)
                                .updateCallHistoryStatus(
                                  CallEntity(
                                    callId: call.callId,
                                    callerId: call.callerId,
                                    receiverId: call.receiverId,
                                    isCallDialed: false,
                                    isMissed: true,
                                  ),
                                )
                                .then((value) {
                                  BlocProvider.of<CallCubit>(context).endCall(
                                    CallEntity(
                                      callerId: call.callerId,
                                      receiverId: call.receiverId,
                                    ),
                                  );
                                });
                          });
                        },
                        icon: const Icon(
                          Icons.call_end,
                          color: Colors.redAccent,
                        ),
                      ),
                      const SizedBox(width: 25),
                      IconButton(
                        onPressed: () {
                          di
                              .sl<GetCallChannelIdUseCase>()(call.receiverId!)
                              .then((callChannelId) {
                                Navigator.pushNamed(
                                  context,
                                  PageConst.callPage,
                                  arguments: CallEntity(
                                    callId: callChannelId,
                                    callerId: call.callerId!,
                                    receiverId: call.receiverId!,
                                  ),
                                );
                              });
                        },
                        icon: const Icon(Icons.call, color: Colors.green),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }
          return widget.child;
        }
        return widget.child;
      },
    );
  }
}
