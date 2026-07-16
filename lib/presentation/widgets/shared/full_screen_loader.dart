import 'package:flutter/material.dart';

class FullScreenLoader extends StatelessWidget {
  final List<String> messages;

  const FullScreenLoader({super.key, this.messages = _defaultMessages});

  static const _defaultMessages = [
    'Conectando con tus servicios...',
    'Preparando tus datos...',
    'Esto tomará solo un momento...',
    'Estamos casi listos...',
    'Un paso más...',
    '¡Todo listo!',
  ];

  Stream<String> getLoadingMessages() {
    return Stream.periodic(const Duration(milliseconds: 1200), (step) {
      return messages[step % messages.length];
    }).take(messages.length);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white.withValues(alpha: .90),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Espere por favor...'),
            const SizedBox(height: 10),
            const CircularProgressIndicator(),
            const SizedBox(height: 10),
            StreamBuilder(
              stream: getLoadingMessages(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const Text('Cargando...');

                return Text(snapshot.data!);
              },
            ),
          ],
        ),
      ),
    );
  }
}
