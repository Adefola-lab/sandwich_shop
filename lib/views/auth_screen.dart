import 'package:flutter/material.dart';
import '../models/cart.dart';
import 'responsive_layout.dart';
import 'package:sandwich_shop/views/app_styles.dart';

enum AuthMode { signIn, signUp }

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  AuthMode _authMode = AuthMode.signIn;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _toggleMode(Set<AuthMode> newMode) {
    if (newMode.isNotEmpty) {
      setState(() {
        _authMode = newMode.first;
        // Clear all fields when switching modes
        _nameController.clear();
        _emailController.clear();
        _phoneController.clear();
        _passwordController.clear();
        _confirmPasswordController.clear();
        // Reset form validation state
        _formKey.currentState?.reset();
      });
    }
  }

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Name is required';
    }
    if (value.length < 2) {
      return 'Name must be at least 2 characters';
    }
    // Check if name contains only letters and spaces
    if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
      return 'Name can only contain letters and spaces';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    // Email validation regex
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  String? _validatePhone(String? value) {
    // Phone is optional, so empty is valid
    if (value == null || value.isEmpty) {
      return null;
    }
    // Remove common formatting characters
    String digitsOnly = value.replaceAll(RegExp(r'[\s\-\(\)]'), '');
    // Check if it contains only digits
    if (!RegExp(r'^\d+$').hasMatch(digitsOnly)) {
      return 'Please enter a valid phone number';
    }
    // Check minimum length
    if (digitsOnly.length < 10) {
      return 'Please enter a valid phone number (at least 10 digits)';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    // Check for at least one letter and one number
    bool hasLetter = RegExp(r'[a-zA-Z]').hasMatch(value);
    bool hasNumber = RegExp(r'[0-9]').hasMatch(value);
    if (!hasLetter || !hasNumber) {
      return 'Password must contain at least one letter and one number';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != _passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  void _handleSubmit() {
    // Validate the form
    if (_formKey.currentState!.validate()) {
      // Extract user name for success message
      String userName;
      String successMessage;

      if (_authMode == AuthMode.signUp) {
        // Use the full name entered by user
        userName = _nameController.text.trim();
        successMessage = 'Account created successfully! Welcome, $userName';
      } else {
        // Extract name from email (text before @)
        String email = _emailController.text.trim();
        String emailPrefix = email.split('@')[0];
        // Capitalize first letter
        userName = emailPrefix[0].toUpperCase() + emailPrefix.substring(1);
        successMessage = 'Welcome back, $userName!';
      }

      // Navigate back to Order Screen first
      Navigator.pop(context);

      // Show success message on Order Screen
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(successMessage),
          duration: const Duration(seconds: 3),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  String get _screenTitle {
    return _authMode == AuthMode.signIn ? 'Sign In' : 'Sign Up';
  }

  String get _submitButtonLabel {
    return _authMode == AuthMode.signIn ? 'Sign In' : 'Create Account';
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveScaffold(
      appBar: AppBar(
        title: Text(_screenTitle, style: heading1),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Mode Toggle
                SegmentedButton<AuthMode>(
                  segments: const [
                    ButtonSegment<AuthMode>(
                      value: AuthMode.signIn,
                      label: Text('Sign In'),
                      icon: Icon(Icons.login),
                    ),
                    ButtonSegment<AuthMode>(
                      value: AuthMode.signUp,
                      label: Text('Sign Up'),
                      icon: Icon(Icons.person_add),
                    ),
                  ],
                  selected: {_authMode},
                  onSelectionChanged: _toggleMode,
                ),
                const SizedBox(height: 24),

                // Full Name Field (Sign-Up only)
                if (_authMode == AuthMode.signUp) ...[
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Full Name',
                      hintText: 'Enter your full name',
                      prefixIcon: Icon(Icons.person),
                      border: OutlineInputBorder(),
                    ),
                    style: normalText,
                    textCapitalization: TextCapitalization.words,
                    validator: _validateName,
                  ),
                  const SizedBox(height: 16),
                ],

                // Email Field (Both modes)
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    hintText: 'Enter your email address',
                    prefixIcon: Icon(Icons.email),
                    border: OutlineInputBorder(),
                  ),
                  style: normalText,
                  keyboardType: TextInputType.emailAddress,
                  autocorrect: false,
                  validator: _validateEmail,
                ),
                const SizedBox(height: 16),

                // Phone Field (Sign-Up only)
                if (_authMode == AuthMode.signUp) ...[
                  TextFormField(
                    controller: _phoneController,
                    decoration: const InputDecoration(
                      labelText: 'Phone Number (Optional)',
                      hintText: 'Enter your phone number',
                      prefixIcon: Icon(Icons.phone),
                      border: OutlineInputBorder(),
                    ),
                    style: normalText,
                    keyboardType: TextInputType.phone,
                    validator: _validatePhone,
                  ),
                  const SizedBox(height: 16),
                ],

                // Password Field (Both modes)
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    hintText: 'Enter your password',
                    prefixIcon: Icon(Icons.lock),
                    border: OutlineInputBorder(),
                  ),
                  style: normalText,
                  obscureText: true,
                  autocorrect: false,
                  enableSuggestions: false,
                  validator: _validatePassword,
                ),
                const SizedBox(height: 16),

                // Confirm Password Field (Sign-Up only)
                if (_authMode == AuthMode.signUp) ...[
                  TextFormField(
                    controller: _confirmPasswordController,
                    decoration: const InputDecoration(
                      labelText: 'Confirm Password',
                      hintText: 'Re-enter your password',
                      prefixIcon: Icon(Icons.lock_outline),
                      border: OutlineInputBorder(),
                    ),
                    style: normalText,
                    obscureText: true,
                    autocorrect: false,
                    enableSuggestions: false,
                    validator: _validateConfirmPassword,
                  ),
                  const SizedBox(height: 24),
                ] else
                  const SizedBox(height: 24),

                // Submit Button
                ElevatedButton(
                  onPressed: _handleSubmit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    textStyle: normalText,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(_authMode == AuthMode.signIn
                          ? Icons.login
                          : Icons.person_add),
                      const SizedBox(width: 8),
                      Text(_submitButtonLabel),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      cart: Cart(),
      currentRoute: '/auth',
    );
  }
}
