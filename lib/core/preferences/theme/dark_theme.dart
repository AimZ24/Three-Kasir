import 'package:flutter/material.dart';
import 'package:kasirsuper/core/core.dart';

class DarkTheme {
  final Color primaryColor;
  final Color errorColor = AppColors.red;
  final Color scaffoldColor = const Color(0xFF121212);
  final Color textSolidColor = AppColors.white;
  final Color borderColor = const Color(0xFF2C2C2C);
  final Color textDisabledColor = const Color(0xFF757575);
  final Color inputColor = const Color(0xFF1E1E1E);

  TextTheme get textTheme => TextTheme(
        headlineLarge: TextStyle(
          fontSize: Dimens.dp32,
          fontWeight: FontWeight.bold,
          color: textSolidColor,
        ),
        headlineMedium: TextStyle(
          fontSize: Dimens.dp24,
          fontWeight: FontWeight.w600,
          color: textSolidColor,
        ),
        headlineSmall: TextStyle(
          fontSize: Dimens.dp20,
          fontWeight: FontWeight.w600,
          color: textSolidColor,
        ),
        titleLarge: TextStyle(
          fontSize: Dimens.dp16,
          fontWeight: FontWeight.w600,
          color: textSolidColor,
        ),
        titleMedium: TextStyle(
          fontSize: Dimens.dp14,
          fontWeight: FontWeight.w600,
          color: textSolidColor,
        ),
        bodyLarge: TextStyle(
          fontSize: Dimens.dp16,
          fontWeight: FontWeight.w500,
          color: textSolidColor,
        ),
        bodyMedium: TextStyle(
          fontSize: Dimens.dp14,
          fontWeight: FontWeight.normal,
          color: textSolidColor,
        ),
        labelMedium: TextStyle(
          fontSize: Dimens.dp12,
          fontWeight: FontWeight.w500,
          color: textDisabledColor,
        ),
      );

  DarkTheme(this.primaryColor);

  CardThemeData get cardTheme => CardThemeData(
        elevation: 0,
        margin: EdgeInsets.zero,
        color: inputColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Dimens.dp8),
          side: BorderSide(color: borderColor),
        ),
      );

  AppBarTheme get appBarTheme => AppBarTheme(
        centerTitle: false,
        backgroundColor: scaffoldColor,
        surfaceTintColor: scaffoldColor,
        shadowColor: Colors.black.withAlpha((0.4 * 255).round()),
      );

  BottomNavigationBarThemeData get bottomNavigationBarTheme {
    return BottomNavigationBarThemeData(
      type: BottomNavigationBarType.fixed,
      backgroundColor: inputColor,
      selectedItemColor: primaryColor,
      unselectedItemColor: textDisabledColor,
      selectedLabelStyle: textTheme.labelMedium?.copyWith(
        fontSize: Dimens.dp10,
        color: primaryColor,
      ),
      unselectedLabelStyle: textTheme.labelMedium?.copyWith(
        fontSize: Dimens.dp10,
        color: textDisabledColor,
      ),
    );
  }

  ElevatedButtonThemeData get elevatedButtonTheme {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Dimens.dp8),
        ),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white, // White text for dark mode
        textStyle: textTheme.titleMedium,
      ),
    );
  }

  OutlinedButtonThemeData get outlinedButtonTheme {
    return OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Dimens.dp8),
      ),
      side: BorderSide(color: primaryColor),
      foregroundColor: primaryColor,
      textStyle: textTheme.titleMedium,
    ));
  }

  InputDecorationTheme get inputDecorationTheme {
    return InputDecorationTheme(
      fillColor: inputColor,
      filled: true,
      iconColor: textDisabledColor,
      hintStyle: textTheme.labelMedium,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: Dimens.defaultSize,
        vertical: Dimens.dp12,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(Dimens.dp8),
        borderSide: BorderSide(color: borderColor),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(Dimens.dp8),
        borderSide: BorderSide(color: borderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(Dimens.dp8),
        borderSide: BorderSide(color: primaryColor),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(Dimens.dp8),
        borderSide: BorderSide(color: errorColor),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(Dimens.dp8),
        borderSide: BorderSide(color: errorColor),
      ),
    );
  }

  DividerThemeData get dividerTheme {
    return DividerThemeData(
      color: borderColor,
    );
  }

  ThemeData get theme {
    return ThemeData(
      primaryColor: primaryColor,
      fontFamily: 'Poppins',
      colorScheme: ColorScheme.dark(
        primary: primaryColor,
        secondary: primaryColor,
        error: errorColor,
        surface: scaffoldColor,
      ),
      scaffoldBackgroundColor: scaffoldColor,
      useMaterial3: true,
      textTheme: textTheme,
      appBarTheme: appBarTheme,
      cardTheme: cardTheme,
      bottomNavigationBarTheme: bottomNavigationBarTheme,
      elevatedButtonTheme: elevatedButtonTheme,
      outlinedButtonTheme: outlinedButtonTheme,
      inputDecorationTheme: inputDecorationTheme,
      dividerTheme: dividerTheme,
    );
  }
}
