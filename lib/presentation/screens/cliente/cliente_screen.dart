import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:prestapagos/presentation/providers/clientes/clientes_provider.dart';
import 'package:prestapagos/presentation/widgets/clientes/clientes_profile.dart';
import 'package:prestapagos/presentation/widgets/shared/custom_appbar.dart';
import 'package:prestapagos/presentation/widgets/shared/loading_widget_custom.dart';

class ClienteScreen extends ConsumerWidget {
  static const name = 'cliente-profile';
  final String clienteId;

  const ClienteScreen({super.key, required this.clienteId});

  @override
  Widget build(BuildContext context, ref) {
    final id = int.parse(clienteId);
    final detalleAsync = ref.watch(clienteDetalleProvider(id));

    return Scaffold(
      body: detalleAsync.when(
        loading: () => const LoadingWidgetCustom(mensaje: 'Cargando perfil...'),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (detalle) => CustomScrollView(
          slivers: [
            SliverAppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios),
                onPressed: () => context.pop(),
              ),
              floating: true,
              flexibleSpace: const FlexibleSpaceBar(
                title: CustomAppbar(title: 'Perfil Cliente'),
                titlePadding: EdgeInsets.only(left: 30.0),
              ),
            ),
            SliverToBoxAdapter(
              child: ClientesProfile(
                detalle: detalle,
                onEdit: () => _editarCliente(context, detalle.cliente.idDeudor),
                onDelete: () => _eliminarCliente(context, detalle.cliente.idDeudor),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _editarCliente(BuildContext context, int idDeudor) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Editar cliente $idDeudor')),
    );
  }

  void _eliminarCliente(BuildContext context, int idDeudor) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Eliminar cliente $idDeudor')),
    );
  }
}