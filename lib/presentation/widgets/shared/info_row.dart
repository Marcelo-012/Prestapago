import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class InfoRow extends StatelessWidget {
  final String label;
  final String? value;
  final IconData icon;
  final Color color;

  const InfoRow({
    super.key,
    required this.label,
    this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = GoogleFonts.poppins();
    return Row(
      children: [
        Icon(icon, size: 18, color: color),
        const SizedBox(width: 8),
        Text('$label: ', style: textTheme.copyWith(fontSize: 14, fontWeight: FontWeight.w500)),
        if (value != null)
          Expanded(
            child: Text(
              value!,
              style: textTheme.copyWith(fontSize: 14, fontWeight: FontWeight.bold),
              textAlign: TextAlign.end,
            ),
          ),
      ],
    );
  }
}
