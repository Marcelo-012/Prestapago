import 'package:flutter/material.dart';
import 'package:prestapagos/presentation/providers/clientes/create_cliente_form_provider.dart';
import 'package:prestapagos/shared/widget/custom_text_form_field.dart';

class ClienteFormBody extends StatelessWidget {
  final CreateClienteFormState formState;
  final ValueChanged<String> onNameChanged;
  final ValueChanged<String> onAgeChanged;
  final ValueChanged<String> onDniChanged;
  final ValueChanged<String> onEmailChanged;
  final ValueChanged<String> onPhoneChanged;
  final ValueChanged<String> onAddressChanged;
  final VoidCallback onSubmit;
  final VoidCallback onCancel;
  final bool isSubmitting;
  final String? errorMessage;
  final String buttonLabel;
  final TextEditingController? nameController;
  final TextEditingController? ageController;
  final TextEditingController? dniController;
  final TextEditingController? emailController;
  final TextEditingController? phoneController;
  final TextEditingController? addressController;

  const ClienteFormBody({
    super.key,
    required this.formState,
    required this.onNameChanged,
    required this.onAgeChanged,
    required this.onDniChanged,
    required this.onEmailChanged,
    required this.onPhoneChanged,
    required this.onAddressChanged,
    required this.onSubmit,
    required this.onCancel,
    required this.isSubmitting,
    this.errorMessage,
    required this.buttonLabel,
    this.nameController,
    this.ageController,
    this.dniController,
    this.emailController,
    this.phoneController,
    this.addressController,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        children: [
          const SizedBox(height: 30),
          CircleAvatar(
            radius: 30,
            backgroundColor: colors.primary,
            child: (formState.name.value != '')
                ? Text(
                    formState.name.value[0].toUpperCase(),
                    style: const TextStyle(color: Colors.white70),
                  )
                : const Icon(Icons.person, color: Colors.white70),
          ),

          const SizedBox(height: 30),
          CustomTextFormField(
            label: 'Nombre completo',
            keyboardType: TextInputType.name,
            controller: nameController,
            onChanged: onNameChanged,
            errorMessage: formState.name.errorMessage,
          ),

          const SizedBox(height: 30),
          CustomTextFormField(
            label: 'Edad',
            keyboardType: TextInputType.number,
            controller: ageController,
            onChanged: onAgeChanged,
            errorMessage: formState.age.errorMessage,
          ),

          const SizedBox(height: 30),
          CustomTextFormField(
            label: 'Número de Identidad (CURP/DNI)',
            keyboardType: TextInputType.text,
            textCapitalization: TextCapitalization.characters,
            controller: dniController,
            onChanged: onDniChanged,
            errorMessage: formState.dni.errorMessage,
          ),

          const SizedBox(height: 30),
          CustomTextFormField(
            label: 'Correo (opcional)',
            keyboardType: TextInputType.emailAddress,
            controller: emailController,
            onChanged: onEmailChanged,
            errorMessage: formState.email.errorMessage,
          ),

          const SizedBox(height: 30),
          CustomTextFormField(
            label: 'Teléfono',
            keyboardType: TextInputType.number,
            controller: phoneController,
            onChanged: onPhoneChanged,
            errorMessage: formState.phone.errorMessage,
          ),

          const SizedBox(height: 30),
          CustomTextFormField(
            label: 'Dirección',
            controller: addressController,
            onChanged: onAddressChanged,
            errorMessage: formState.address.errorMessage,
          ),

          const SizedBox(height: 30),

          if (errorMessage != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Text(errorMessage!, style: TextStyle(color: colors.error)),
            ),

          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 60,
                  //Boton Guardar
                  child: FilledButton.icon(
                    label: Text(buttonLabel),
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(
                        Colors.green[400],
                      ),
                    ),
                    icon: isSubmitting
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.save),
                    onPressed: (isSubmitting || !formState.isFormValid)
                        ? null
                        : onSubmit,
                  ),
                ),
              ),
              const SizedBox(width: 30),
              Expanded(
                child: SizedBox(
                  height: 60,
                  //boton cancelar
                  child: FilledButton.icon(
                    label: const Text('Cancelar'),
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(colors.error),
                    ),
                    icon: const Icon(Icons.cancel_outlined),
                    onPressed: isSubmitting ? null : onCancel,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
