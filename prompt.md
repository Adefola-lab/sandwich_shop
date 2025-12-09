# Feature Request: Cart Item Modification

I have a Flutter sandwich shop app with two main screens:
1. **Order Screen**: Users select sandwiches and add them to their cart
2. **Cart Screen**: Users view cart items and total price

## Current Implementation

### Models
- **Sandwich**: Contains `type` (enum), `isFootlong` (bool), and `breadType` (enum)
- **Cart**: Contains a `Map<Sandwich, int>` of items with quantities, and methods:
  - `add(Sandwich sandwich, {int quantity = 1})` - adds items to cart
  - `remove(Sandwich sandwich, {int quantity = 1})` - reduces quantity or removes item
  - `clear()` - clears entire cart
  - `totalPrice` - calculates total using PricingRepository
  - `getQuantity(Sandwich sandwich)` - returns quantity for a specific sandwich

### Repository
- **PricingRepository**: Has `calculatePrice({required int quantity, required bool isFootlong})` method
  - Six-inch sandwiches cost £7.00 each
  - Footlong sandwiches cost £11.00 each
  - Sandwich type and bread type do NOT affect price

### Current Cart Screen UI
The cart currently displays items in a simple vertical list with:
- Sandwich name (e.g., "Tuna Melt", "Chicken Teriyaki")
- Size and bread type (e.g., "Footlong on white bread")
- Quantity and item total price (e.g., "Qty: 2 - £22.00")
- Overall cart total at the bottom (e.g., "Total: £44.00")
- A "Back to Order" button to return to the order screen

**Note**: The current UI shows duplicate entries for the same sandwich (e.g., two separate "Chicken Teriyaki" entries). This happens because different Sandwich objects with the same properties are treated as different map keys. The modification UI should work with this current behavior.

## Requested Feature: Cart Modification UI

I need to enhance the Cart Screen by adding interactive controls that allow users to modify items in their cart. Implement the following three modification features:

### 1. Change Item Quantity
**Description**: Users should be able to increase or decrease the quantity of any item in their cart using intuitive +/- buttons.

**User Action**: 
- User taps a plus (+) icon button to increase quantity by 1
- User taps a minus (-) icon button to decrease quantity by 1

**Expected Behavior**:
- When plus button is tapped: quantity increases by 1, item price and total update automatically
- When minus button is tapped: 
  - If quantity > 1: quantity decreases by 1, item price and total update automatically
  - If quantity = 1: show a confirmation dialog first, then remove the item from cart entirely if confirmed
- The quantity controls should be displayed horizontally in a row: `[-] Qty: X [+]`
- Both the item price and cart total price should update immediately after any quantity change
- Use `setState()` to trigger UI rebuild after modification

**UI Layout Suggestion**:
- Display the +/- buttons on the same line as the quantity text
- Use `IconButton` widgets with `Icons.remove` and `Icons.add`
- Make buttons small and visually distinct

### 2. Remove Item Entirely
**Description**: Users should be able to remove an entire item (all quantities) from their cart at once with a delete button.

**User Action**: 
- User taps a delete/trash icon button displayed next to each cart item

**Expected Behavior**:
- Display a confirmation dialog with title "Remove Item?" and message "Remove this item from your cart?"
- Dialog should have "Cancel" and "Remove" buttons
- If user confirms: remove the entire item from cart (all quantities), update total price
- If user cancels: no changes are made, dialog closes
- Use `setState()` to trigger UI rebuild after removal

**UI Layout Suggestion**:
- Place the delete icon button (`Icons.delete` or `Icons.delete_outline`) aligned to the right of each item
- Consider using a contrasting color (e.g., red) for the delete icon to make it clear

### 3. Clear Entire Cart
**Description**: Users should be able to empty their entire cart with one action via a prominent button.

**User Action**: 
- User taps a "Clear Cart" button displayed below the cart items (above the "Back to Order" button)

**Expected Behavior**:
- Display a confirmation dialog with title "Clear Cart?" and message "Are you sure you want to clear your cart?"
- Dialog should have "Cancel" and "Clear" buttons
- If user confirms: call `cart.clear()` to remove all items, show "Your cart is empty" message
- If user cancels: no changes are made, dialog closes
- The "Clear Cart" button should only be visible when `cart.isEmpty == false`
- After clearing, display an empty state message instead of the cart items list
- Use `setState()` to trigger UI rebuild after clearing

