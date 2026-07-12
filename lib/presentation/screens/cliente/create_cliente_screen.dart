import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:prestapagos/presentation/providers/clientes/create_cliente_form_provider.dart';
import 'package:prestapagos/presentation/providers/clientes/create_cliente_provider.dart';
import 'package:prestapagos/presentation/widgets/clientes/cliente_form_body.dart';
import 'package:prestapagos/presentation/widgets/shared/confirm_exit_dialog.dart';
import 'package:prestapagos/presentation/widgets/shared/custom_appbar.dart';

class CreateClienteScreen extends ConsumerWidget {
  static const name = 'create-cliente';
  const CreateClienteScreen({super.key});

  void _resetForm(WidgetRef ref) {
    ref.read(createClienteFormProvider.notifier).reset();
    ref.read(createClienteProvider.notifier).reset();
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formState = ref.watch(createClienteFormProvider);
    final submitState = ref.watch(createClienteProvider);

    ref.listen(createClienteProvider, (prev, next) {
      if (prev?.isSuccess != true && next.isSuccess && context.mounted) {
        ref.read(createClienteFormProvider.notifier).reset();
        context.pop();
      }
    });

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
                  title: CustomAppbar(title: 'Nuevo cliente'),
                  titlePadding: EdgeInsets.only(left: 30.0),
                ),
              ),
              SliverToBoxAdapter(
                child: ClienteFormBody(
                  formState: formState,
                  onNameChanged: ref
                      .read(createClienteFormProvider.notifier)
                      .onNameChanged,
                  onAgeChanged: ref
                      .read(createClienteFormProvider.notifier)
                      .onAgeChanged,
                  onDniChanged: ref
                      .read(createClienteFormProvider.notifier)
                      .onDniChanged,
                  onEmailChanged: ref
                      .read(createClienteFormProvider.notifier)
                      .onEmailChanged,
                  onPhoneChanged: ref
                      .read(createClienteFormProvider.notifier)
                      .onPhoneChanged,
                  onAddressChanged: ref
                      .read(createClienteFormProvider.notifier)
                      .onAddressChanged,
                  onSubmit: () =>
                      ref.read(createClienteProvider.notifier).submit(),
                  onCancel: () => _confirmarSalida(context, ref),
                  isSubmitting: submitState.isSubmitting,
                  errorMessage: submitState.errorMessage,
                  buttonLabel: submitState.isSubmitting
                      ? 'Creando...'
                      : 'Crear',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
