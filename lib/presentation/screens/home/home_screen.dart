import '../../views/views.dart';
import '../../widgets/widgets.dart';

import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  static const name = 'home-screen';
  final int pageIndex;

  const HomeScreen({
    //
    super.key,
    required this.pageIndex,
  });

  final viewRoutes = const <Widget>[
    //
    HomeView(),
    ClientesView(),
    PrestamosView(),
    ReportesView(),
    ConfigurationView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //
      body: IndexedStack(index: pageIndex, children: viewRoutes),
      bottomNavigationBar: CustomBottomNavigationbar(currentIndex: pageIndex),
    );
  }
}
