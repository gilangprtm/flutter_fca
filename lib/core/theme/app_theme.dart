import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_color.dart';
import 'app_typografi.dart';

class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    fontFamily: GoogleFonts.poppins().fontFamily,
    brightness: Brightness.light,
    primaryColor: AppColors.primaryColor,
    colorScheme: const ColorScheme.light(
      primary: AppColors.primaryColor,
      primaryContainer: AppColors.primaryLightColor,
      secondary: AppColors.lightSecondaryColor,
      secondaryContainer: AppColors.lightSecondaryLightColor,
      surface: AppColors.lightSurfaceColor,
      error: AppColors.errorColor,
      onPrimary: Colors.white,
      onSecondary: AppColors.lightTextPrimaryColor,
      onSurface: AppColors.lightTextPrimaryColor,
      onError: Colors.white,
    ),
    scaffoldBackgroundColor: AppColors.lightBackgroundColor,
    cardColor: AppColors.lightCardColor,
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.primaryColor,
      foregroundColor: Colors.white,
      titleTextStyle: AppTypography.headline6
          .copyWith(color: AppColors.lightTextSecondaryColor),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.lightCardColor,
      selectedItemColor: AppColors.primaryColor,
      unselectedItemColor: AppColors.lightTextSecondaryColor,
    ),
    textTheme: TextTheme(
      displayLarge: AppTypography.headline1
          .copyWith(color: AppColors.lightTextPrimaryColor),
      displayMedium: AppTypography.headline2
          .copyWith(color: AppColors.lightTextPrimaryColor),
      displaySmall: AppTypography.headline3
          .copyWith(color: AppColors.lightTextPrimaryColor),
      headlineMedium: AppTypography.headline4
          .copyWith(color: AppColors.lightTextPrimaryColor),
      headlineSmall: AppTypography.headline5
          .copyWith(color: AppColors.lightTextPrimaryColor),
      titleLarge: AppTypography.headline6
          .copyWith(color: AppColors.lightTextPrimaryColor),
      titleMedium: AppTypography.subtitle1
          .copyWith(color: AppColors.lightTextPrimaryColor),
      titleSmall: AppTypography.subtitle2
          .copyWith(color: AppColors.lightTextSecondaryColor),
      bodyLarge: AppTypography.bodyText1
          .copyWith(color: AppColors.lightTextPrimaryColor),
      bodyMedium: AppTypography.bodyText2
          .copyWith(color: AppColors.lightTextSecondaryColor),
      labelLarge: AppTypography.button.copyWith(color: Colors.white),
      bodySmall: AppTypography.caption
          .copyWith(color: AppColors.lightTextSecondaryColor),
      labelSmall: AppTypography.overline
          .copyWith(color: AppColors.lightTextSecondaryColor),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: AppColors.primaryColor,
        textStyle: AppTypography.button,
      ),
    ),
    inputDecorationTheme: const InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.primaryColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.primaryLightColor),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.errorColor),
      ),
    ),
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );

  static final ThemeData darkTheme = ThemeData(
    fontFamily: GoogleFonts.poppins().fontFamily,
    brightness: Brightness.dark,
    primaryColor: AppColors.primaryColor,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.primaryColor,
      primaryContainer: AppColors.primaryLightColor,
      secondary: AppColors.darkSecondaryColor,
      secondaryContainer: AppColors.darkSecondaryLightColor,
      surface: AppColors.darkSurfaceColor,
      error: AppColors.errorColor,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: Colors.white,
      onError: Colors.white,
    ),
    scaffoldBackgroundColor: AppColors.darkBackgroundColor,
    cardColor: AppColors.darkCardColor,
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.primaryColor,
      foregroundColor: Colors.white,
      titleTextStyle: AppTypography.headline6
          .copyWith(color: AppColors.darkTextSecondaryColor),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.darkCardColor,
      selectedItemColor: AppColors.primaryLightColor,
      unselectedItemColor: Colors.white70,
    ),
    textTheme: TextTheme(
      displayLarge: AppTypography.headline1
          .copyWith(color: AppColors.darkTextPrimaryColor),
      displayMedium: AppTypography.headline2
          .copyWith(color: AppColors.darkTextPrimaryColor),
      displaySmall: AppTypography.headline3
          .copyWith(color: AppColors.darkTextPrimaryColor),
      headlineMedium: AppTypography.headline4
          .copyWith(color: AppColors.darkTextPrimaryColor),
      headlineSmall: AppTypography.headline5
          .copyWith(color: AppColors.darkTextPrimaryColor),
      titleLarge: AppTypography.headline6
          .copyWith(color: AppColors.darkTextPrimaryColor),
      titleMedium: AppTypography.subtitle1
          .copyWith(color: AppColors.darkTextPrimaryColor),
      titleSmall: AppTypography.subtitle2
          .copyWith(color: AppColors.darkTextSecondaryColor),
      bodyLarge: AppTypography.bodyText1
          .copyWith(color: AppColors.darkTextPrimaryColor),
      bodyMedium: AppTypography.bodyText2
          .copyWith(color: AppColors.darkTextSecondaryColor),
      labelLarge: AppTypography.button.copyWith(color: Colors.black),
      bodySmall: AppTypography.caption
          .copyWith(color: AppColors.darkTextSecondaryColor),
      labelSmall: AppTypography.overline
          .copyWith(color: AppColors.darkTextSecondaryColor),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: AppColors.primaryColor,
        textStyle: AppTypography.button,
      ),
    ),
    inputDecorationTheme: const InputDecorationTheme(
      filled: true,
      fillColor: AppColors.darkSurfaceColor,
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.primaryColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.primaryLightColor),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.errorColor),
      ),
    ),
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );
}
