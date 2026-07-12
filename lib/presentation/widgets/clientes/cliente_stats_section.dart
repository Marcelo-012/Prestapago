import 'package:flutter/material.dart';
//import 'package:prestapagos/config/helpers/human_formats.dart';
import 'package:prestapagos/presentation/widgets/shared/card_item.dart';

class ClienteStatsSection extends StatelessWidget {
  final int totalPrestamos;
  final int totalPrestamosActivos;
  final int totalPrestamosFinalizados;

  const ClienteStatsSection({
    super.key,
    required this.totalPrestamos,
    required this.totalPrestamosActivos,
    required this.totalPrestamosFinalizados,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        children: [
          _buildCard('Total', totalPrestamos.toString(), Colors.blueGrey),
          _buildCard('Activos', totalPrestamosActivos.toString(), Colors.blue),
          _buildCard(
            'Finalizados',
            totalPrestamosFinalizados.toString(),
            Colors.green,
          ),
        ],
      ),
    );
  }

  Widget _buildCard(String titulo, String valor, Color? color) {
    return CardItem(
      alignment: CrossAxisAlignment.center,
      title: titulo,
      subtitle: valor,
      colortext: color,
      fontSizeTitle: 12,
      fontSizeSubtitle: 18,
      width: 100,
      height: 80,
    );
  }
}
