import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_time_ago/get_time_ago.dart';

import 'package:chat_application/features/app/home/home_page.dart';
import 'package:chat_application/features/app/theme/style.s.dart';
import 'package:chat_application/features/status/domain/entities/status_enity.dart';
import 'package:chat_application/features/status/presentation/cubit/status/status_cubit.dart';
import 'package:chat_application/features/status/presentation/widgets/delete_status_update_alert.dart';
import 'package:chat_application/features/app/global/widgets/prodile_widget.dart';

class MyStatusPage extends StatefulWidget {
  final StatusEntity status;

  const MyStatusPage({super.key, required this.status});

  @override
  State<MyStatusPage> createState() => _MyStatusPageState();
}

class _MyStatusPageState extends State<MyStatusPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Status")),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 12),
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
                    child: profileWidget(imageUrl: widget.status.imageUrl),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Text(
                    GetTimeAgo.parse(
                      widget.status.createdAt!.subtract(
                        Duration(seconds: DateTime.now().second),
                      ),
                    ),
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),

                PopupMenuButton<String>(
                  icon: Icon(Icons.more_vert, color: greyColor.withOpacity(.5)),
                  color: appBarColor,
                  iconSize: 28,
                  onSelected: (value) {
                    if (value == "delete") {
                      deleteStatusUpdate(
                        context,
                        onConfirm: () {
                          Navigator.pop(context);
                          BlocProvider.of<StatusCubit>(context).deleteStatus(
                            status: StatusEntity(
                              statusId: widget.status.statusId,
                            ),
                          );

                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (_) => HomePage(
                                    userId: widget.status.userId!,
                                    index: 1,
                                  ),
                            ),
                          );
                        },
                      );
                    }
                  },
                  itemBuilder:
                      (context) => <PopupMenuEntry<String>>[
                        const PopupMenuItem<String>(
                          value: "delete",
                          child: Text("Delete"),
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
