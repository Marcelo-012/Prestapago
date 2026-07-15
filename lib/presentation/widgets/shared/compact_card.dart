import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CompactCard extends StatelessWidget {
  final bool selected;
  final String title;
  final String description;
  final Color color;
  final VoidCallback onTap;

  const CompactCard({
    super.key,
    required this.selected,
    required this.title,
    required this.description,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: selected ? color.withValues(alpha: 0.1) : Colors.grey.shade50,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected ? color : Colors.grey.shade300,
            width: 1.5,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(title,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: selected ? color : Colors.grey.shade700,
              )),
            const SizedBox(height: 4),
            Text(description,
              style: GoogleFonts.poppins(
                fontSize: 11,
                color: Colors.grey.shade600,
              )),
          ],
        ),
      ),
    );
  }
}
