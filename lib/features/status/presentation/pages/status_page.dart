import 'package:chat_application/features/app/constants/page_const.dart';
import 'package:chat_application/features/app/global/date/date_format.dart';
import 'package:chat_application/features/app/global/widgets/prodile_widget.dart';
import 'package:chat_application/features/app/theme/style.s.dart';
import 'package:flutter/material.dart';

class StatusPage extends StatefulWidget {
  const StatusPage({super.key});

  @override
  State<StatusPage> createState() => _StatusPageState();
}

class _StatusPageState extends State<StatusPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              children: [
                Stack(
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 10,
                      ),
                      width: 60,
                      height: 60,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: profileWidget(),
                      ),
                    ),
                    Positioned(
                      right: 10,
                      bottom: 8,
                      child: Container(
                        width: 25,
                        height: 25,
                        decoration: BoxDecoration(
                          color: tabColor,
                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(width: 2, color: backgroundColor),
                        ),
                        child: const Center(child: Icon(Icons.add, size: 20)),
                      ),
                    ),
                  ],
                ),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("My Status", style: TextStyle(fontSize: 16)),
                      SizedBox(height: 2),
                      Text(
                        "tab to add your status widget",
                        style: TextStyle(color: greyColor),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, PageConst.myStatusPage);
                  },
                  child: Icon(
                    Icons.more_horiz,
                    color: greyColor.withAlpha((255 * 0.5).toInt()),
                  ),
                ),
                const SizedBox(width: 10),
              ],
            ),
            Text(
              "Recents update",
              style: TextStyle(
                fontSize: 13,
                color: greyColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            ListView.builder(
              itemCount: 20,
              shrinkWrap: true,
              physics: const ScrollPhysics(),
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Container(
                    margin: const EdgeInsets.all(3),
                    width: 55,
                    height: 55,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(35),
                      child: profileWidget(),
                    ),
                  ),
                  title: const Text(
                    "user name",
                    style: TextStyle(fontSize: 16),
                  ),
                  subtitle: Text(formatDateTime(DateTime.now())),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
