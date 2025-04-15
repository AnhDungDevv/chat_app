import 'package:chat_application/features/app/splash/splash_screen.dart';
import 'package:chat_application/features/app/theme/style.s.dart';
import 'package:chat_application/routes/generate_routes.dart';
import 'package:flutter/material.dart';
import 'package:chat_application/main_injection.dart' as dependencies;

void main() async {
  await dependencies.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        colorScheme: ColorScheme.fromSeed(
          seedColor: tabColor,
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: backgroundColor,
        appBarTheme: const AppBarTheme(color: appBarColor),
        dialogTheme: DialogThemeData(backgroundColor: appBarColor),
      ),
      onGenerateRoute: GenerateRoutes.router,
      initialRoute: "/",
      routes: {"/": (context) => SplashScreen()},
    );
  }
}
