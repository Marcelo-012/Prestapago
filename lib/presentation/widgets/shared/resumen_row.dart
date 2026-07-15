import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ResumenRow extends StatelessWidget {
  final String label;
  final String value;

  const ResumenRow({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: GoogleFonts.poppins(color: Colors.grey.shade600)),
          Text(value, style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
