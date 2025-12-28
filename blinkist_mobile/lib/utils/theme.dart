import 'package:flutter/cupertino.dart';

class AppTheme {
  AppTheme._();

  static const Color primaryGreen = Color(0xFF2CE080);
  static const Color backgroundLight = CupertinoColors.white;
  static const Color textBlack = CupertinoColors.black;
  static const Color textGrey = CupertinoColors.systemGrey;

  static const CupertinoThemeData mainTheme = CupertinoThemeData(
    primaryColor: primaryGreen,
    scaffoldBackgroundColor: backgroundLight,
    barBackgroundColor: backgroundLight,
    textTheme: CupertinoTextThemeData(
      // --- ИСПРАВЛЕНИЕ ЗДЕСЬ ---
      // Добавляем inherit: false, чтобы избежать ошибки интерполяции
      navTitleTextStyle: TextStyle(
        inherit: false, 
        fontFamily: 'Sans',
        fontWeight: FontWeight.bold,
        fontSize: 20,
        color: textBlack,
      ),
      textStyle: TextStyle(
        inherit: false, 
        fontFamily: 'Sans',
        color: textBlack,
        fontSize: 16,
      ),
    ),
  );
}



