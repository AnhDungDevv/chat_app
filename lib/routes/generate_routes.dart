import 'package:chat_application/features/app/constants/page_const.dart';
import 'package:chat_application/features/app/settings/settings_page.dart';
import 'package:chat_application/features/call/domain/entities/call_entity.dart';
import 'package:chat_application/features/call/presentation/pages/call_contacts_page.dart';
import 'package:chat_application/features/app/home/contact_page.dart';
import 'package:chat_application/features/call/presentation/pages/call_page.dart';
import 'package:chat_application/features/chat/domain/entities/message_entity.dart';
import 'package:chat_application/features/chat/presentation/pages/single_chat_page.dart';
import 'package:chat_application/features/status/domain/entities/status_enity.dart';
import 'package:chat_application/features/status/presentation/pages/my_status_page.dart';
import 'package:chat_application/features/user/domain/entities/user_entity.dart';
import 'package:chat_application/features/user/presentation/pages/edit_prodile_page.dart';
import 'package:flutter/material.dart';

class GenerateRoutes {
  static Route<dynamic>? router(RouteSettings settings) {
    final args = settings.arguments;
    final name = settings.name;

    switch (name) {
      case PageConst.contactUsersPage:
        {
          if (args is String) {
            return materialPageBuilder(ContactPage(userId: args));
          } else {
            return materialPageBuilder(const ErrorPage());
          }
        }
      case PageConst.myStatusPage:
        {
          if (args is StatusEntity) {
            return materialPageBuilder(MyStatusPage(status: args));
          } else {
            return materialPageBuilder(const ErrorPage());
          }
        }
         case PageConst.callPage:
        {
          if (args is CallEntity) {
            return materialPageBuilder(CallPage(callEntity: args));
          } else {
            return materialPageBuilder(const ErrorPage());
          }
        }
      case PageConst.callContactsPage:
        return materialPageBuilder(const CallContactsPage());
      case PageConst.settingsPage:
        {
          if (args is String) {
            return materialPageBuilder(SettingsPage(uid: args));
          } else {
            return materialPageBuilder(const ErrorPage());
          }
        }
      case PageConst.editProfilePage:
        {
          if (args is UserEntity) {
            return materialPageBuilder(EditProfilePage(currentUser: args));
          } else {
            return materialPageBuilder(const ErrorPage());
          }
        }
      case PageConst.singleChatPage:
        {
          if (args is MessageEntity) {
            return materialPageBuilder(SingleChatPage(message: args));
          } else {
            return materialPageBuilder(const ErrorPage());
          }
        }

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

class ErrorPage extends StatelessWidget {
  const ErrorPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Error page")),
      body: Center(child: Text('Error Page')),
    );
  }
}
