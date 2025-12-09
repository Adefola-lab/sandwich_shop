import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/views/checkout_screen.dart';
import 'package:sandwich_shop/models/cart.dart';
import 'package:sandwich_shop/models/sandwich.dart';

void main() {
  group('CheckoutScreen', () {
    testWidgets('displays order summary title', (WidgetTester tester) async {
      final Cart cart = Cart();
      final Sandwich sandwich = Sandwich(
        type: SandwichType.veggieDelight,
        isFootlong: true,
        breadType: BreadType.white,
      );
      cart.add(sandwich, quantity: 1);

      final CheckoutScreen checkoutScreen = CheckoutScreen(cart: cart);
      final MaterialApp app = MaterialApp(
        home: checkoutScreen,
      );

      await tester.pumpWidget(app);

      expect(find.text('Checkout'), findsOneWidget);
      expect(find.text('Order Summary'), findsOneWidget);
    });

    testWidgets('displays single cart item correctly',
        (WidgetTester tester) async {
      final Cart cart = Cart();
      final Sandwich sandwich = Sandwich(
        type: SandwichType.veggieDelight,
        isFootlong: true,
        breadType: BreadType.white,
      );
      cart.add(sandwich, quantity: 2);

      final CheckoutScreen checkoutScreen = CheckoutScreen(cart: cart);
      final MaterialApp app = MaterialApp(
        home: checkoutScreen,
      );

      await tester.pumpWidget(app);

      expect(find.text('2x Veggie Delight'), findsOneWidget);
      expect(find.text('£22.00'), findsNWidgets(2)); // Item price and total
    });

    testWidgets('displays multiple cart items correctly',
        (WidgetTester tester) async {
      final Cart cart = Cart();
      final Sandwich sandwich1 = Sandwich(
        type: SandwichType.veggieDelight,
        isFootlong: true,
        breadType: BreadType.white,
      );
      final Sandwich sandwich2 = Sandwich(
        type: SandwichType.chickenTeriyaki,
        isFootlong: false,
        breadType: BreadType.wheat,
      );
      cart.add(sandwich1, quantity: 1);
      cart.add(sandwich2, quantity: 3);

      final CheckoutScreen checkoutScreen = CheckoutScreen(cart: cart);
      final MaterialApp app = MaterialApp(
        home: checkoutScreen,
      );

      await tester.pumpWidget(app);

      expect(find.text('1x Veggie Delight'), findsOneWidget);
      expect(find.text('3x Chicken Teriyaki'), findsOneWidget);
      expect(find.text('£11.00'), findsOneWidget);
      expect(find.text('£21.00'), findsOneWidget);
      expect(find.text('£32.00'), findsOneWidget); // Total
    });

    testWidgets('displays correct total price', (WidgetTester tester) async {
      final Cart cart = Cart();
      final Sandwich sandwich1 = Sandwich(
        type: SandwichType.veggieDelight,
        isFootlong: true,
        breadType: BreadType.white,
      );
      final Sandwich sandwich2 = Sandwich(
        type: SandwichType.chickenTeriyaki,
        isFootlong: false,
        breadType: BreadType.wheat,
      );
      cart.add(sandwich1, quantity: 1);
      cart.add(sandwich2, quantity: 2);

      final CheckoutScreen checkoutScreen = CheckoutScreen(cart: cart);
      final MaterialApp app = MaterialApp(
        home: checkoutScreen,
      );

      await tester.pumpWidget(app);

      expect(find.text('Total:'), findsOneWidget);
      expect(find.text('£25.00'), findsOneWidget);
      expect(find.text('£11.00'), findsOneWidget); // Veggie item price
      expect(find.text('£14.00'), findsOneWidget); // Chicken item price
    });

    testWidgets('displays payment method information',
        (WidgetTester tester) async {
      final Cart cart = Cart();
      final Sandwich sandwich = Sandwich(
        type: SandwichType.veggieDelight,
        isFootlong: true,
        breadType: BreadType.white,
      );
      cart.add(sandwich, quantity: 1);

      final CheckoutScreen checkoutScreen = CheckoutScreen(cart: cart);
      final MaterialApp app = MaterialApp(
        home: checkoutScreen,
      );

      await tester.pumpWidget(app);

      expect(find.text('Payment Method: Card ending in 1234'), findsOneWidget);
    });

    testWidgets('displays confirm payment button initially',
        (WidgetTester tester) async {
      final Cart cart = Cart();
      final Sandwich sandwich = Sandwich(
        type: SandwichType.veggieDelight,
        isFootlong: true,
        breadType: BreadType.white,
      );
      cart.add(sandwich, quantity: 1);

      final CheckoutScreen checkoutScreen = CheckoutScreen(cart: cart);
      final MaterialApp app = MaterialApp(
        home: checkoutScreen,
      );

      await tester.pumpWidget(app);

      expect(find.widgetWithText(ElevatedButton, 'Confirm Payment'),
          findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('shows loading indicator when processing payment',
        (WidgetTester tester) async {
      final Cart cart = Cart();
      final Sandwich sandwich = Sandwich(
        type: SandwichType.veggieDelight,
        isFootlong: true,
        breadType: BreadType.white,
      );
      cart.add(sandwich, quantity: 1);

      final CheckoutScreen checkoutScreen = CheckoutScreen(cart: cart);
      final MaterialApp app = MaterialApp(
        home: checkoutScreen,
      );

      await tester.pumpWidget(app);

      // Tap the confirm payment button
      final Finder confirmButton =
          find.widgetWithText(ElevatedButton, 'Confirm Payment');
      await tester.tap(confirmButton);
      await tester.pump();

      // Should show loading indicator and processing message
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Processing payment...'), findsOneWidget);
      expect(
          find.widgetWithText(ElevatedButton, 'Confirm Payment'), findsNothing);

      // Wait for the timer to complete to avoid pending timer error
      await tester.pumpAndSettle();
    });

    testWidgets('returns order confirmation after payment processing',
        (WidgetTester tester) async {
      final Cart cart = Cart();
      final Sandwich sandwich = Sandwich(
        type: SandwichType.veggieDelight,
        isFootlong: true,
        breadType: BreadType.white,
      );
      cart.add(sandwich, quantity: 2);

      Map<String, dynamic>? returnedData;

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => Scaffold(
              body: Center(
                child: ElevatedButton(
                  onPressed: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute<Map<String, dynamic>>(
                        builder: (context) => CheckoutScreen(cart: cart),
                      ),
                    );
                    if (result != null) {
                      returnedData = result;
                    }
                  },
                  child: const Text('Go to Checkout'),
                ),
              ),
            ),
          ),
        ),
      );

      // Navigate to checkout
      await tester.tap(find.text('Go to Checkout'));
      await tester.pumpAndSettle();

      // Tap confirm payment
      await tester.tap(find.widgetWithText(ElevatedButton, 'Confirm Payment'));
      await tester.pumpAndSettle();

      // Verify order confirmation data
      expect(returnedData, isNotNull);
      expect(returnedData!['orderId'], isNotNull);
      expect(returnedData!['orderId'], startsWith('ORD'));
      expect(returnedData!['totalAmount'], equals(22.0));
      expect(returnedData!['itemCount'], equals(2));
      expect(returnedData!['estimatedTime'], equals('15-20 minutes'));
    });

    testWidgets('displays divider between items and total',
        (WidgetTester tester) async {
      final Cart cart = Cart();
      final Sandwich sandwich = Sandwich(
        type: SandwichType.veggieDelight,
        isFootlong: true,
        breadType: BreadType.white,
      );
      cart.add(sandwich, quantity: 1);

      final CheckoutScreen checkoutScreen = CheckoutScreen(cart: cart);
      final MaterialApp app = MaterialApp(
        home: checkoutScreen,
      );

      await tester.pumpWidget(app);

      expect(find.byType(Divider), findsOneWidget);
    });

    testWidgets('calculates price correctly for six-inch sandwiches',
        (WidgetTester tester) async {
      final Cart cart = Cart();
      final Sandwich sandwich = Sandwich(
        type: SandwichType.chickenTeriyaki,
        isFootlong: false,
        breadType: BreadType.wheat,
      );
      cart.add(sandwich, quantity: 1);

      final CheckoutScreen checkoutScreen = CheckoutScreen(cart: cart);
      final MaterialApp app = MaterialApp(
        home: checkoutScreen,
      );

      await tester.pumpWidget(app);

      expect(find.text('1x Chicken Teriyaki'), findsOneWidget);
      expect(find.text('£7.00'), findsNWidgets(2)); // Item price and total
    });

    testWidgets('calculates price correctly for footlong sandwiches',
        (WidgetTester tester) async {
      final Cart cart = Cart();
      final Sandwich sandwich = Sandwich(
        type: SandwichType.veggieDelight,
        isFootlong: true,
        breadType: BreadType.white,
      );
      cart.add(sandwich, quantity: 1);

      final CheckoutScreen checkoutScreen = CheckoutScreen(cart: cart);
      final MaterialApp app = MaterialApp(
        home: checkoutScreen,
      );

      await tester.pumpWidget(app);

      expect(find.text('1x Veggie Delight'), findsOneWidget);
      expect(find.text('£11.00'), findsNWidgets(2)); // Item price and total
    });

    testWidgets(
        'displays correct total for multiple items with different sizes',
        (WidgetTester tester) async {
      final Cart cart = Cart();
      final Sandwich sandwich1 = Sandwich(
        type: SandwichType.veggieDelight,
        isFootlong: true,
        breadType: BreadType.white,
      );
      final Sandwich sandwich2 = Sandwich(
        type: SandwichType.chickenTeriyaki,
        isFootlong: false,
        breadType: BreadType.wheat,
      );
      final Sandwich sandwich3 = Sandwich(
        type: SandwichType.meatballMarinara,
        isFootlong: true,
        breadType: BreadType.wholemeal,
      );

      cart.add(sandwich1, quantity: 2);
      cart.add(sandwich2, quantity: 1);
      cart.add(sandwich3, quantity: 1);

      final CheckoutScreen checkoutScreen = CheckoutScreen(cart: cart);
      final MaterialApp app = MaterialApp(
        home: checkoutScreen,
      );

      await tester.pumpWidget(app);

      // 2x footlong veggie (£22) + 1x six-inch chicken (£7) + 1x footlong meatball (£11) = £40
      expect(find.text('Total:'), findsOneWidget);
      expect(find.text('£40.00'), findsOneWidget);
    });

    testWidgets('has proper layout structure', (WidgetTester tester) async {
      final Cart cart = Cart();
      final Sandwich sandwich = Sandwich(
        type: SandwichType.veggieDelight,
        isFootlong: true,
        breadType: BreadType.white,
      );
      cart.add(sandwich, quantity: 1);

      final CheckoutScreen checkoutScreen = CheckoutScreen(cart: cart);
      final MaterialApp app = MaterialApp(
        home: checkoutScreen,
      );

      await tester.pumpWidget(app);

      expect(find.byType(AppBar), findsOneWidget);
      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(Padding), findsAtLeastNWidgets(1));
      expect(find.byType(Column), findsAtLeastNWidgets(1));
    });

    testWidgets('order ID is unique for different orders',
        (WidgetTester tester) async {
      final Cart cart = Cart();
      final Sandwich sandwich = Sandwich(
        type: SandwichType.veggieDelight,
        isFootlong: true,
        breadType: BreadType.white,
      );
      cart.add(sandwich, quantity: 1);

      String? firstOrderId;

      // First order
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => Scaffold(
              body: Center(
                child: ElevatedButton(
                  onPressed: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute<Map<String, dynamic>>(
                        builder: (context) => CheckoutScreen(cart: cart),
                      ),
                    );
                    if (result != null) {
                      firstOrderId = result['orderId'] as String;
                    }
                  },
                  child: const Text('Go to Checkout'),
                ),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Go to Checkout'));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(ElevatedButton, 'Confirm Payment'));
      await tester.pumpAndSettle();

      expect(firstOrderId, isNotNull);

      // Small delay to ensure different timestamp
      await tester.pump(const Duration(milliseconds: 10));

      String? secondOrderId;

      // Second order
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => Scaffold(
              body: Center(
                child: ElevatedButton(
                  onPressed: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute<Map<String, dynamic>>(
                        builder: (context) => CheckoutScreen(cart: cart),
                      ),
                    );
                    if (result != null) {
                      secondOrderId = result['orderId'] as String;
                    }
                  },
                  child: const Text('Go to Checkout'),
                ),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Go to Checkout'));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(ElevatedButton, 'Confirm Payment'));
      await tester.pumpAndSettle();

      expect(firstOrderId, isNotNull);
      expect(secondOrderId, isNotNull);
      expect(firstOrderId, isNot(equals(secondOrderId)));
    });
  });
}