**UI Layout Suggestion**:
- Add a styled button (similar to "Back to Order" button) with red/destructive color scheme
- Position it between the cart total and "Back to Order" button
- Use `Icons.remove_shopping_cart` as the button icon

### 4. Empty Cart State
**Description**: When the cart is empty, display a friendly message instead of an empty list.

**Expected Behavior**:
- If `cart.isEmpty == true`, show centered text: "Your cart is empty"
- Hide the total price display when cart is empty
- Hide the "Clear Cart" button when cart is empty
- Keep the "Back to Order" button visible so users can add items

## Implementation Requirements

1. Modify the `_CartScreenState` class in `cart_screen.dart` to add these UI controls
2. Each cart item should display:
   - Sandwich name (heading2 style) - already implemented
   - Size and bread description (normalText style) - already implemented
   - **NEW**: A row with minus button, quantity text with price, and plus button
   - **NEW**: A delete button positioned to the right/top of the item
3. Add a "Clear Cart" button below the total price, above "Back to Order"
4. Use Material Design icons:
   - `Icons.add` for increase quantity
   - `Icons.remove` for decrease quantity
   - `Icons.delete` or `Icons.delete_outline` for remove item
   - `Icons.remove_shopping_cart` for clear cart button
5. Create reusable methods for confirmation dialogs:
   - `_showRemoveItemDialog(Sandwich sandwich)` - returns Future<bool>
   - `_showClearCartDialog()` - returns Future<bool>
6. Create handler methods for user actions:
   - `_increaseQuantity(Sandwich sandwich)`
   - `_decreaseQuantity(Sandwich sandwich)`
   - `_removeItem(Sandwich sandwich)`
   - `_clearCart()`
7. Ensure the UI rebuilds immediately after changes using `setState()`
8. When cart is empty, conditionally render empty state UI
9. Maintain consistent styling with existing app (use `app_styles.dart` styles and `StyledButton` for major actions)
10. Consider wrapping each cart item in a `Card` or `Container` with padding for better visual separation

## Technical Notes
- The Cart model already has the necessary methods (`add`, `remove`, `clear`)
- Call `setState(() { ... })` after any cart modification to rebuild the UI
- Price calculations are handled automatically by the `Cart.totalPrice` getter
- Use `cart.getQuantity(sandwich)` to get current quantity
- Handle edge cases: don't allow negative quantities, confirm before final item removal
- For dialogs, use `showDialog()` with `AlertDialog` widgets and await the result
- Remember that in the current implementation, the cart uses `Map<Sandwich, int>`, so each unique Sandwich object (even with identical properties) is a separate entry

# Feature Implementation Request: Sign-Up/Sign-In Screen for Sandwich Shop App

## Context
I have a Flutter sandwich shop application with the following structure:
- **Main entry point**: `lib/main.dart` - MaterialApp with routes
- **Home screen**: `lib/views/order_screen.dart` - OrderScreen where users build and add sandwiches to cart
- **Cart management**: `lib/models/cart.dart` - Cart model with items and pricing
- **Existing screens**: OrderScreen, CartScreen, CheckoutScreen, AboutScreen
- **Styling**: `lib/views/app_styles.dart` contains app-wide styling constants

## Feature Request: User Authentication Screen

### Overview
Create a new sign-up/sign-in screen where users can enter their details. This is a UI-only implementation with no actual authentication or data persistence required at this stage.

### Requirements

#### 1. Create Authentication Screen (`lib/views/auth_screen.dart`)

**Description**: A new screen that allows users to toggle between sign-up and sign-in modes.

**UI Components Required**:
- Screen title that changes based on mode ("Sign Up" or "Sign In")
- Toggle mechanism to switch between sign-up and sign-in modes (e.g., tabs, segmented control, or toggle button)
- Form fields with proper validation
- Submit button that changes label based on mode ("Create Account" or "Sign In")
- Visual feedback for form validation errors

**Form Fields for Sign-Up Mode**:
- Full Name (text input, required, minimum 2 characters)
- Email (text input, required, valid email format)
- Phone Number (text input, optional, valid phone format if provided)
- Password (text input, required, minimum 8 characters, obscured)
- Confirm Password (text input, required, must match password, obscured)

**Form Fields for Sign-In Mode**:
- Email (text input, required, valid email format)
- Password (text input, required, obscured)

**User Actions & Expected Behavior**:

