import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MoratorioToggle extends StatelessWidget {
  final bool activo;
  final VoidCallback onToggle;

  const MoratorioToggle({super.key, required this.activo, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onToggle,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: activo ? Colors.green.shade50 : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: activo ? Colors.green : Colors.grey.shade300,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              activo ? Icons.check_circle : Icons.radio_button_unchecked,
              color: activo ? Colors.green : Colors.grey,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text('Activar moratorio',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w500,
                fontSize: 14,
                color: activo ? Colors.green.shade800 : Colors.grey.shade700,
              )),
          ],
        ),
      ),
    );
  }
}
