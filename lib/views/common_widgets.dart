import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandwich_shop/models/cart.dart';
import 'package:sandwich_shop/views/cart_screen.dart';
import 'package:sandwich_shop/views/profile_screen.dart';

/// Common AppBar used across all screens
class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final bool showBackButton;

  const CommonAppBar({
    super.key,
    required this.title,
    this.actions,
    this.showBackButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      automaticallyImplyLeading: showBackButton,
      backgroundColor: Colors.orange,
      actions: actions ??
          [
            const CartIndicator(),
            const SizedBox(width: 8),
          ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

/// Cart indicator showing item count and total price
class CartIndicator extends StatelessWidget {
  const CartIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<Cart>(
      builder: (BuildContext context, Cart cart, Widget? child) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            IconButton(
              icon: Stack(
                children: <Widget>[
                  const Icon(Icons.shopping_cart),
                  if (cart.countOfItems > 0)
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: Text(
                          '${cart.countOfItems}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) => const CartScreen(),
                  ),
                );
              },
            ),
            Text(
              '£${cart.totalPrice.toStringAsFixed(2)}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ],
        );
      },
    );
  }
}

/// Bottom navigation bar for main app navigation
class CommonBottomNavigationBar extends StatelessWidget {
  final int currentIndex;

  const CommonBottomNavigationBar({
    super.key,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (int index) {
        // Don't navigate if already on the screen
        if (index == currentIndex) return;

        switch (index) {
          case 0: // Order Screen
            Navigator.popUntil(context, (route) => route.isFirst);
            break;
          case 1: // Cart Screen
            Navigator.pushReplacement(
              context,
              MaterialPageRoute<void>(
                builder: (BuildContext context) => const CartScreen(),
              ),
            );
            break;
          case 2: // Profile Screen
            Navigator.push(
              context,
              MaterialPageRoute<Map<String, String>?>(
                builder: (BuildContext context) => const ProfileScreen(),
              ),
            );
            break;
        }
      },
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_bag),
          label: 'Order',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_cart),
          label: 'Cart',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
    );
  }
}

/// Styled button used throughout the app
class StyledButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final IconData icon;
  final String label;
  final Color backgroundColor;

  const StyledButton({
    super.key,
    required this.onPressed,
    required this.icon,
    required this.label,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

/// Common section header used in forms and lists
class SectionHeader extends StatelessWidget {
  final String text;
  final double fontSize;

  const SectionHeader({
    super.key,
    required this.text,
    this.fontSize = 18,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

/// Common padding wrapper for screen content
class ScreenPadding extends StatelessWidget {
  final Widget child;

  const ScreenPadding({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: child,
    );
  }
}

/// Utility function to show consistent snackbars
void showAppSnackBar(
  BuildContext context,
  String message, {
  Duration duration = const Duration(seconds: 2),
  Color? backgroundColor,
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      duration: duration,
      backgroundColor: backgroundColor,
    ),
  );
}
