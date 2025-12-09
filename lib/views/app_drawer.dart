import 'package:flutter/material.dart';
import '../models/cart.dart';
import '../styles/app_styles.dart';
import 'order_screen.dart';
import 'cart_screen.dart';
import 'auth_screen.dart';

/// Reusable navigation drawer for the entire app
/// Displays navigation menu items and handles routing
class AppDrawer extends StatelessWidget {
  final Cart cart;
  final String currentRoute;

  const AppDrawer({
    super.key,
    required this.cart,
    required this.currentRoute,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // Drawer Header with App Branding
          const DrawerHeader(
            decoration: BoxDecoration(
              color: drawerHeaderBackground,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.storefront,
                  size: drawerHeaderIconSize,
                  color: primaryColor,
                ),
                SizedBox(height: 12),
                Text(
                  'Sandwich Shop',
                  style: heading1,
                ),
                SizedBox(height: 4),
                Text(
                  'Fresh & Delicious',
                  style: drawerSubtitle,
                ),
              ],
            ),
          ),

          // Home Navigation Item
          ListTile(
            leading: const Icon(Icons.restaurant_menu),
            title: const Text('Home'),
            selected: currentRoute == '/' || currentRoute == '/home',
            selectedTileColor:
                Theme.of(context).primaryColor.withValues(alpha: 0.1),
            onTap: () {
              // Close drawer first
              Navigator.pop(context);

              // Only navigate if not already on home screen
              if (currentRoute != '/' && currentRoute != '/home') {
                // Clear navigation stack and go to home
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const OrderScreen(),
                  ),
                  (route) => false,
                );
              }
            },
          ),

          // My Cart Navigation Item
          ListTile(
            leading: Badge(
              label: Text(cart.countOfItems.toString()),
              isLabelVisible: cart.countOfItems > 0,
              child: const Icon(Icons.shopping_cart),
            ),
            title: const Text('My Cart'),
            selected: currentRoute == '/cart',
            selectedTileColor:
                Theme.of(context).primaryColor.withValues(alpha: 0.1),
            onTap: () {
              // Close drawer first
              Navigator.pop(context);

              // Check if cart is empty
              if (cart.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Your cart is empty'),
                    duration: Duration(seconds: 2),
                  ),
                );
              } else {
                // Navigate to cart screen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CartScreen(cart: cart),
                  ),
                );
              }
            },
          ),

          // Account Navigation Item
          ListTile(
            leading: const Icon(Icons.account_circle),
            title: const Text('Account'),
            selected: currentRoute == '/auth',
            selectedTileColor:
                Theme.of(context).primaryColor.withValues(alpha: 0.1),
            onTap: () {
              // Close drawer first
              Navigator.pop(context);

              // Navigate to auth screen
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AuthScreen(),
                ),
              );
            },
          ),

          // About Us Navigation Item
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('About Us'),
            selected: currentRoute == '/about',
            selectedTileColor:
                Theme.of(context).primaryColor.withValues(alpha: 0.1),
            onTap: () {
              // Close drawer first
              Navigator.pop(context);

              // Navigate to about screen using named route
              Navigator.pushNamed(context, '/about');
            },
          ),
        ],
      ),
    );
  }
}
