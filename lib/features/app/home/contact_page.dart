import 'package:chat_application/features/app/global/widgets/prodile_widget.dart';
import 'package:flutter/material.dart';

class ContactPage extends StatelessWidget {
  const ContactPage({super.key});

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
          );
        },
      ),
    );
  }
}
