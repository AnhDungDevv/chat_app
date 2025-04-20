import 'package:chat_application/features/app/theme/style.s.dart';
import 'package:flutter/material.dart';

deleteStatusUpdate(BuildContext context, {required VoidCallback onTap}) {
  Widget cancelButton = TextButton(
    child: const Text("Cancel", style: TextStyle(color: tabColor)),
    onPressed: () {
      Navigator.pop(context);
    },
  );
  Widget deleteButton = TextButton(
    onPressed: onTap,
    child: const Text("Delete", style: TextStyle(color: tabColor)),
  );
  AlertDialog alert = AlertDialog(
    backgroundColor: backgroundColor,
    title: const Text("Delete 1 status update"),
    actions: [cancelButton, deleteButton],
  );
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
