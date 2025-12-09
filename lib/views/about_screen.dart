import 'package:flutter/material.dart';
import '../models/cart.dart';
import 'responsive_layout.dart';
import 'package:sandwich_shop/views/app_styles.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveScaffold(
      appBar: AppBar(
        title: const Text('About Us', style: heading1),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Welcome to Sandwich Shop!', style: heading2),
              SizedBox(height: 20),
              Text(
                'We are a family-owned business dedicated to serving the best sandwiches in town. ',
                style: normalText,
              ),
              // Add more content here as needed
            ],
          ),
        ),
      ),
      cart: Cart(),
      currentRoute: '/about',
    );
  }
}
