import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/repositories/price_repository.dart';

void main() {
  group('PriceRepository', () {
    test('initial price should be 0', () {
      final repository = PriceRepository();
      expect(repository.calculateTotalPrice('six-inch', 0), 0);
    });

    test('1 six-inch should be 7.00', () {
      final repository = PriceRepository();
      expect(repository.calculateTotalPrice('six-inch', 1), 7.00);
    });

    test('1 footlong should be 11.00', () {
      final repository = PriceRepository();
      expect(repository.calculateTotalPrice('footlong', 1), 11.00);
    });
  });
}
