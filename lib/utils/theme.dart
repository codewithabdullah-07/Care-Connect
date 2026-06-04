import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'colors.dart';

class CareConnectTheme {
  static ThemeData get light => _build(Brightness.light);
  static ThemeData get dark => _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final background = isDark
        ? AppColors.darkBackgroundPrimary
        : AppColors.lightBackgroundPrimary;
    final secondaryBackground = isDark
        ? AppColors.darkBackgroundSecondary
        : AppColors.lightBackgroundSecondary;
    final surface = isDark
        ? AppColors.darkSurfaceElevated
        : AppColors.lightSurfaceElevated;
    final appBar = isDark
        ? AppColors.darkBackgroundPrimary
        : AppColors.lightPrimaryAccent;
    final textPrimary = isDark
        ? AppColors.darkTextPrimary
        : AppColors.lightTextPrimary;
    final textSecondary = isDark
        ? AppColors.darkTextSecondary
        : AppColors.lightTextSecondary;
    final textTertiary = isDark
        ? AppColors.darkTextTertiary
        : AppColors.lightTextTertiary;
    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final divider = isDark ? AppColors.darkDivider : AppColors.lightDivider;
    final error = isDark ? AppColors.darkError : AppColors.lightError;

    final heading = GoogleFonts.cormorantGaramond(
      color: textPrimary,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.5,
      height: 1.3,
    );
    final body = GoogleFonts.dmSans(
      color: textSecondary,
      fontWeight: FontWeight.w400,
      height: 1.6,
    );

    return (isDark ? ThemeData.dark() : ThemeData.light()).copyWith(
      useMaterial3: true,
      brightness: brightness,
      scaffoldBackgroundColor: background,
      colorScheme: ColorScheme(
        brightness: brightness,
        primary: isDark
            ? AppColors.darkPrimaryAccent
            : AppColors.lightPrimaryAccent,
        onPrimary: isDark ? AppColors.darkBackgroundPrimary : AppColors.ivory,
        secondary: AppColors.gold,
        onSecondary: AppColors.plum,
        error: error,
        onError: AppColors.ivory,
        surface: surface,
        onSurface: textPrimary,
      ),
      textTheme: TextTheme(
        displayLarge: heading.copyWith(
          fontSize: 32,
          fontWeight: FontWeight.w700,
        ),
        headlineLarge: heading.copyWith(
          fontSize: 32,
          fontWeight: FontWeight.w700,
        ),
        headlineMedium: heading.copyWith(
          fontSize: 24,
          fontWeight: FontWeight.w700,
        ),
        titleLarge: heading.copyWith(fontSize: 20, fontWeight: FontWeight.w600),
        titleMedium: heading.copyWith(
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        titleSmall: GoogleFonts.dmSans(
          color: textPrimary,
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.3,
          height: 1.3,
        ),
        bodyLarge: body.copyWith(color: textPrimary, fontSize: 14),
        bodyMedium: body.copyWith(color: textSecondary, fontSize: 14),
        bodySmall: body.copyWith(color: textTertiary, fontSize: 12),
        labelLarge: GoogleFonts.dmSans(
          color: textPrimary,
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.3,
          height: 1.2,
        ),
        labelMedium: GoogleFonts.dmSans(
          color: textSecondary,
          fontSize: 12,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.3,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: appBar,
        foregroundColor: AppColors.gold,
        elevation: 0,
        centerTitle: false,
        iconTheme: const IconThemeData(color: AppColors.gold),
        titleTextStyle: GoogleFonts.cormorantGaramond(
          color: AppColors.ivory,
          fontSize: 22,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
        shape: Border(
          bottom: BorderSide(
            color: AppColors.gold.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
      ),
      cardTheme: CardThemeData(
        color: surface,
        elevation: 2,
        shadowColor: Colors.black.withValues(alpha: 0.06),
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: divider, width: 0.5),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: secondaryBackground,
        labelStyle: GoogleFonts.dmSans(color: textSecondary, fontSize: 12),
        floatingLabelStyle: GoogleFonts.dmSans(
          color: AppColors.gold,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        hintStyle: GoogleFonts.dmSans(color: textTertiary, fontSize: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.gold, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: error, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: isDark ? AppColors.gold : AppColors.plum,
          foregroundColor: isDark ? AppColors.plum : AppColors.ivory,
          elevation: 2,
          shadowColor: Colors.black.withValues(alpha: 0.08),
          minimumSize: const Size(double.infinity, 56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: GoogleFonts.dmSans(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            letterSpacing: 0.3,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.gold,
          minimumSize: const Size(double.infinity, 56),
          side: const BorderSide(color: AppColors.gold, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: GoogleFonts.dmSans(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            letterSpacing: 0.3,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.gold,
          textStyle: GoogleFonts.dmSans(
            fontWeight: FontWeight.w600,
            letterSpacing: 0.3,
          ),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: Colors.transparent,
        selectedColor: AppColors.gold,
        labelStyle: GoogleFonts.dmSans(
          color: textPrimary,
          fontWeight: FontWeight.w600,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(color: AppColors.gold),
        ),
      ),
      dividerColor: divider,
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.gold,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.plum,
        contentTextStyle: GoogleFonts.dmSans(
          color: AppColors.ivory,
          fontSize: 13,
        ),
        actionTextColor: AppColors.gold,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: _CareConnectPageTransitionsBuilder(),
          TargetPlatform.iOS: _CareConnectPageTransitionsBuilder(),
          TargetPlatform.windows: _CareConnectPageTransitionsBuilder(),
          TargetPlatform.macOS: _CareConnectPageTransitionsBuilder(),
          TargetPlatform.linux: _CareConnectPageTransitionsBuilder(),
        },
      ),
    );
  }
}

class _CareConnectPageTransitionsBuilder extends PageTransitionsBuilder {
  const _CareConnectPageTransitionsBuilder();

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    final curved = CurvedAnimation(
      parent: animation,
      curve: Curves.easeOutCubic,
    );
    return FadeTransition(
      opacity: curved,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.04),
          end: Offset.zero,
        ).animate(curved),
        child: child,
      ),
    );
  }
}
