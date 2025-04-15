import 'package:chat_application/features/app/global/widgets/prodile_widget.dart';
import 'package:chat_application/features/app/theme/style.s.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Settings")),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            child: Row(
              children: [
                SizedBox(
                  width: 65,
                  height: 65,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(32.5),
                    child: profileWidget(),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("username", style: TextStyle(fontSize: 16)),
                      Text(
                        "white true { code() }",
                        style: TextStyle(color: greyColor),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.qr_code_sharp, color: tabColor),
              ],
            ),
          ),
          const SizedBox(height: 2),
          Container(
            width: double.infinity,
            height: 0.5,
            color: greyColor.withAlpha((255 * 0.4).toInt()),
          ),
          const SizedBox(height: 10),
          _settingsItemWidget(
            title: "Account",
            description: "Security applications, change number",
            icon: Icons.key,
            onTap: () {},
          ),
          _settingsItemWidget(
            title: "Privacy",
            description: "Block contacts, disappearing messages",
            icon: Icons.lock,
            onTap: () {},
          ),
          _settingsItemWidget(
            title: "Chats",
            description: "Theme, wallpapers, chat history",
            icon: Icons.message,
            onTap: () {},
          ),
          _settingsItemWidget(
            title: "Logout",
            description: "Logout from WhatsApp Clone",
            icon: Icons.exit_to_app,
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

_settingsItemWidget({
  String? title,
  String? description,
  IconData? icon,
  VoidCallback? onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Row(
      children: [
        SizedBox(
          width: 80,
          height: 80,
          child: Icon(icon, color: greyColor, size: 25),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('$title', style: TextStyle(fontSize: 17)),
              const SizedBox(height: 3),
              Text("$description", style: TextStyle(color: greyColor)),
            ],
          ),
        ),
      ],
    ),
  );
}
