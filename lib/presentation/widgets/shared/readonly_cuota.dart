import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prestapagos/config/helpers/human_formats.dart';

class ReadonlyCuota extends StatelessWidget {
  final String value;

  const ReadonlyCuota({super.key, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Cuota mensual',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 4),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: Text(
            value.isNotEmpty
                ? HumanFormats.monuted(double.tryParse(value) ?? 0)
                : '—',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
