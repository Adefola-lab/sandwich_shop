import 'package:flutter/material.dart';
import 'package:sandwich_shop/views/app_styles.dart';
import 'package:sandwich_shop/views/order_screen.dart';
import 'package:sandwich_shop/models/cart.dart';
import 'package:sandwich_shop/models/sandwich.dart';
import 'package:sandwich_shop/repositories/pricing_repository.dart';
import 'package:sandwich_shop/views/checkout_screen.dart';
import 'package:sandwich_shop/views/responsive_layout.dart';

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
    return ResponsiveScaffold(
      appBar: AppBar(
        title: const Text('My Cart'),
      ),
      body: widget.cart.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Your cart is empty',
                    style: TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Back to Order'),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16.0),
                    itemCount: widget.cart.items.length,
                    itemBuilder: (context, index) {
                      final entry = widget.cart.items.entries.elementAt(index);
                      return Card(
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
                                    onPressed: () => _decreaseQuantity(
                                        entry.key, entry.value),
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
                                    onPressed: () =>
                                        _increaseQuantity(entry.key),
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
                      );
                    },
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Total: £${widget.cart.totalPrice.toStringAsFixed(2)}',
                  style: heading2,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                StyledButton(
                  onPressed: _clearCart,
                  icon: Icons.remove_shopping_cart,
                  label: 'Clear Cart',
                  backgroundColor: Colors.red,
                ),
                const SizedBox(height: 20),
                StyledButton(
                  onPressed: _navigateToCheckout,
                  icon: Icons.payment,
                  label: 'Checkout',
                  backgroundColor: Colors.orange,
                ),
                const SizedBox(height: 20),
                StyledButton(
                  onPressed: _goBack,
                  icon: Icons.arrow_back,
                  label: 'Back to Order',
                  backgroundColor: Colors.grey,
                ),
                const SizedBox(height: 20),
              ],
            ),
      cart: widget.cart,
      currentRoute: '/cart',
    );
  }

  Future<void> _navigateToCheckout() async {
    if (widget.cart.items.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Your cart is empty'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CheckoutScreen(cart: widget.cart),
      ),
    );

    if (result != null && mounted) {
      setState(() {
        widget.cart.clear();
      });

      final String orderId = result['orderId'] as String;
      final String estimatedTime = result['estimatedTime'] as String;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text('Order $orderId confirmed! Estimated time: $estimatedTime'),
          duration: const Duration(seconds: 4),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context);
    }
  }
}
