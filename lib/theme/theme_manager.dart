import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_fonts.dart';

ThemeData? get appTheme => ThemeData(
      useMaterial3: false,
      primaryColor: AppColors.primaryColor,
      fontFamily: AppFonts.dmSans,
      scaffoldBackgroundColor: Colors.white,
      dividerColor: const Color(0xffBEBEBE),
      colorScheme: ColorScheme.light(
        error: const Color(0xffd32f2f),
        secondary: const Color(0xff7A78A6).withOpacity(0.35),
      ),
      appBarTheme: const AppBarTheme(
        color: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
        elevation: 0.0,
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primaryButtonColor,
          backgroundColor: AppColors.primaryButtonColor,
          minimumSize: const Size(double.infinity, 55),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
          ),
        ),
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 36,
          color: Colors.white,
          fontFamily: AppFonts.dmSans,
        ),
        displayMedium: TextStyle(
          fontSize: 24,
          color: Colors.white,
          fontFamily: AppFonts.dmSans,
        ),
        displaySmall: TextStyle(
          fontSize: 18,
          color: Colors.white,
          fontFamily: AppFonts.dmSans,
        ),
        headlineMedium: TextStyle(
          fontSize: 39,
          color: Colors.white,
          fontFamily: AppFonts.dmSans,
        ),
        headlineSmall: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w400,
          fontFamily: AppFonts.dmSans,
        ),
        bodyLarge: TextStyle(
          fontSize: 32,
          color: Colors.white,
          fontFamily: AppFonts.dmSans,
          fontWeight: FontWeight.w400,
        ),
        bodyMedium: TextStyle(
          fontSize: 24,
          color: Colors.white,
          fontFamily: AppFonts.dmSans,
        ),
        bodySmall: TextStyle(
          fontSize: 18,
          color: Colors.white,
          fontFamily: AppFonts.dmSans,
          fontWeight: FontWeight.w400,
        ),
        labelLarge: TextStyle(
          fontSize: 18,
          color: Colors.white,
          fontFamily: AppFonts.roboto,
          fontWeight: FontWeight.w400,
        ),
        labelMedium: TextStyle(
          fontSize: 16,
          color: Colors.white,
          fontFamily: AppFonts.dmSans,
        ),
        labelSmall: TextStyle(
          fontSize: 12,
          color: Colors.white,
          fontFamily: AppFonts.dmSans,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
