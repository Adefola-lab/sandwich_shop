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

