import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';

class AppTheme {
  static final TextTheme _buildTextTheme = TextTheme(
    titleLarge: GoogleFonts.fjallaOne(fontSize: 40),
    titleMedium: GoogleFonts.poppins(fontSize: 30, fontWeight: FontWeight.bold),
    titleSmall: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w500),
  );

  ThemeData getLightTheme({FlexScheme scheme = FlexScheme.blumineBlue}) {
    return FlexThemeData.light(
      scheme: scheme,
      useMaterial3: true,
      textTheme: _buildTextTheme,
    ).copyWith(
      filledButtonTheme: FilledButtonThemeData(
        style: ButtonStyle(
          textStyle: WidgetStatePropertyAll(
            GoogleFonts.poppins().copyWith(fontWeight: FontWeight.w700),
          ),
        ),
      ),
    );
  }

  ThemeData getDarkTheme({FlexScheme scheme = FlexScheme.blumineBlue}) {
    return FlexThemeData.dark(
      scheme: scheme,
      useMaterial3: true,
      textTheme: _buildTextTheme,
    ).copyWith(
      filledButtonTheme: FilledButtonThemeData(
        style: ButtonStyle(
          textStyle: WidgetStatePropertyAll(
            GoogleFonts.poppins(fontWeight: FontWeight.w700),
          ),
        ),
      ),
    );
  }
}
