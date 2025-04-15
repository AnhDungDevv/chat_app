import 'package:chat_application/features/app/constants/page_const.dart';
import 'package:chat_application/features/app/global/widgets/prodile_widget.dart';
import 'package:chat_application/features/app/theme/style.s.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: 20,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, PageConst.singleChatPage);
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
              title: const Text("username"),
              subtitle: const Text(
                "last message",
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: Text(
                DateFormat.jm().format(DateTime.now()),
                style: const TextStyle(color: greyColor, fontSize: 13),
              ),
            ),
          );
        },
      ),
    );
  }
}
