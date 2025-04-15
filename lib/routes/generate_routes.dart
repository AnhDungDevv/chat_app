import 'package:chat_application/features/app/constants/page_const.dart';
import 'package:chat_application/features/app/settings/settings_page.dart';
import 'package:chat_application/features/call/presentation/pages/call_contacts_page.dart';
import 'package:chat_application/features/app/home/contact_page.dart';
import 'package:chat_application/features/chat/presentation/pages/single_chat_page.dart';
import 'package:chat_application/features/status/presentation/pages/my_status_page.dart';
import 'package:flutter/material.dart';

class GenerateRoutes {
  static Route<dynamic>? router(RouteSettings settings) {
    final args = settings.arguments;
    final name = settings.name;

    switch (name) {
      case PageConst.contactUsersPage:
        return materialPageBuilder(const ContactPage());
      case PageConst.myStatusPage:
        return materialPageBuilder(const MyStatusPage());
      case PageConst.callContactsPage:
        return materialPageBuilder(const CallContactsPage());
      case PageConst.settingsPage:
        return materialPageBuilder(const SettingsPage());
      case PageConst.singleChatPage:
        return materialPageBuilder(const SingleChatPage());

      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> materialPageBuilder(Widget child) {
    return MaterialPageRoute(builder: (context) => child);
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(
      builder:
          (_) => const Scaffold(body: Center(child: Text("Page not found"))),
    );
  }
}
