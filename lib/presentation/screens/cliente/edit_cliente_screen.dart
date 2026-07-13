import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:prestapagos/domain/domain.dart';
import 'package:prestapagos/presentation/providers/clientes/clientes_provider.dart';
import 'package:prestapagos/presentation/providers/clientes/edit_cliente_form_provider.dart';
import 'package:prestapagos/presentation/providers/clientes/edit_cliente_provider.dart';
import 'package:prestapagos/presentation/widgets/widgets.dart';

class EditClienteScreen extends ConsumerStatefulWidget {
  static const name = 'edit-cliente';
  final String clienteId;
  const EditClienteScreen({super.key, required this.clienteId});

  @override
  ConsumerState<EditClienteScreen> createState() => _EditClienteScreenState();
}

class _EditClienteScreenState extends ConsumerState<EditClienteScreen> {
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _dniController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  bool _initialized = false;

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _dniController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _resetForm(WidgetRef ref) {
    ref.read(editClienteFormProvider.notifier).reset();
    ref.read(editClienteProvider.notifier).reset();
  }

  Future<void> _confirmarSalida(BuildContext context, WidgetRef ref) async {
    final salir = await confirmarAccion(
      context,
      mensaje: '¿Estás seguro de que quieres salir sin guardar los cambios?',
      textoConfirmar: 'Salir',
      esDestructivo: true,
    );
    if (salir && context.mounted) {
      _resetForm(ref);
      context.pop();
    }
  }

  void _syncControllersToProvider() {
    ref.read(editClienteFormProvider.notifier).onNameChanged(_nameController.text);
    ref.read(editClienteFormProvider.notifier).onAgeChanged(_ageController.text);
    ref.read(editClienteFormProvider.notifier).onDniChanged(_dniController.text);
    ref.read(editClienteFormProvider.notifier).onEmailChanged(_emailController.text);
    ref.read(editClienteFormProvider.notifier).onPhoneChanged(_phoneController.text);
    ref.read(editClienteFormProvider.notifier).onAddressChanged(_addressController.text);
  }

  Future<void> _confirmarCambio({
    required int clienteId,
    required DateTime fechaCreacion,
  }) async {
    final guardar = await confirmarAccion(
      context,
      mensaje: '¿Estás seguro de que quieres guardar los cambios?',
      textoConfirmar: 'Guardar',
    );
    if (guardar && context.mounted) {
      _syncControllersToProvider();
      ref.read(editClienteProvider.notifier).submit(clienteId, fechaCreacion);
    }
  }

  void _initControllers(Cliente cliente) {
    _nameController.text = cliente.nombre;
    _ageController.text = cliente.edad.toString();
    _dniController.text = cliente.dni;
    _emailController.text = cliente.email ?? '';
    _phoneController.text = cliente.telefono;
    _addressController.text = cliente.direccion;
  }

  @override
  Widget build(BuildContext context) {
    final id = int.parse(widget.clienteId);
    final clienteAsync = ref.watch(clienteProvider(id));

    return clienteAsync.when(
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (error, stackTrace) =>
          Scaffold(body: Center(child: Text('Error: $error'))),
      data: (cliente) {
        if (!_initialized) {
          _initControllers(cliente);
          _initialized = true;
          Future(() =>
              ref.read(editClienteFormProvider.notifier).loadFromCliente(cliente));
        }

        ref.listen(editClienteProvider, (previous, next) {
          if (previous?.isSuccess != true &&
              next.isSuccess &&
              context.mounted) {
            Fluttertoast.showToast(
              msg: 'Cliente actualizado exitosamente',
              gravity: ToastGravity.TOP,
              backgroundColor: Colors.green,
              textColor: Colors.white,
            );
            ref.invalidate(clienteProvider(id));
            ref.invalidate(clienteDetalleProvider(id));
            ref.read(clientePaginationProvider.notifier).refresh();
            ref.read(editClienteFormProvider.notifier).reset();
            context.pop();
          }
          if (next.errorMessage != null &&
              previous?.errorMessage != next.errorMessage &&
              context.mounted) {
            Fluttertoast.showToast(
              msg: next.errorMessage!,
              gravity: ToastGravity.TOP,
              backgroundColor: Colors.red,
              textColor: Colors.white,
            );
          }
        });

        final formState = ref.watch(editClienteFormProvider);
        final submitState = ref.watch(editClienteProvider);

        return PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, result) async {
            if (didPop) return;
            await _confirmarSalida(context, ref);
          },
          child: Scaffold(
            body: GestureDetector(
              onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
              child: CustomScrollView(
                slivers: [
                  SliverAppBar(
                    leading: IconButton(
                      icon: const Icon(Icons.arrow_back_ios),
                      onPressed: () => _confirmarSalida(context, ref),
                    ),
                    floating: true,
                    flexibleSpace: const FlexibleSpaceBar(
                      title: CustomAppbar(title: 'Editar cliente'),
                      titlePadding: EdgeInsets.only(left: 30.0),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: ClienteFormBody(
                      formState: formState,
                      nameController: _nameController,
                      ageController: _ageController,
                      dniController: _dniController,
                      emailController: _emailController,
                      phoneController: _phoneController,
                      addressController: _addressController,
                      onNameChanged: ref
                          .read(editClienteFormProvider.notifier)
                          .onNameChanged,
                      onAgeChanged: ref
                          .read(editClienteFormProvider.notifier)
                          .onAgeChanged,
                      onDniChanged: ref
                          .read(editClienteFormProvider.notifier)
                          .onDniChanged,
                      onEmailChanged: ref
                          .read(editClienteFormProvider.notifier)
                          .onEmailChanged,
                      onPhoneChanged: ref
                          .read(editClienteFormProvider.notifier)
                          .onPhoneChanged,
                      onAddressChanged: ref
                          .read(editClienteFormProvider.notifier)
                          .onAddressChanged,
                      onSubmit: () => _confirmarCambio(
                        clienteId: cliente.idDeudor,
                        fechaCreacion: cliente.fechaCreacion,
                      ),
                      onCancel: () => _confirmarSalida(context, ref),
                      isSubmitting: submitState.isSubmitting,
                      errorMessage: submitState.errorMessage,
                      buttonLabel: submitState.isSubmitting
                          ? 'Actualizando...'
                          : 'Actualizar',
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
