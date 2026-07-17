import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prestapagos/config/helpers/helpers.dart';
import 'package:prestapagos/domain/domain.dart';
import 'package:prestapagos/presentation/providers/providers.dart';
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
    final totalInteres = amortizaciones.fold<double>(0.0, (sum, a) => sum + a.montoInteres);

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
              title: CustomAppbar(title: 'Visualizar préstamo'),
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
                          ResumenRow(label: 'Cliente', value: client?.nombre ?? '—'),
                          ResumenRow(label: 'Monto', value: HumanFormats.monuted(double.tryParse(formState.monto.value) ?? 0)),
                          ResumenRow(label: 'Plazo', value: '${formState.plazo.value} meses'),
                          ResumenRow(label: 'Tasa interés', value: '${formState.tasaInteres.value}% ${formState.periodidadIntereses == 'mensual' ? 'mensual' : 'anual'}'),
                          ResumenRow(label: 'Cuota mensual', value: HumanFormats.monuted(double.tryParse(formState.montoCuota.value) ?? 0)),
                          if (formState.estadoMoratorio == 'activo')
                            ResumenRow(label: 'Tasa moratoria', value: '${formState.tasaInteresMoratoria.value}% ${formState.periodidadIntereses == 'mensual' ? 'mensual' : 'anual'}'),
                          ResumenRow(label: 'Intereses', value: HumanFormats.monuted(totalInteres)),
                          const Divider(),
                          ResumenRow(label: 'Monto + Intereses', value: HumanFormats.monuted(total)),
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
        DataCell(Text(HumanFormats.monuted(a.montoCapital + a.montoInteres))),
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
    if (!state.isFormValid) return;
    try {
      final dto = state.toDTO(amortizaciones: amortizaciones);
      final idPrestamo = await ref.read(prestamoRepositoryProvider).createPrestamo(dto);
      if (!context.mounted) return;
      Fluttertoast.showToast(msg: 'Préstamo creado exitosamente', gravity: ToastGravity.TOP);
      ref.read(createPrestamoFormProvider.notifier).reset();
      ref.invalidate(prestamoPaginationProvider);
      context.go('/home/1/prestamo/$idPrestamo');
    } catch (e) {
      if (!context.mounted) return;
      Fluttertoast.showToast(msg: 'Error al crear el préstamo', gravity: ToastGravity.TOP);
    }
  }
}
