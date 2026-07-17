import 'package:flutter/material.dart';
//import 'package:prestapagos/config/helpers/human_formats.dart';
import 'package:prestapagos/presentation/widgets/shared/shared.dart';

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
      padding: const EdgeInsets.all(8),
      child: Wrap(
        spacing: 3,
        runSpacing: 5,
        children: [
          _buildCard('Total', totalPrestamos.toString(), Colors.blueGrey),
          _buildCard('Activos', totalPrestamosActivos.toString(), Colors.blue),
          _buildCard(
            'Liquidados',
            totalPrestamosFinalizados.toString(),
            Colors.green,
          ),
        ],
      ),
    );
  }

  Widget _buildCard(String titulo, String valor, Color? color) {
    return SizedBox(
      width: 110,
      height: 100,
      child: CardItem(
        alignment: CrossAxisAlignment.center,
        title: titulo,
        subtitle: valor,
        colortext: color,
        fontSizeTitle: 14,
        fontSizeSubtitle: 20,
      ),
    );
  }
}
