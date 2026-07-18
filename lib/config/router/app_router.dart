import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:prestapagos/domain/domain.dart';
import 'package:prestapagos/presentation/providers/providers.dart';
import 'package:prestapagos/presentation/screens/screens.dart';

class GoRouterRefreshNotifier extends ChangeNotifier {
  GoRouterRefreshNotifier(Ref ref) {
    ref.listen(authSkippedProvider, (_, _) => notifyListeners());
    ref.listen(accountProvider, (_, _) => notifyListeners());
    ref.listen(termsAcceptedProvider, (_, _) => notifyListeners());
  }
}

final routerProvider = Provider<GoRouter>((ref) {
  final refreshNotifier = GoRouterRefreshNotifier(ref);
  ref.onDispose(refreshNotifier.dispose);

  return GoRouter(
    initialLocation: '/home/0',
    refreshListenable: refreshNotifier,
    routes: [
      GoRoute(
        path: '/terms',
        name: TermsScreen.name,
        builder: (context, state) => const TermsScreen(),
      ),
      GoRoute(
        path: '/login',
        name: LoginScreen.name,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/home/:page',
        name: HomeScreen.name,
        builder: (context, state) {
          final pageIndex = int.tryParse(state.pathParameters['page'] ?? '') ?? 0;
          return HomeScreen(pageIndex: pageIndex);
        },
        routes: [
          GoRoute(
            path: '/cliente/:id',
            name: ClienteScreen.name,
            builder: (context, state) {
              final clienteId = state.pathParameters['id'] ?? 'no-id';
              return ClienteScreen(clienteId: clienteId);
            },
          ),
          GoRoute(
            path: '/prestamo/:id',
            name: PrestamoScreen.name,
            builder: (context, state) {
              final prestamoId = state.pathParameters['id'] ?? 'no-id';
              return PrestamoScreen(prestamoId: prestamoId);
            },
          ),
        ],
      ),
      GoRoute(
        path: '/create-cliente',
        name: CreateClienteScreen.name,
        builder: (context, state) => const CreateClienteScreen(),
      ),
      GoRoute(
        path: '/edit-cliente/:id',
        name: EditClienteScreen.name,
        builder: (context, state) {
          final clienteId = state.pathParameters['id'] ?? 'no-id';
          return EditClienteScreen(clienteId: clienteId);
        },
      ),
      GoRoute(
        path: '/create-prestamo',
        name: CreatePrestamoScreen.name,
        builder: (context, state) {
          final cliente = state.extra as ClienteResumen?;
          return CreatePrestamoScreen(clientePreSeleccionado: cliente);
        },
      ),
      GoRoute(
        path: '/prestamo/preview',
        name: PrestamoPreviewScreen.name,
        builder: (context, state) => const PrestamoPreviewScreen(),
      ),
      GoRoute(
        path: '/ajustes/apariencia',
        name: AppearanceScreen.name,
        builder: (context, state) => const AppearanceScreen(),
      ),
      GoRoute(
        path: '/ajustes/respaldo',
        name: BackupScreen.name,
        builder: (context, state) => const BackupScreen(),
      ),
      GoRoute(
        path: '/ajustes/aviso-privacidad',
        builder: (context, state) => const TermsScreen(readOnly: true),
      ),
    ],
    redirect: (context, state) {
      final authSkipped = ref.read(authSkippedProvider);
      final accountState = ref.read(accountProvider);
      final termsAccepted = ref.read(termsAcceptedProvider);

      final shouldShowLogin = !authSkipped && !accountState.isLinked;

      if (!termsAccepted) {
        if (state.matchedLocation != '/terms') return '/terms';
        return null;
      }
      if (shouldShowLogin) {
        if (state.matchedLocation != '/login') return '/login';
        return null;
      }
      if (state.matchedLocation == '/terms' || state.matchedLocation == '/login') {
        return '/home/0';
      }
      return null;
    },
  );
});
