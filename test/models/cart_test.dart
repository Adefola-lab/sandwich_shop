import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/models/cart.dart';
import 'package:sandwich_shop/models/sandwich.dart';

void main() {
  group('Cart', () {
    late Cart cart;
    late Sandwich veggie;
    late Sandwich tuna;

    setUp(() {
      cart = Cart();
      veggie = Sandwich(
        type: SandwichType.veggieDelight,
        isFootlong: false,
        breadType: BreadType.white,
      );
      tuna = Sandwich(
        type: SandwichType.tunaMelt,
        isFootlong: true,
        breadType: BreadType.wheat,
      );
    });

    test('starts empty', () {
      expect(cart.totalItems, equals(0));
      expect(cart.uniqueItems, equals(0));
      expect(cart.items, isEmpty);
      expect(cart.totalPrice, equals(0.0));
    });

    test('adding a sandwich increases item count and totalItems', () {
      cart.addSandwich(veggie);
      expect(cart.totalItems, equals(1));
      expect(cart.items.isNotEmpty, isTrue);

      final entry = cart.items.firstWhere((e) => identical(e.sandwich, veggie));
      expect(entry.quantity, equals(1));
    });

    test('adding same sandwich increases totalItems by quantity', () {
      cart.addSandwich(veggie);
      cart.addSandwich(veggie, 2); // total should become 3
      expect(cart.totalItems, equals(3));

      final entry = cart.items.firstWhere((e) => identical(e.sandwich, veggie));
      expect(entry.quantity, equals(3));
    });

    test('updateQuantity changes quantity and zero removes item', () {
      cart.addSandwich(tuna, 1);

      // derive the id the cart uses (fallback is hashCode.toString())
      final tunaId = tuna.hashCode.toString();

      cart.updateQuantity(tunaId, 5);
      // find the entry for tuna and confirm quantity
      final entryAfterUpdate =
          cart.items.firstWhere((e) => identical(e.sandwich, tuna));
      expect(entryAfterUpdate.quantity, equals(5));
      expect(cart.totalItems, equals(5));

      // updating to 0 should remove the item
      cart.updateQuantity(tunaId, 0);
      final containsTuna = cart.items.any((e) => identical(e.sandwich, tuna));
      expect(containsTuna, isFalse);
      expect(cart.totalItems, equals(0));
      expect(cart.totalPrice, equals(0.0));
    });

    test('removeSandwichById removes the item and updates totals', () {
      cart.addSandwich(veggie, 2);
      cart.addSandwich(tuna, 1);

      final veggieId = veggie.hashCode.toString();
      final beforeTotal = cart.totalItems;

      cart.removeSandwichById(veggieId);
      final stillHasVeggie =
          cart.items.any((e) => identical(e.sandwich, veggie));
      expect(stillHasVeggie, isFalse);
      expect(cart.totalItems, lessThanOrEqualTo(beforeTotal - 1));
    });

    test('clear empties the cart', () {
      cart.addSandwich(veggie);
      cart.addSandwich(tuna);
      expect(cart.items.isNotEmpty, isTrue);

      cart.clear();
      expect(cart.items, isEmpty);
      expect(cart.totalItems, equals(0));
      expect(cart.totalPrice, equals(0.0));
    });

    test('totalPrice increases after adding items and resets after clear', () {
      expect(cart.totalPrice, equals(0.0));
      cart.addSandwich(veggie, 2);
      expect(cart.totalPrice > 0.0, isTrue);

      cart.clear();
      expect(cart.totalPrice, equals(0.0));
    });
  });
}
