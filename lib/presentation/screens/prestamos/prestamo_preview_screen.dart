import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prestapagos/config/helpers/human_formats.dart';
import 'package:prestapagos/domain/entities/dtos/prestamos/create_amortizacion_dto.dart';
import 'package:prestapagos/presentation/providers/prestamos/create_prestamo_form_provider.dart';
import 'package:prestapagos/presentation/providers/prestamos/prestamo_provider.dart';
import 'package:prestapagos/presentation/widgets/widgets.dart';

class PrestamoPreviewScreen extends ConsumerWidget {
  static const name = 'prestamo-preview';
  const PrestamoPreviewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formState = ref.watch(createPrestamoFormProvider);
    final client = formState.selectedClient;
    final amortizaciones = formState.calcularAmortizaciones();
    final total = amortizaciones.fold<double>(0.0, (sum, a) => sum + a.montoCapital + a.montoInteres);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () => context.pop(),
            ),
            floating: true,
            flexibleSpace: const FlexibleSpaceBar(
              title: CustomAppbar(title: 'Revisar préstamo'),
              titlePadding: EdgeInsets.only(left: 30.0),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Resumen', style: GoogleFonts.poppins(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 12),
                          _resumenRow('Cliente', client?.nombre ?? '—'),
                          _resumenRow('Monto', HumanFormats.monuted(double.tryParse(formState.monto.value) ?? 0)),
                          _resumenRow('Plazo', '${formState.plazo.value} meses'),
                          _resumenRow('Tasa interés', '${formState.tasaInteres.value}% ${formState.periodidadIntereses == 'mensual' ? 'mensual' : 'anual'}'),
                          _resumenRow('Cuota mensual', HumanFormats.monuted(double.tryParse(formState.montoCuota.value) ?? 0)),
                          if (formState.estadoMoratorio == 'activo')
                            _resumenRow('Tasa moratoria', '${formState.tasaInteresMoratoria.value}% ${formState.periodidadIntereses == 'mensual' ? 'mensual' : 'anual'}'),
                          _resumenRow('Capital + Intereses', HumanFormats.monuted(total)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text('Amortizaciones', style: GoogleFonts.poppins(
                    fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columnSpacing: 16,
                      columns: const [
                        DataColumn(label: Text('#')),
                        DataColumn(label: Text('Vencimiento')),
                        DataColumn(label: Text('Cuota')),
                        DataColumn(label: Text('Capital')),
                        DataColumn(label: Text('Interés')),
                        DataColumn(label: Text('Saldo')),
                      ],
                      rows: _buildAmortizacionRows(amortizaciones),
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: () => _crearPrestamo(context, ref, formState, amortizaciones),
                      icon: const Icon(Icons.save),
                      label: const Text('Crear préstamo', style: TextStyle(fontSize: 16)),
                      style: FilledButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _resumenRow(String label, String value) {
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

  List<DataRow> _buildAmortizacionRows(List<CreateAmortizacionDTO> list) {
    double saldo = double.parse(
      (list as List).isNotEmpty
          ? (list.first.montoCapital + list.first.montoInteres).toString()
          : '0',
    );

    return list.map<DataRow>((a) {
      return DataRow(cells: [
        DataCell(Text('${a.idCuota}')),
        DataCell(Text('${a.fechaVencimiento.day}/${a.fechaVencimiento.month}/${a.fechaVencimiento.year}')),
        DataCell(Text(HumanFormats.monuted(a.montoInicial))),
        DataCell(Text(HumanFormats.monuted(a.montoCapital))),
        DataCell(Text(HumanFormats.monuted(a.montoInteres))),
        DataCell(Text(HumanFormats.monuted(saldo))),
      ]);
    }).toList();
  }

  void _crearPrestamo(
    BuildContext context,
    WidgetRef ref,
    state,
    List amortizaciones,
  ) async {
    try {
      final dto = state.toDTO(amortizaciones: amortizaciones);
      final idPrestamo = await ref.read(prestamoRepositoryProvider).createPrestamo(dto);
      if (!context.mounted) return;
      Fluttertoast.showToast(msg: 'Préstamo creado exitosamente', gravity: ToastGravity.TOP);
      ref.read(createPrestamoFormProvider.notifier).reset();
      ref.invalidate(prestamoPaginationProvider);
      context.go('/prestamo/$idPrestamo');
    } catch (e) {
      if (!context.mounted) return;
      Fluttertoast.showToast(msg: 'Error al crear el préstamo', gravity: ToastGravity.TOP);
    }
  }
}
