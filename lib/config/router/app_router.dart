import 'package:prestapagos/domain/domain.dart';
import 'package:prestapagos/presentation/screens/screens.dart';
import 'package:go_router/go_router.dart';

final appRouter = GoRouter(
  initialLocation: '/home/0',
  routes: [
    GoRoute(
      path: '/home/:page',
      name: HomeScreen.name,
      builder: (context, state) {
        final pageIndex = int.parse(state.pathParameters['page'] ?? '0');
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
  ],
);
