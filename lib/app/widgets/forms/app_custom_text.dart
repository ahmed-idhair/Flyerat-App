import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppCustomText extends StatelessWidget {
  final String text;
  final double fontSize;
  final FontWeight fontWeight;
  final Color color;
  final TextAlign textAlign;
  final int? maxLines; // Optional max lines
  final double? height; // Optional max lines
  final TextOverflow? overflow; // Optiona
  final TextDecoration? decoration; // Optiona

  const AppCustomText({
    super.key,
    required this.text,
    this.fontSize = 16.0,
    this.maxLines,
    this.height,
    this.overflow,
    this.decoration,
    this.fontWeight = FontWeight.normal,
    this.color = Colors.black,
    this.textAlign = TextAlign.start,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      style: GoogleFonts.roboto(
        fontSize: fontSize,
        height: height,
        decoration: decoration,
        decorationColor: color,
        fontWeight: fontWeight,
        color: color,
      ),
    );
  }
}
