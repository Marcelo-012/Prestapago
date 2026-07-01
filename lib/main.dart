import 'package:flutter/material.dart';

import 'package:prestapagos/config/router/app_router.dart';

import 'package:prestapagos/config/theme/app_theme.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
      theme: AppTheme().getLightTheme(),
      darkTheme: AppTheme().getDarkTheme(),
      themeMode: ThemeMode.system,
    );
  }
}
