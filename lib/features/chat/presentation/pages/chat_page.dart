import 'package:chat_application/features/app/constants/page_const.dart';
import 'package:chat_application/features/app/global/widgets/prodile_widget.dart';
import 'package:chat_application/features/app/theme/style.s.dart';
import 'package:chat_application/features/chat/domain/entities/chat_entity.dart';
import 'package:chat_application/features/chat/domain/entities/message_entity.dart';
import 'package:chat_application/features/chat/presentation/cubit/chat/chat_cubit.dart';
import 'package:chat_application/features/chat/presentation/cubit/chat/chat_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class ChatPage extends StatefulWidget {
  final String uid;
  const ChatPage({super.key, required this.uid});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  void initState() {
    super.initState();
    context.read<ChatCubit>().getMyChats(
      chat: ChatEntity(senderId: widget.uid),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<ChatCubit, ChatState>(
        builder: (context, state) {
          if (state is ChatLoaded) {
            final chats = state.chats;

            if (chats.isEmpty) {
              return Center(child: Text('No conversations Yet'));
            }
            return ListView.builder(
              itemCount: chats.length,
              itemBuilder: (context, index) {
                final chat = chats[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      PageConst.singleChatPage,
                      arguments: MessageEntity(
                        senderId: chat.senderId,
                        recipientId: chat.recipientId,
                        senderName: chat.senderName,
                        recipientName: chat.recipientName,
                        senderProfile: chat.senderProfile,
                        recipientProfile: chat.recipientProfile,
                      ),
                    );
                  },
                  child: ListTile(
                    leading: SizedBox(
                      width: 50,
                      height: 50,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(25),
                        child: profileWidget(),
                      ),
                    ),
                    title: Text("${chat.recipientName}"),
                    subtitle: Text(
                      "${chat.recentTextMessage}",
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: Text(
                      DateFormat.jm().format(chat.createdAt!),
                      style: const TextStyle(color: greyColor, fontSize: 13),
                    ),
                  ),
                );
              },
            );
          }
          return const Center(
            child: CircularProgressIndicator(color: tabColor),
          );
        },
      ),
    );
  }
}
