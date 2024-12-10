import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTextStyles {
  // Title Large
  static TextStyle titleLarge = GoogleFonts.aBeeZee(
    textStyle: const TextStyle(
      fontSize: 22.0,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    ),
  );

  // Title Medium
  static TextStyle titleMedium = GoogleFonts.aBeeZee(
    textStyle: const TextStyle(
      fontSize: 18.0,
      fontWeight: FontWeight.w400,
      color: Colors.black,
    ),
  );

  // Title Small
  static TextStyle titleSmall = GoogleFonts.aBeeZee(
    textStyle: const TextStyle(
      fontSize: 14.0,
      fontWeight: FontWeight.w500,
      color: Colors.black,
    ),
  );

  // Body Text
  static TextStyle bodyText = GoogleFonts.aBeeZee(
    textStyle: TextStyle(
      fontSize: 16.0,
      fontWeight: FontWeight.normal,
      color: Colors.grey[800],
    ),
  );

  // Subtitle Text
  static TextStyle subtitle = GoogleFonts.aBeeZee(
    textStyle: const TextStyle(
      fontSize: 12.0,
      fontWeight: FontWeight.normal,
      color: Colors.grey,
    ),
  );
}
