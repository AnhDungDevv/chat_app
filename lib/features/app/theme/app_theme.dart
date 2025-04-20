import 'package:chat_application/features/app/theme/style.s.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData dark() {
    return ThemeData.dark().copyWith(
      colorScheme: ColorScheme.fromSeed(
        seedColor: tabColor,
        brightness: Brightness.dark,
      ),
      scaffoldBackgroundColor: backgroundColor,
      appBarTheme: const AppBarTheme(color: appBarColor),
      dialogTheme: const DialogTheme(backgroundColor: appBarColor),
    );
  }
}
