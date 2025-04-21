import 'package:chat_application/features/app/theme/style.s.dart';
import 'package:flutter/material.dart';

void deleteStatusUpdate(
  BuildContext context, {
  required VoidCallback onConfirm,
}) {
  showDialog(
    context: context,
    builder:
        (_) => AlertDialog(
          backgroundColor: backgroundColor,
          title: const Text("Delete 1 status update"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel", style: TextStyle(color: tabColor)),
            ),
            TextButton(
              onPressed: onConfirm,
              child: const Text("Delete", style: TextStyle(color: tabColor)),
            ),
          ],
        ),
  );
}
