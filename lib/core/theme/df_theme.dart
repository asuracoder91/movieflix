import 'package:flutter/material.dart';

import 'df_colors.dart';

abstract class DFTheme {
  static ThemeData dark = ThemeData(
    fontFamily: "Pretendard",
    textTheme: const TextTheme(
      bodyLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.15,
        color: DFColors.textColor,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: DFColors.textColor,
      ),
      bodySmall: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: DFColors.textColor,
      ),
      displayLarge: TextStyle(
        fontSize: 23,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.15,
        color: DFColors.textColor,
      ),
      displayMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: DFColors.textColor,
      ),
      displaySmall: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: DFColors.textColor,
      ),
      headlineLarge: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.5,
        color: DFColors.labelColor,
      ),
      labelMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: DFColors.textColor,
      ),
    ),
    appBarTheme: const AppBarTheme(
      elevation: 0,
      backgroundColor: Colors.transparent,
    ),
    iconTheme: const IconThemeData(color: DFColors.iconColor),
    scaffoldBackgroundColor: DFColors.backgroundColor,
  );
}
