import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

/// App theme and styling constants
class AppTheme {
  // Colors
  static const Color primaryColor = Color(0xFFF04F32);
  static const Color secondaryColor = Color(0xFF536DFE);
  static const Color accentColor = Color(0xFF00B0FF);
  static const Color errorColor = Color(0xFFE53935);
  static const Color successColor = Color(0xFF43A047);
  static const Color warningColor = Color(0xFFFFA000);
  static const Color backgroundColor = Color(0xFFF5F5F5);
  static const Color surfaceColor = Colors.white;
  static const Color textPrimaryColor = Color(0xFF212121);
  static const Color textSecondaryColor = Color(0xFF757575);
  static const Color dividerColor = Color(0xFF585858);
  static const Color text17 = Color(0xFF1D2939);

  // Spacing
  static double get spacing4 => 4.w;

  static double get spacing8 => 8.w;

  static double get spacing12 => 12.w;

  static double get spacing16 => 16.w;

  static double get spacing24 => 24.w;

  static double get spacing32 => 32.w;

  static double get spacing48 => 48.w;

  // Border Radius
  static double get borderRadiusSmall => 4.r;

  static double get borderRadiusMedium => 30.r;
  static double get borderRadiusTextField => 8.r;

  static double get borderRadiusLarge => 16.r;

  static double get borderRadiusXLarge => 24.r;

  static double get borderRadiusCircular => 100.r;

  // Shadows
  static List<BoxShadow> get shadowSmall => [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.05),
      blurRadius: 4.r,
      offset: Offset(0, 2.h),
    ),
  ];

  static List<BoxShadow> get shadowMedium => [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.07),
      blurRadius: 8.r,
      offset: Offset(0, 4.h),
    ),
  ];

  static List<BoxShadow> get shadowLarge => [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.1),
      blurRadius: 16.r,
      offset: Offset(0, 8.h),
    ),
  ];

  // Font Sizes
  static double get fontSizeXSmall => 10.sp;

  static double get fontSizeSmall => 12.sp;

  static double get fontSizeMedium => 14.sp;

  static double get fontSizeRegular => 16.sp;

  static double get fontSizeLarge => 18.sp;

  static double get fontSizeXLarge => 20.sp;

  static double get fontSizeXXLarge => 24.sp;

  static double get fontSizeDisplay => 32.sp;

  // Text Styles with Google Fonts Roboto
  static TextStyle get headlineLarge => GoogleFonts.roboto(
    fontSize: fontSizeXXLarge,
    fontWeight: FontWeight.bold,
    color: textPrimaryColor,
  );

  static TextStyle get headlineMedium => GoogleFonts.roboto(
    fontSize: fontSizeXLarge,
    fontWeight: FontWeight.bold,
    color: textPrimaryColor,
  );

  static TextStyle get titleLarge => GoogleFonts.roboto(
    fontSize: fontSizeLarge,
    fontWeight: FontWeight.w600,
    color: textPrimaryColor,
  );

  static TextStyle get titleMedium => GoogleFonts.roboto(
    fontSize: fontSizeRegular,
    fontWeight: FontWeight.w600,
    color: textPrimaryColor,
  );

  static TextStyle get bodyLarge => GoogleFonts.roboto(
    fontSize: fontSizeRegular,
    fontWeight: FontWeight.normal,
    color: textPrimaryColor,
  );

  static TextStyle get bodyMedium => GoogleFonts.roboto(
    fontSize: fontSizeMedium,
    fontWeight: FontWeight.normal,
    color: textPrimaryColor,
  );

  static TextStyle get bodySmall => GoogleFonts.roboto(
    fontSize: fontSizeSmall,
    fontWeight: FontWeight.normal,
    color: textSecondaryColor,
  );

  static TextStyle get buttonText => GoogleFonts.roboto(
    fontSize: fontSizeMedium,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );

  // Theme Data with Google Fonts Roboto
  static ThemeData get lightTheme => ThemeData(
    primaryColor: primaryColor,
    fontFamily: "Roboto",
    textTheme: GoogleFonts.robotoTextTheme(),
    colorScheme: const ColorScheme.light(
      primary: primaryColor,
      secondary: secondaryColor,
      error: errorColor,
      background: backgroundColor,
      surface: surfaceColor,
    ),
    scaffoldBackgroundColor: backgroundColor,
    appBarTheme: AppBarTheme(
      backgroundColor: primaryColor,
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.black),
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.dark,
      ),
      titleTextStyle: headlineMedium.copyWith(color: Colors.white),
    ),
  );
}
