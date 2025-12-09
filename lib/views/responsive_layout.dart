import 'package:flutter/material.dart';
import '../models/cart.dart';
import '../styles/app_styles.dart';
import 'app_drawer.dart';
import 'order_screen.dart';
import 'cart_screen.dart';
import 'auth_screen.dart';

/// Responsive scaffold that adapts navigation based on screen width
/// Mobile/tablet: Standard drawer with hamburger menu
/// Desktop: Permanent NavigationRail on the left
class ResponsiveScaffold extends StatelessWidget {
  final PreferredSizeWidget appBar;
  final Widget body;
  final Cart cart;
  final String currentRoute;

  const ResponsiveScaffold({
    super.key,
    required this.appBar,
    required this.body,
    required this.cart,
    required this.currentRoute,
  });

  /// Calculate selected index for NavigationRail based on current route
  int _getSelectedIndex() {
    switch (currentRoute) {
      case '/':
      case '/home':
        return 0;
      case '/cart':
        return 1;
      case '/auth':
        return 2;
      case '/about':
        return 3;
      default:
        return 0;
    }
  }

  /// Handle navigation from NavigationRail (desktop layout)
  void _onDestinationSelected(BuildContext context, int index) {
    switch (index) {
      case 0: // Home
        if (currentRoute != '/' && currentRoute != '/home') {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const OrderScreen(),
            ),
            (route) => false,
          );
        }
        break;

      case 1: // My Cart
        if (cart.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Your cart is empty'),
              duration: Duration(seconds: 2),
            ),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CartScreen(cart: cart),
            ),
          );
        }
        break;

      case 2: // Account
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const AuthScreen(),
          ),
        );
        break;

      case 3: // About Us
        Navigator.pushNamed(context, '/about');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    // Breakpoint: 840px
    // Mobile/Tablet layout (< 840px): Standard drawer
    if (screenWidth < 840) {
      return Scaffold(
        appBar: appBar,
        drawer: AppDrawer(
          cart: cart,
          currentRoute: currentRoute,
        ),
        body: body,
      );
    }

    // Desktop layout (>= 840px): NavigationRail + content
    return Scaffold(
      appBar: appBar,
      body: Row(
        children: [
          // Permanent Navigation Rail
          Container(
            color: navigationRailBackground,
            child: NavigationRail(
              extended: true,
              selectedIndex: _getSelectedIndex(),
              onDestinationSelected: (index) =>
                  _onDestinationSelected(context, index),
              labelType: NavigationRailLabelType
                  .none, // Labels shown because extended: true
              destinations: [
                // Home
                const NavigationRailDestination(
                  icon: Icon(Icons.restaurant_menu),
                  label: Text('Home'),
                ),
                // My Cart (with badge)
                NavigationRailDestination(
                  icon: Badge(
                    label: Text(cart.countOfItems.toString()),
                    isLabelVisible: cart.countOfItems > 0,
                    child: const Icon(Icons.shopping_cart),
                  ),
                  label: const Text('My Cart'),
                ),
                // Account
                const NavigationRailDestination(
                  icon: Icon(Icons.account_circle),
                  label: Text('Account'),
                ),
                // About Us
                const NavigationRailDestination(
                  icon: Icon(Icons.info_outline),
                  label: Text('About Us'),
                ),
              ],
            ),
          ),

          // Vertical divider
          const VerticalDivider(
            thickness: 1,
            width: 1,
            color: dividerColor,
          ),

          // Main content area
          Expanded(
            child: body,
          ),
        ],
      ),
    );
  }
}
