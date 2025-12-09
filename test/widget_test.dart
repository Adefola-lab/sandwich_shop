import 'package:flutter_test/flutter_test.dart';

import 'package:sandwich_shop/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const SandwichShopApp());

    // Verify that the app starts with OrderScreen
    expect(find.text('Order Your Sandwich'), findsOneWidget);
  });
}
