import 'package:flutter_test/flutter_test.dart';

import 'package:prestapagos/main.dart';

void main() {
  testWidgets('App renders home screen', (WidgetTester tester) async {
    await tester.pumpWidget(const MainApp());

    expect(find.text('Home Screen'), findsOneWidget);
    expect(find.text('Welcome'), findsOneWidget);
  });
}
