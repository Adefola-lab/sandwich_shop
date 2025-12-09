import 'package:flutter/material.dart';
import 'package:sandwich_shop/styles/app_styles.dart';
import 'package:sandwich_shop/views/order_screen.dart';
import 'package:sandwich_shop/views/about_screen.dart';

void main() {
  runApp(const SandwichShopApp());
}

class SandwichShopApp extends StatelessWidget {
  const SandwichShopApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sandwich Shop',
      theme: appTheme,
      home: const OrderScreen(),
      routes: {
        '/about': (context) => const AboutScreen(),
      },
    );
  }
}
