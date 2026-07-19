import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:prestapagos/domain/domain.dart';
import 'package:prestapagos/presentation/providers/providers.dart';
import 'package:prestapagos/presentation/widgets/widgets.dart';

class ClienteScreen extends ConsumerStatefulWidget {
  static const name = 'cliente-profile';
  final String clienteId;

  const ClienteScreen({super.key, required this.clienteId});

  @override
  ConsumerState<ClienteScreen> createState() => _ClienteScreenState();
}

class _ClienteScreenState extends ConsumerState<ClienteScreen> {
  int get _id => int.parse(widget.clienteId);

  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.invalidate(clienteDetalleProvider(_id)));
  }

  @override
  Widget build(BuildContext context) {
    final id = _id;
    final detalleAsync = ref.watch(clienteDetalleProvider(id));

    return Scaffold(
      body: detalleAsync.when(
        loading: () => const FullScreenLoader(),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (detalle) => _buildUI(detalle),
      ),
    );
  }

  Widget _buildUI(ClienteDetalle detalle) {
    return CustomScrollView(
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
            onReactivate: detalle.cliente.estado == 'inactivo'
                ? () => _reactivarCliente(context, detalle.cliente)
                : null,
          ),
        ),
      ],
    );
  }

  void _editarCliente(BuildContext context, int idDeudor) {
    context.push('/edit-cliente/$idDeudor');
  }

  Future<void> _eliminarCliente(BuildContext context, int idDeudor) async {
    final repository = ref.read(clienteRepositoryProvider);
    final totalPrestamos = await repository.countRelatedRecords(idDeudor);
    final activeLoans = await repository.hasActiveLoans(idDeudor);

    if (!context.mounted) return;

    if (totalPrestamos == 0) {
      final eliminar = await confirmarAccion(
        context,
        titulo: 'Eliminar cliente',
        mensaje: '¿Eliminar este cliente? Esta acción no se puede deshacer.',
        textoConfirmar: 'Eliminar',
        esDestructivo: true,
      );
      if (!eliminar || !context.mounted) return;

      await ref.read(deleteClienteProvider.notifier).deleteCliente(idDeudor);

      if (!context.mounted) return;
      final deleteState = ref.read(deleteClienteProvider);
      if (deleteState.isSuccess) {
        Fluttertoast.showToast(
          msg: 'Cliente eliminado',
          gravity: ToastGravity.TOP,
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );
      } else if (deleteState.errorMessage != null) {
        Fluttertoast.showToast(
          msg: deleteState.errorMessage!,
          gravity: ToastGravity.TOP,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
      context.pop();
    } else if (activeLoans) {
      await confirmarAccion(
        context,
        titulo: 'Cliente con préstamos activos',
        mensaje:
            'El cliente tiene $totalPrestamos préstamo${totalPrestamos == 1 ? '' : 's'} registrado${totalPrestamos == 1 ? '' : 's'} '
            'con préstamos activos.\n\n'
            'No se puede desactivar hasta que todos sus préstamos estén finalizados o cancelados.',
        textoConfirmar: 'Entendido',
      );
    } else {
      final desactivar = await confirmarAccion(
        context,
        titulo: 'Cliente con historial',
        mensaje:
            'Este cliente tiene $totalPrestamos préstamo${totalPrestamos == 1 ? '' : 's'} registrado${totalPrestamos == 1 ? '' : 's'}. '
            'Por seguridad, no se puede eliminar un cliente con historial.\n\n'
            '¿Deseas desactivarlo en su lugar?',
        textoConfirmar: 'Desactivar',
        esDestructivo: true,
      );
      if (!desactivar || !context.mounted) return;

      await ref.read(deleteClienteProvider.notifier).deactivateCliente(idDeudor);
      if (!context.mounted) return;
      final deleteState = ref.read(deleteClienteProvider);
      if (deleteState.isSuccess) {
        Fluttertoast.showToast(
          msg: 'Cliente desactivado',
          gravity: ToastGravity.TOP,
          backgroundColor: Colors.orange,
          textColor: Colors.white,
        );
      } else if (deleteState.errorMessage != null) {
        Fluttertoast.showToast(
          msg: deleteState.errorMessage!,
          gravity: ToastGravity.TOP,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
    }
  }

  Future<void> _reactivarCliente(BuildContext context, Cliente cliente) async {
    final reactivar = await confirmarAccion(
      context,
      titulo: 'Reactivar cliente',
      mensaje: '¿Estás seguro de reactivar a "${cliente.nombre}"?',
      textoConfirmar: 'Reactivar',
    );
    if (!reactivar || !context.mounted) return;

    await ref.read(deleteClienteProvider.notifier).reactivateCliente(_id);
    if (!context.mounted) return;
    final deleteState = ref.read(deleteClienteProvider);
    if (deleteState.isSuccess) {
      Fluttertoast.showToast(
        msg: 'Cliente reactivado',
        gravity: ToastGravity.TOP,
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );
    } else if (deleteState.errorMessage != null) {
      Fluttertoast.showToast(
        msg: deleteState.errorMessage!,
        gravity: ToastGravity.TOP,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }
}
