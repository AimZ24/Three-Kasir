import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RegularText extends StatelessWidget {
  final String data;
  final TextAlign? textAlign;
  final double? fontSize;
  final FontWeight? fontWeight;
  final Color? color;
  final int? maxLines;

  const RegularText(
    this.data, {
    super.key,
    this.textAlign,
    this.fontSize = 14,
    this.fontWeight = FontWeight.normal,
    this.color,
    this.maxLines,
  });

  factory RegularText.semiBold(
    String data, {
    Key? key,
    TextAlign? textAlign,
    double? fontSize,
    Color? color,
    int? maxLines,
  }) {
    return RegularText(
      data,
      key: key,
      textAlign: textAlign,
      fontSize: fontSize,
      fontWeight: FontWeight.w600,
      color: color,
      maxLines: maxLines,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      data,
      textAlign: textAlign,
      maxLines: maxLines,
      style: GoogleFonts.poppins(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color ?? Theme.of(context).textTheme.bodyMedium?.color,
      ),
    );
  }
}

class SubtitleText extends StatelessWidget {
  final String data;
  final TextAlign? textAlign;
  final Color? color;
  final int? maxLines;

  const SubtitleText(
    this.data, {
    super.key,
    this.textAlign,
    this.color,
    this.maxLines,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      data,
      textAlign: textAlign,
      maxLines: maxLines,
      style: GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: color ?? Theme.of(context).textTheme.titleMedium?.color,
      ),
    );
  }
}