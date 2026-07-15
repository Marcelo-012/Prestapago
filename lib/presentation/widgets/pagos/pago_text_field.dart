import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PagoTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final ValueChanged<String>? onChanged;
  final String? errorText;

  const PagoTextField({
    super.key,
    required this.controller,
    required this.label,
    this.onChanged,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = GoogleFonts.poppins();
    return TextField(
      controller: controller,
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        prefixText: '\$ ',
        errorText: errorText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      style: textTheme.copyWith(
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