1. **When user taps toggle to switch modes**:
   - Form should clear all fields
   - Validation errors should be reset
   - Screen title and button labels should update
   - Smooth transition animation (optional but nice to have)

2. **When user enters invalid data and taps submit**:
   - Display validation error messages under each invalid field
   - Error messages should be clear and specific (e.g., "Email format is invalid", "Password must be at least 8 characters")
   - Form should not submit
   - No navigation should occur

3. **When user enters valid data and taps submit**:
   - Show a success SnackBar with message: "Account created successfully! Welcome, [Name]" (sign-up) or "Welcome back, [Name]!" (sign-in)
   - Navigate back to the previous screen (OrderScreen)
   - For now, just use the entered name in the success message

4. **When user taps back button or system back**:
   - Return to OrderScreen without any changes
   - Cart contents should remain intact

**Styling Requirements**:
- Use existing app styles from `app_styles.dart` for consistency
- Follow Material Design guidelines
- Ensure proper spacing and padding
- Make form fields clearly visible and touchable
- Use appropriate input types (email keyboard for email field, etc.)

---

#### 2. Add Navigation Link on Order Screen

**Description**: Add a button/link at the bottom of the OrderScreen to navigate to the authentication screen.

**Location**: At the bottom of the OrderScreen, after the cart summary text

**UI Component**:
- A TextButton or similar widget with text "Sign In / Create Account"
- Should be clearly visible but not intrusive
- Use a distinct color or styling to indicate it's a secondary action

**User Action & Expected Behavior**:

**When user taps the "Sign In / Create Account" button**:
- Navigate to the AuthScreen
- Use a standard push navigation (slide-in animation)
- Order screen state should be preserved (cart contents, form fields, etc.)

---

#### 3. Update Main App Routes (Optional)

**Description**: Add the AuthScreen to the app's named routes for easier navigation management.

**Implementation**:
- Add '/auth' route to the MaterialApp routes map in `main.dart`
- This allows navigation using `Navigator.pushNamed(context, '/auth')`

---

## Technical Specifications

### State Management
- Use StatefulWidget for AuthScreen to manage form state and mode toggling
- Use TextEditingController for each form field
- Implement proper disposal of controllers in dispose() method

### Form Validation
- Use Form widget with GlobalKey<FormState>
- Implement validator functions for each field
- Validate on submit, not on every keystroke (unless you prefer real-time validation)

### Validation Rules
- **Full Name**: Required, minimum 2 characters, letters and spaces only
- **Email**: Required, must match email regex pattern
- **Phone**: Optional, but if provided must be valid format (e.g., 10+ digits)
- **Password**: Required, minimum 8 characters, should contain at least one letter and one number
- **Confirm Password**: Required, must exactly match password field

### No Data Persistence Required
- Do not save user data to SharedPreferences, databases, or files
- Do not implement actual authentication logic
- Just validate input and show success messages
- This is purely a UI implementation

---

## Deliverables

1. New file: `lib/views/auth_screen.dart` with complete implementation
2. Modified file: `lib/views/order_screen.dart` with navigation link added
3. Modified file: `lib/main.dart` with route added (if using named routes)

---

## Example User Flow

1. User opens app and sees OrderScreen (home)
2. User scrolls to bottom and taps "Sign In / Create Account"
3. AuthScreen opens in Sign-In mode by default
4. User taps toggle to switch to Sign-Up mode
5. User fills in name, email, phone, password, confirm password
6. User taps "Create Account" button
7. If validation fails: error messages appear under invalid fields
8. If validation succeeds: success SnackBar appears, user returns to OrderScreen
9. Cart contents are unchanged

---

## Additional Notes

- Ensure keyboard doesn't overlap form fields (use SingleChildScrollView)
- Add appropriate focus behavior (tap outside to dismiss keyboard)
- Use obscureText for password fields
- Consider adding icons to form fields for better UX
- Ensure screen works on different device sizes
- Follow existing code style and conventions in the project

# Feature Request: App-Wide Navigation Drawer with Responsive Design

## Context
I have a Flutter sandwich shop application with the following structure:
- **Main entry point**: `lib/main.dart` - MaterialApp with basic routes
- **Screens**: 
  - `lib/views/order_screen.dart` - OrderScreen (home) where users build sandwiches
  - `lib/views/cart_screen.dart` - CartScreen for viewing/modifying cart
  - `lib/views/checkout_screen.dart` - CheckoutScreen for payment processing
  - `lib/views/auth_screen.dart` - AuthScreen for sign-up/sign-in
  - `lib/views/about_screen.dart` - AboutScreen with business information
