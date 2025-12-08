import 'package:flutter/material.dart';
import 'package:sandwich_shop/views/app_styles.dart';
import 'package:sandwich_shop/views/order_screen.dart';
import 'package:sandwich_shop/models/cart.dart';
import 'package:sandwich_shop/models/sandwich.dart';
import 'package:sandwich_shop/repositories/pricing_repository.dart';

class CartScreen extends StatefulWidget {
  final Cart cart;

  const CartScreen({super.key, required this.cart});

  @override
  State<CartScreen> createState() {
    return _CartScreenState();
  }
}

class _CartScreenState extends State<CartScreen> {
  void _goBack() {
    Navigator.pop(context);
  }

  String _getSizeText(bool isFootlong) {
    if (isFootlong) {
      return 'Footlong';
    } else {
      return 'Six-inch';
    }
  }

  double _getItemPrice(Sandwich sandwich, int quantity) {
    final PricingRepository pricingRepository = PricingRepository();
    return pricingRepository.calculatePrice(
      quantity: quantity,
      isFootlong: sandwich.isFootlong,
    );
  }

  Future<bool> _showRemoveItemDialog() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Remove Item?'),
          content: const Text('Remove this item from your cart?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Remove'),
            ),
          ],
        );
      },
    );
    return result ?? false;
  }

  Future<bool> _showClearCartDialog() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Clear Cart?'),
          content: const Text('Are you sure you want to clear your cart?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Clear'),
            ),
          ],
        );
      },
    );
    return result ?? false;
  }

  void _increaseQuantity(Sandwich sandwich) {
    setState(() {
      widget.cart.add(sandwich, quantity: 1);
    });
  }

  Future<void> _decreaseQuantity(Sandwich sandwich, int currentQuantity) async {
    // If this is the last item, show confirmation dialog
    if (currentQuantity == 1) {
      final confirmed = await _showRemoveItemDialog();
      if (!confirmed) {
        return; // User cancelled, don't remove
      }
    }

    setState(() {
      widget.cart.remove(sandwich, quantity: 1);
    });
  }

  Future<void> _removeItem(Sandwich sandwich) async {
    final confirmed = await _showRemoveItemDialog();
    if (!confirmed) {
      return; // User cancelled
    }

    setState(() {
      // Remove entire item by removing all quantity
      final currentQuantity = widget.cart.getQuantity(sandwich);
      widget.cart.remove(sandwich, quantity: currentQuantity);
    });
  }

  Future<void> _clearCart() async {
    final confirmed = await _showClearCartDialog();
    if (!confirmed) {
      return; // User cancelled
    }

    setState(() {
      widget.cart.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            height: 100,
            child: Image.asset('assets/images/logo.png'),
          ),
        ),
        title: const Text(
          'Cart View',
          style: heading1,
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),
                if (widget.cart.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Text(
                      'Your cart is empty',
                      style: heading2,
                      textAlign: TextAlign.center,
                    ),
                  ),
                if (widget.cart.isEmpty == false)
                  for (MapEntry<Sandwich, int> entry
                      in widget.cart.items.entries)
                    Card(
                      margin: const EdgeInsets.only(bottom: 16.0),
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Text(entry.key.name, style: heading2),
                            const SizedBox(height: 4),
                            Text(
                              '${_getSizeText(entry.key.isFootlong)} on ${entry.key.breadType.name} bread',
                              style: normalText,
                            ),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.remove),
                                  onPressed: () =>
                                      _decreaseQuantity(entry.key, entry.value),
                                  tooltip: 'Decrease quantity',
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: Text(
                                    'Qty: ${entry.value}',
                                    style: normalText,
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.add),
                                  onPressed: () => _increaseQuantity(entry.key),
                                  tooltip: 'Increase quantity',
                                ),
                                const SizedBox(width: 16),
                                IconButton(
                                  icon: const Icon(Icons.delete_outline,
                                      color: Colors.red),
                                  onPressed: () => _removeItem(entry.key),
                                  tooltip: 'Remove item',
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '£${_getItemPrice(entry.key, entry.value).toStringAsFixed(2)}',
                              style: heading2,
                            ),
                          ],
                        ),
                      ),
                    ),
                if (widget.cart.isEmpty == false) const SizedBox(height: 8),
                if (widget.cart.isEmpty == false)
                  Text(
                    'Total: £${widget.cart.totalPrice.toStringAsFixed(2)}',
                    style: heading2,
                    textAlign: TextAlign.center,
                  ),
                if (widget.cart.isEmpty == false) const SizedBox(height: 20),
                if (widget.cart.isEmpty == false)
                  StyledButton(
                    onPressed: _clearCart,
                    icon: Icons.remove_shopping_cart,
                    label: 'Clear Cart',
                    backgroundColor: Colors.red,
                  ),
                if (widget.cart.isEmpty == false) const SizedBox(height: 20),
                StyledButton(
                  onPressed: _goBack,
                  icon: Icons.arrow_back,
                  label: 'Back to Order',
                  backgroundColor: Colors.grey,
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
