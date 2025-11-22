import 'package:sandwich_shop/models/sandwich.dart';
import 'package:sandwich_shop/repositories/pricing_repository.dart';

class Cart {
  final PricingRepository pricingRepository;
  final Map<String, _CartItem> _items = {};

  Cart({required this.pricingRepository});

  // Add a sandwich to the cart. If it already exists, increase quantity.
  void addSandwich(Sandwich sandwich, [int quantity = 1]) {
    if (quantity <= 0) return;
    final id = _idFor(sandwich);
    final existing = _items[id];
    if (existing != null) {
      existing.quantity += quantity;
    } else {
      _items[id] = _CartItem(sandwich, quantity);
    }
  }

  // Remove a sandwich entirely from the cart by sandwich id.
  void removeSandwichById(String sandwichId) {
    _items.remove(sandwichId);
  }

  // Set an exact quantity for a sandwich. If quantity <= 0 it removes the item.
  void updateQuantity(String sandwichId, int quantity) {
    if (quantity <= 0) {
      _items.remove(sandwichId);
      return;
    }
    final item = _items[sandwichId];
    if (item != null) {
      item.quantity = quantity;
    }
  }

  // Get quantity for a specific sandwich id.
  int getQuantity(String sandwichId) => _items[sandwichId]?.quantity ?? 0;

  // Total number of items (sum of quantities).
  int get totalItems => _items.values.fold(0, (sum, it) => sum + it.quantity);

  // Number of distinct sandwiches in the cart.
  int get uniqueItems => _items.length;

  // Calculate total price using PricingRepository as the single source of truth.
  double get totalPrice => _items.values.fold(
      0.0,
      (sum, it) =>
          sum + pricingRepository.calculatePrice(it.sandwich, it.quantity));

  // List of cart items (read-only copy).
  List<CartEntry> get items =>
      _items.values.map((it) => CartEntry(it.sandwich, it.quantity)).toList();

  // Clear the cart.
  void clear() => _items.clear();

  // Basic serialization: map of sandwichId -> quantity.
  Map<String, int> toMap() =>
      Map.fromEntries(_items.entries.map((e) => MapEntry(e.key, e.value.quantity)));

  // Helper to derive an id for a Sandwich. Tries sandwich.id, falls back to hashCode.
  String _idFor(Sandwich sandwich) {
    try {
      final dynamic d = sandwich;
      final id = d.id;
      if (id != null) return id.toString();
    } catch (_) {}
    return sandwich.hashCode.toString();
  }
}

// Internal mutable cart item.
class _CartItem {
  final Sandwich sandwich;
  int quantity;
  _CartItem(this.sandwich, this.quantity);
}

// Public lightweight view for consumers.
class CartEntry {
  final Sandwich sandwich;
  final int quantity;
  CartEntry(this.sandwich, this.quantity);
}