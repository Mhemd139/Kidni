import 'package:flutter_test/flutter_test.dart';

import 'package:kidni/main.dart';

void main() {
  testWidgets('App loads smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const KidniApp());
    await tester.pumpAndSettle();

    // Verify the app title is displayed
    expect(find.text('קידני'), findsOneWidget);
  });
}
