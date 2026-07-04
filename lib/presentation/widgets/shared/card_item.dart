import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CardItem extends StatelessWidget {
  final double? width;
  final double? height;
  final String? title;
  final String? subtitle;
  final String? text;
  final Color? colortext;
  final double? fontSizeTitle;
  final double? fontSizeSubtitle;
  final double? fontSizeText;
  final VoidCallback? onTap;
  final CrossAxisAlignment alignment; // ← nuevo parámetro

  const CardItem({
    this.width,
    this.height,
    this.title,
    this.subtitle,
    this.text,
    this.colortext,
    this.onTap,
    super.key,
    this.fontSizeTitle,
    this.fontSizeSubtitle,
    this.fontSizeText,
    this.alignment =
        CrossAxisAlignment.start, // ← valor por defecto: como estaba antes
  });

  @override
  Widget build(BuildContext context) {
    final textAlign = alignment == CrossAxisAlignment.center
        ? TextAlign.center
        : TextAlign.start;

    return SizedBox(
      width: width ?? 350,
      height: height ?? 130,
      child: InkWell(
        onTap: onTap,
        child: Card(
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: alignment, // ← usa el parámetro
              children: [
                Text(
                  title ?? '',
                  textAlign: textAlign,
                  style: GoogleFonts.poppins(
                    fontSize: fontSizeTitle ?? 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                AutoSizeText(
                  subtitle ?? '',
                  maxFontSize: 28,
                  minFontSize: 10,
                  maxLines: 2,
                  textAlign: textAlign,
                  presetFontSizes: [
                    fontSizeSubtitle ?? 28,
                    26,
                    24,
                    22,
                    20,
                    16,
                    13,
                    10,
                  ],
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500,
                    color: colortext ?? Colors.black,
                  ),
                ),
                if (text != null && text!.isNotEmpty)
                  Text(
                    text!,
                    textAlign: textAlign,
                    style: GoogleFonts.poppins(
                      fontSize: fontSizeText ?? 15,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
