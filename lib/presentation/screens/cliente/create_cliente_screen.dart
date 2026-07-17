import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:prestapagos/presentation/providers/providers.dart';
import 'package:prestapagos/presentation/widgets/widgets.dart';

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
        Fluttertoast.showToast(
          msg: 'Cliente creado exitosamente',
          gravity: ToastGravity.TOP,
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );
        ref.read(createClienteFormProvider.notifier).reset();
        ref.read(clientePaginationProvider.notifier).refresh();
        context.pop();
      }
      if (next.errorMessage != null && prev?.errorMessage != next.errorMessage && context.mounted) {
        Fluttertoast.showToast(
          msg: next.errorMessage!,
          gravity: ToastGravity.TOP,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
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
