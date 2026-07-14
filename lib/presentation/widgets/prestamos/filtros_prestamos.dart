import 'package:flutter/material.dart';

class FiltrosPrestamos extends StatefulWidget {
  final String initialFilter;
  final void Function(String filter) onFilterChanged;

  const FiltrosPrestamos({
    super.key,
    this.initialFilter = 'al_dia',
    required this.onFilterChanged,
  });

  @override
  State<FiltrosPrestamos> createState() => _FiltrosPrestamosState();
}

class _FiltrosPrestamosState extends State<FiltrosPrestamos> {
  late int selectedIndex;
  final List<String> opciones = ['Todos', 'Al día', 'Atrasados', 'Liquidados'];
  final List<String> valores = ['todos', 'al_dia', 'atrasados', 'liquidados'];

  @override
  void initState() {
    super.initState();
    selectedIndex = valores.indexOf(widget.initialFilter);
    if (selectedIndex < 0) selectedIndex = 1;
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: opciones.length,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemBuilder: (context, index) {
          final isSelected = selectedIndex == index;

          return GestureDetector(
            onTap: () {
              setState(() => selectedIndex = index);
              widget.onFilterChanged(valores[index]);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(right: 10),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? colors.primary : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected ? Colors.transparent : Colors.grey.shade300,
                  width: 1,
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                opciones[index],
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.grey.shade600,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  fontSize: 14,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
