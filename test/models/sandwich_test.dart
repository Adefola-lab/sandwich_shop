import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/models/sandwich.dart';

void main() {
  group('Sandwich.name', () {
    test('returns friendly name for veggieDelight', () {
      final s = Sandwich(
          type: SandwichType.veggieDelight,
          isFootlong: false,
          breadType: BreadType.white);
      expect(s.name, 'Veggie Delight');
    });

    test('returns friendly name for chickenTeriyaki', () {
      final s = Sandwich(
          type: SandwichType.chickenTeriyaki,
          isFootlong: true,
          breadType: BreadType.wheat);
      expect(s.name, 'Chicken Teriyaki');
    });

    test('returns friendly name for tunaMelt', () {
      final s = Sandwich(
          type: SandwichType.tunaMelt,
          isFootlong: false,
          breadType: BreadType.wheat);
      expect(s.name, 'Tuna Melt');
    });

    test('returns friendly name for meatballMarinara', () {
      final s = Sandwich(
          type: SandwichType.meatballMarinara,
          isFootlong: true,
          breadType: BreadType.wholemeal);
      expect(s.name, 'Meatball Marinara');
    });
  });

  group('Sandwich.image', () {
    test('builds path using enum name and size for all types and sizes', () {
      for (final type in SandwichType.values) {
        for (final isFootlong in [true, false]) {
          final s = Sandwich(
              type: type, isFootlong: isFootlong, breadType: BreadType.white);
          final expectedTypeString = type.name; // e.g. 'veggieDelight'
          final expectedSize = isFootlong ? 'footlong' : 'six_inch';
          final expectedPath =
              'assets/images/${expectedTypeString}_$expectedSize.png';
          expect(s.image, expectedPath);
        }
      }
    });
  });

  group('Sandwich fields', () {
    test('retains provided breadType and isFootlong values', () {
      final s = Sandwich(
          type: SandwichType.tunaMelt,
          isFootlong: false,
          breadType: BreadType.wholemeal);
      expect(s.breadType, BreadType.wholemeal);
      expect(s.isFootlong, false);
      expect(s.type, SandwichType.tunaMelt);
    });
  });
}
