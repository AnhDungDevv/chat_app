import 'package:chat_application/features/app/global/widgets/prodile_widget.dart';
import 'package:chat_application/features/app/theme/style.s.dart';
import 'package:flutter/material.dart';

class CallContactsPage extends StatefulWidget {
  const CallContactsPage({super.key});

  @override
  State<CallContactsPage> createState() => _CallContactsPageState();
}

class _CallContactsPageState extends State<CallContactsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Select Contatc")),
      body: ListView.builder(
        itemCount: 20,
        itemBuilder: (context, index) {
          return ListTile(
            leading: SizedBox(
              width: 50,
              height: 50,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: profileWidget(),
              ),
            ),
            title: const Text("username"),
            subtitle: const Text("Hey there! I'm using chat app"),
            trailing: const Wrap(
              children: [
                Icon(Icons.call, color: tabColor, size: 22),
                SizedBox(width: 15),
                Icon(Icons.videocam_rounded, color: tabColor, size: 22),
              ],
            ),
          );
        },
      ),
    );
  }
}
