import 'package:flutter/material.dart';

class FullScreenLoader extends StatelessWidget {
  final List<String> messages;

  const FullScreenLoader({super.key, this.messages = _defaultMessages});

  static const _defaultMessages = [
    'Cargando recursos...',
    'Preparando todo para ti...',
    'Esto no tomará mucho tiempo...',
    'Estamos casi listos...',
    'Gracias por tu paciencia...',
    'Casi hemos terminado...',
    'Checa tu internet mientras tanto...',
    'Esto esta tardando un poco más de lo esperado :(',
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
