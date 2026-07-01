import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CardItem extends StatelessWidget {
  final double? width;
  final double? height;
  final String? title;
  final String? subtitle;
  final String? text;
  final Color? colortext;
  final VoidCallback? onTap;

  const CardItem({
    //
    this.width,
    this.height,
    this.title,
    this.subtitle,
    this.text,
    this.colortext,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title ?? '',
                  style: GoogleFonts.poppins(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  subtitle ?? '',
                  style: GoogleFonts.poppins(
                    fontSize: 28,
                    fontWeight: FontWeight.w500,
                    color: colortext ?? Colors.black,
                  ),
                ),
                Text(
                  text ?? '',
                  style: GoogleFonts.poppins(
                    fontSize: 15,
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