- **Current Navigation**: 
  - Each screen has its own AppBar
  - Navigation is done via `Navigator.push()` and `Navigator.pop()`
  - No centralized navigation menu exists
- **Styling**: `lib/views/app_styles.dart` contains app-wide styling constants (normalText, heading1, heading2)

## Feature Request: Navigation Drawer with Responsive Behavior

### Overview
Implement a reusable Navigation Drawer that provides easy access to all app screens from any location in the app. The drawer should adapt to different screen sizes (responsive design), showing as a permanent sidebar on larger screens and as a traditional slide-in drawer on smaller screens.

---

## Part 1: Create Reusable Navigation Drawer Widget

### Objective
Create a custom drawer widget that can be used across all screens without code duplication.

### Requirements

#### 1. Create App Drawer Widget (`lib/views/app_drawer.dart`)

**Description**: A new reusable StatelessWidget that provides consistent navigation options across all screens.

**Drawer Header Content**:
- App logo or icon (use `Icons.storefront` or similar sandwich-related icon)
- App title: "Sandwich Shop"
- Optional: Subtitle with tagline (e.g., "Fresh & Delicious")
- Background color or gradient for visual appeal

**Drawer Menu Items** (in order):
1. **Home** - Navigates to OrderScreen
   - Icon: `Icons.home` or `Icons.restaurant_menu`
   - Label: "Home"
   
2. **My Cart** - Navigates to CartScreen
   - Icon: `Icons.shopping_cart`
   - Label: "My Cart"
   - Badge: Show cart item count if cart is not empty (optional but recommended)
   
3. **Sign In / Account** - Navigates to AuthScreen
   - Icon: `Icons.person` or `Icons.account_circle`
   - Label: "Account"
   
4. **About Us** - Navigates to AboutScreen
   - Icon: `Icons.info` or `Icons.info_outline`
   - Label: "About Us"

**Constructor Parameters**:
- `cart` (Cart) - Required to pass cart data for navigation and badge display
- `currentRoute` (String) - Optional parameter to highlight the current screen in the drawer

**User Actions & Expected Behavior**:

1. **When user taps "Home" menu item**:
   - If already on OrderScreen: Close drawer, no navigation
   - If on another screen: Navigate to OrderScreen using `Navigator.pushAndRemoveUntil()` to clear the navigation stack
   - Close the drawer automatically

2. **When user taps "My Cart" menu item**:
   - If cart is empty: Show a SnackBar message "Your cart is empty" and don't navigate
   - If cart has items: Navigate to CartScreen using `Navigator.push()`
   - Pass the `cart` object to CartScreen
   - Close the drawer automatically

3. **When user taps "Account" menu item**:
   - Navigate to AuthScreen using `Navigator.push()`
   - Close the drawer automatically

4. **When user taps "About Us" menu item**:
   - Navigate to AboutScreen using `Navigator.pushNamed(context, '/about')`
   - Close the drawer automatically

5. **When user taps outside the drawer or on the back button**:
   - Drawer closes with slide-out animation
   - User remains on current screen

**Styling Requirements**:
- Use `DrawerHeader` widget for the header section
- Use `ListTile` widgets for each menu item
- Apply consistent padding and spacing
- Highlight the current route with a different background color or text style
- Use Material Design icons
- Ensure text is readable with proper contrast
- Apply colors from your app theme or define new constants in `app_styles.dart`

**Visual Indication**:
- Show a visual indicator (e.g., different background color, accent color) for the currently active menu item
- Use `ListTile`'s `selected` property to highlight the active route

---

#### 2. Update All Screen Scaffolds to Include Drawer

**Description**: Modify each screen to include the new AppDrawer in their Scaffold's `drawer` property.

**Screens to Modify**:
- `lib/views/order_screen.dart`
- `lib/views/cart_screen.dart`
- `lib/views/checkout_screen.dart`
- `lib/views/auth_screen.dart`
- `lib/views/about_screen.dart`

**Implementation for Each Screen**:
```dart
@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text('Screen Title'),
    ),
    drawer: AppDrawer(
      cart: _cart, // or widget.cart depending on screen
      currentRoute: '/routeName', // e.g., '/home', '/cart', '/auth', '/about'
    ),
    body: // existing body content
  );
}