import 'package:chat_application/features/app/global/date/date_format.dart';
import 'package:chat_application/features/app/global/widgets/prodile_widget.dart';
import 'package:chat_application/features/app/theme/style.s.dart';
import 'package:flutter/material.dart';

class CallHistoryPage extends StatefulWidget {
  const CallHistoryPage({super.key});

  @override
  State<CallHistoryPage> createState() => _CallHistoryPageState();
}

class _CallHistoryPageState extends State<CallHistoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 15),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Text(
                "Resent",
                style: TextStyle(
                  fontSize: 15,
                  color: greyColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            SizedBox(height: 5),
            ListView.builder(
              shrinkWrap: true,
              physics: const ScrollPhysics(),
              itemCount: 10,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Container(
                    width: 55,
                    height: 55,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: profileWidget(),
                    ),
                  ),
                  title: const Text(
                    "Username ",
                    style: TextStyle(fontSize: 16),
                  ),
                  subtitle: Row(
                    children: [
                      const Icon(
                        Icons.call_made,
                        color: Colors.green,
                        size: 19,
                      ),
                      const SizedBox(width: 10),
                      Text(formatDateTime(DateTime.now())),
                    ],
                  ),
                  trailing: const Icon(Icons.call, color: tabColor),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
