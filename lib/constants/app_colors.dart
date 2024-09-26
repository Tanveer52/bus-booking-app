import 'package:flutter/material.dart';

import 'app_fonts.dart';

class AppColors {
  static const Color primaryColor = Color(0xFF006400);
  static const Color primaryButtonColor = Color(0xFF004d00);
  static const Color secondaryColor = Color(0XFF7a7878);
  static const Color tertiaryColor = Color(0xff000000);
  static const Color whiteColor = Colors.white;
  static const Color primaryTextColor = Color(0xFF111827);
  static const Color errorColor = Color(0xFFDC2626);
}

class AppTextStyle {
  static TextStyle normal(
      {Color color = AppColors.secondaryColor, required double fontSize}) {
    return TextStyle(
      fontFamily: AppFonts.dmSans,
      color: color,
      fontSize: fontSize,
      fontWeight: FontWeight.normal,
    );
  }

  static TextStyle medium(
      {Color color = AppColors.tertiaryColor, required double fontSize}) {
    return TextStyle(
      fontFamily: AppFonts.dmSans,
      color: color,
      fontSize: fontSize,
      fontWeight: FontWeight.w500,
    );
  }

  static TextStyle bold(
      {Color color = AppColors.secondaryColor, required double fontSize}) {
    return TextStyle(
      fontFamily: AppFonts.dmSans,
      color: color,
      fontSize: fontSize,
      fontWeight: FontWeight.w700,
    );
  }
}
