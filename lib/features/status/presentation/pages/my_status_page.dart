import 'package:flutter/material.dart';
import 'package:get_time_ago/get_time_ago.dart';

import 'package:chat_application/features/app/global/widgets/prodile_widget.dart';

class MyStatusPage extends StatefulWidget {
  const MyStatusPage({super.key});

  @override
  State<MyStatusPage> createState() => _MyStatusPageState();
}

class _MyStatusPageState extends State<MyStatusPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My status")),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 55,
                  height: 55,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: profileWidget(),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Text(
                    GetTimeAgo.parse(
                      DateTime.now().subtract(
                        Duration(seconds: DateTime.now().second),
                      ),
                    ),
                  ),
                ),
                PopupMenuButton(
                  itemBuilder:
                      (context) => [
                        PopupMenuItem(
                          value: "Delete",
                          child: GestureDetector(
                            onTap: () {},
                            child: const Text("Delete"),
                          ),
                        ),
                      ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
