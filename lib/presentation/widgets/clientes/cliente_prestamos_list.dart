import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prestapagos/config/helpers/helpers.dart';
import 'package:prestapagos/domain/domain.dart';

class ClientePrestamosList extends StatelessWidget {
  final List<PrestamoResumen> prestamos;
  final int idDeudor;
  final String nombreDeudor;
  final String estadoCliente;

  const ClientePrestamosList({
    super.key,
    required this.prestamos,
    required this.idDeudor,
    required this.nombreDeudor,
    required this.estadoCliente,
  });

  void _onNuevoPrestamo(BuildContext context) {
    if (estadoCliente == 'inactivo') {
      Fluttertoast.showToast(
        msg: 'No se puede crear un préstamo para un cliente inactivo',
        gravity: ToastGravity.TOP,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return;
    }
    context.push(
      '/create-prestamo',
      extra: ClienteResumen(
        idDeudor: idDeudor,
        nombre: nombreDeudor,
        telefono: '',
        estado: '',
        score: 0,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final activos = prestamos;

    if (activos.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Sin préstamos registrados', style: GoogleFonts.poppins()),
              const SizedBox(height: 16),
              FilledButton.icon(
                label: const Text('Nuevo préstamo'),
                onPressed: () => _onNuevoPrestamo(context),
                icon: const Icon(Icons.add_card_outlined),
              ),
            ],
          ),
        ));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Préstamos',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              FilledButton.icon(
                label: const Text('Nuevo préstamo'),
                onPressed: () => _onNuevoPrestamo(context),
                icon: const Icon(Icons.add_card_outlined),
              ),
            ],
          ),
        ),
        ...activos.map((loan) => _buildLoanItem(loan, context)),
      ],
    );
  }

  Widget _buildLoanItem(PrestamoResumen prestamo, BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Préstamo #${prestamo.idPrestamo}',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                TextButton(
                  onPressed: () => context.push(
                    '/home/1/prestamo/${prestamo.idPrestamo}',
                  ),
                  child: const Text('Ver detalles'),
                ),
              ],
            ),
            const Divider(),
            const SizedBox(height: 8),
            _BuildData(
              monto: prestamo.monto,
              fechaCreacion: prestamo.fechaCreacion,
              estado: prestamo.estadoPrestamo,
              plazo: prestamo.plazo,
              cuota: prestamo.cuota,
              totalPagado: prestamo.totalPagado,
              tasaInteres: prestamo.tasaInteres,
              fechaActualizacion: prestamo.fechaActualizacion,
            ),
          ],
        ),
      ),
    );
  }
}

class _BuildData extends StatelessWidget {
  final double monto;
  final DateTime fechaCreacion;
  final String estado;
  final int plazo;
  final double cuota;
  final double totalPagado;
  final double tasaInteres;
  final DateTime? fechaActualizacion;

  const _BuildData({
    required this.monto,
    required this.fechaCreacion,
    required this.estado,
    required this.plazo,
    required this.cuota,
    required this.totalPagado,
    required this.tasaInteres,
    this.fechaActualizacion,
  });

  @override
  Widget build(BuildContext context) {
    final noActivo = estado.toLowerCase() != 'activo';

    final poppins = GoogleFonts.poppins();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Creado: ${HumanFormats.date(fechaCreacion)}',
                style: poppins,
              ),
              Chip(
                label: Text(
                  estado[0].toUpperCase() + estado.substring(1),
                  style: GoogleFonts.poppins(fontSize: 11, color: Colors.white),
                ),
                backgroundColor: _colorEstado(),
                padding: const EdgeInsets.symmetric(horizontal: 4),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ],
          ),
          if (noActivo && fechaActualizacion != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(
                '${_estadoLabel(estado)}: ${HumanFormats.date(fechaActualizacion!)}',
                style: poppins,
              ),
            ),
          const SizedBox(height: 4),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                Text(HumanFormats.monuted(monto), style: poppins),
                const SizedBox(width: 5),
                const Icon(Icons.circle, size: 5, color: Colors.grey),
                const SizedBox(width: 5),
                Text('$plazo mes(es)', style: poppins),
                const SizedBox(width: 5),
                const Icon(Icons.circle, size: 5, color: Colors.grey),
                const SizedBox(width: 5),
                Text('${tasaInteres.toStringAsFixed(2)}%', style: poppins),
              ],
            ),
          ),
          const SizedBox(height: 4),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                Text('Cuota: ${HumanFormats.monuted(cuota)}', style: poppins),
                const SizedBox(width: 10),
                const Icon(Icons.circle, size: 5, color: Colors.grey),
                const SizedBox(width: 10),
                Text(
                  'Pagado: ${HumanFormats.monuted(totalPagado)}',
                  style: poppins,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _colorEstado() {
    switch (estado.toLowerCase()) {
      case 'activo':
        return Colors.blueAccent;
      case 'finalizado':
        return Colors.green;
      case 'cancelado':
        return Colors.red;
      case 'atrasado':
        return Colors.orange;
      case 'inactivo':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  String _estadoLabel(String estado) {
    switch (estado.toLowerCase()) {
      case 'finalizado':
        return 'Finalizado';
      case 'cancelado':
        return 'Cancelado';
      case 'atrasado':
        return 'Atrasado';
      case 'inactivo':
        return 'Inactivado';
      default:
        return 'Actualizado';
    }
  }
}
