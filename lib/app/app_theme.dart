import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primarySwatch: Colors.blue,
    scaffoldBackgroundColor: Color(0xFF121212),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: GoogleFonts.lato(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    textTheme: TextTheme(
      displayLarge: GoogleFonts.montserrat(
          fontSize: 72.0, fontWeight: FontWeight.bold, color: Colors.white),
      headlineSmall: GoogleFonts.lato(
          fontSize: 36.0, fontStyle: FontStyle.italic, color: Colors.white),
      bodyMedium: GoogleFonts.lato(
          fontSize: 14.0, color: Colors.white),
    ),
    colorScheme: ColorScheme.fromSwatch(brightness: Brightness.dark)
        .copyWith(secondary: Colors.blueAccent),
  );
}
