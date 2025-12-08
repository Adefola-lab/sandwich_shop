# Requirements Document: Cart Item Modification Feature

## 1. Feature Overview

### 1.1 Feature Name
Cart Item Modification and Management

### 1.2 Purpose
Enable users to manage their sandwich cart after items have been added, providing flexibility to adjust quantities, remove individual items, or clear the entire cart without needing to return to the order screen. This improves user experience by allowing cart corrections and changes in a self-contained interface.

### 1.3 Feature Description
This feature adds interactive modification controls to the Cart Screen, transforming it from a read-only view into a fully interactive cart management interface. Users can increase or decrease item quantities, remove individual items, or clear their entire cart. All modifications include appropriate confirmations for destructive actions and provide immediate visual feedback through price updates.

### 1.4 Business Value
- Reduces user frustration when mistakes are made during ordering
- Decreases need for users to navigate back to order screen for minor changes
- Provides industry-standard cart management functionality
- Improves order accuracy by allowing pre-checkout review and modification

---

## 2. User Stories

### Story 1: Increase Item Quantity
**As a** customer  
**I want to** increase the quantity of an item already in my cart  
**So that** I can order more of the same sandwich without re-configuring it on the order screen

**Acceptance Criteria:**
- Given I am viewing my cart with at least one item
- When I tap the plus (+) button next to an item
- Then the quantity increases by 1
- And the item's price updates to reflect the new quantity
- And the cart total price updates immediately
- And no confirmation dialog is required

### Story 2: Decrease Item Quantity (Multiple Items)
**As a** customer  
**I want to** decrease the quantity of an item when I have more than one  
**So that** I can reduce my order without removing the item entirely

**Acceptance Criteria:**
- Given I am viewing my cart with an item that has quantity > 1
- When I tap the minus (-) button next to that item
- Then the quantity decreases by 1
- And the item's price updates to reflect the new quantity
- And the cart total price updates immediately
- And no confirmation dialog is required
- And the item remains in the cart

### Story 3: Decrease Item Quantity (Last Item)
**As a** customer  
**I want to** be warned before removing the last unit of an item  
**So that** I don't accidentally delete items I intended to keep

**Acceptance Criteria:**
- Given I am viewing my cart with an item that has quantity = 1
- When I tap the minus (-) button next to that item
- Then a confirmation dialog appears asking if I want to remove the item
- When I tap "Cancel", the item remains in cart with quantity 1
- When I tap "Confirm" or "Remove", the item is removed from the cart entirely
- And the cart total price updates after removal
- And if this was the only item, the empty cart message displays

### Story 4: Remove Item Entirely
**As a** customer  
**I want to** remove an entire item from my cart regardless of quantity  
**So that** I can quickly delete items I no longer want without clicking minus multiple times

**Acceptance Criteria:**
- Given I am viewing my cart with at least one item
- When I tap the delete/trash icon next to an item
- Then a confirmation dialog appears with title "Remove Item?" and message "Remove this item from your cart?"
- When I tap "Cancel", the item remains in cart unchanged
- When I tap "Remove", the entire item is removed from cart (all quantities)
- And the cart total price updates immediately
- And if this was the last item, the empty cart message displays

### Story 5: Clear Entire Cart
**As a** customer  
**I want to** clear all items from my cart at once  
**So that** I can start over with a fresh order without removing items individually

**Acceptance Criteria:**
- Given I am viewing my cart with at least one item
- When I tap the "Clear Cart" button
- Then a confirmation dialog appears with title "Clear Cart?" and message "Are you sure you want to clear your cart?"
- When I tap "Cancel", all items remain in cart unchanged
- When I tap "Clear", all items are removed from the cart
- And the empty cart message displays
- And the cart total is no longer shown
- And the "Clear Cart" button is hidden
- And the "Back to Order" button remains visible

### Story 6: View Empty Cart
**As a** customer  
**I want to** see a clear message when my cart is empty  
**So that** I understand my cart state and know to return to ordering

**Acceptance Criteria:**
- Given my cart has no items
- When I view the Cart Screen
- Then I see the message "Your cart is empty"
- And no cart items are displayed
- And no total price is displayed
- And the "Clear Cart" button is not visible
- And the "Back to Order" button is visible
- And I can tap "Back to Order" to return to the order screen

### Story 7: See Real-Time Price Updates
**As a** customer  
**I want to** see prices update immediately when I modify my cart  
**So that** I always know the current total cost of my order

**Acceptance Criteria:**
- Given I am viewing my cart with items
- When I increase or decrease any item quantity
- Then the individual item price updates within 100ms
- And the cart total price updates within 100ms
- And both prices display with proper formatting (£X.XX format)
- And the calculation is accurate based on the PricingRepository logic

---

## 3. Functional Requirements

### 3.1 Quantity Modification Controls

**FR-1.1:** Each cart item must display a minus (-) icon button for decreasing quantity  
**FR-1.2:** Each cart item must display a plus (+) icon button for increasing quantity  
**FR-1.3:** Quantity controls must be positioned horizontally in a row with the quantity text  
**FR-1.4:** Icon buttons must use Material Design icons (`Icons.add` and `Icons.remove`)  
**FR-1.5:** Buttons must be appropriately sized and have adequate touch targets (minimum 48x48 logical pixels)

### 3.2 Item Removal Controls

**FR-2.1:** Each cart item must display a delete icon button for complete removal  
**FR-2.2:** Delete button must use `Icons.delete` or `Icons.delete_outline`  
**FR-2.3:** Delete button should be visually distinct (e.g., red color or positioned separately)  
**FR-2.4:** Delete button must be accessible without interfering with quantity controls

### 3.3 Cart Clearing Controls

**FR-3.1:** A "Clear Cart" button must be displayed when cart is not empty  
**FR-3.2:** "Clear Cart" button must use `Icons.remove_shopping_cart` icon  
**FR-3.3:** Button must be styled consistently with other major action buttons (using `StyledButton`)  
**FR-3.4:** Button must be positioned between the cart total and "Back to Order" button  
**FR-3.5:** Button must be hidden when `cart.isEmpty == true`

### 3.4 Confirmation Dialogs

**FR-4.1:** Decreasing quantity to 0 must trigger a confirmation dialog  
**FR-4.2:** Tapping delete icon must trigger a confirmation dialog  
**FR-4.3:** Tapping "Clear Cart" must trigger a confirmation dialog  
**FR-4.4:** All dialogs must have a descriptive title and clear message  
**FR-4.5:** All dialogs must have "Cancel" and a confirmatory action button  
**FR-4.6:** Dialogs must return `Future<bool>` to indicate user choice  
**FR-4.7:** Tapping outside dialog or pressing back should be treated as cancellation

### 3.5 State Management

**FR-5.1:** All cart modifications must call `setState()` to trigger UI rebuild  
**FR-5.2:** Cart modifications must use existing Cart model methods (`add`, `remove`, `clear`)  
**FR-5.3:** UI must reflect changes immediately (no loading states required)  
**FR-5.4:** Price calculations must use `Cart.totalPrice` getter and `PricingRepository`

### 3.6 Empty Cart State

**FR-6.1:** When cart is empty, display message "Your cart is empty"  
**FR-6.2:** Empty cart message must be centered and use appropriate text style  
**FR-6.3:** Cart total must not be displayed when cart is empty  
**FR-6.4:** "Clear Cart" button must not be displayed when cart is empty  
**FR-6.5:** "Back to Order" button must remain visible when cart is empty

### 3.7 Visual Layout

**FR-7.1:** Each cart item should have clear visual separation (consider using Cards or Containers)  
**FR-7.2:** Item information must follow existing format: name, size/bread, quantity/price  
**FR-7.3:** All text must use existing styles from `app_styles.dart`  
**FR-7.4:** Layout must be responsive and scrollable for multiple items  
**FR-7.5:** Buttons must have appropriate spacing and padding for usability

---

## 4. Non-Functional Requirements

### 4.1 Performance
**NFR-1.1:** UI updates must occur within 100ms of user interaction  
**NFR-1.2:** Dialog animations must be smooth (60fps)  
**NFR-1.3:** Price calculations must complete synchronously without blocking UI

### 4.2 Usability
**NFR-2.1:** All interactive elements must meet minimum touch target size (48x48 dp)  
**NFR-2.2:** Destructive actions must require confirmation  
**NFR-2.3:** UI must provide immediate visual feedback for all interactions  
**NFR-2.4:** Icons must be intuitive and follow Material Design guidelines

### 4.3 Accessibility
**NFR-3.1:** All icon buttons should have semantic labels for screen readers  
**NFR-3.2:** Dialogs should be properly announced by screen readers  
**NFR-3.3:** Color must not be the only means of conveying information

### 4.4 Maintainability
**NFR-4.1:** Code must follow existing project structure and naming conventions  
**NFR-4.2:** Methods should be well-named and single-purpose  
**NFR-4.3:** Reusable dialog methods should be created to avoid duplication  
**NFR-4.4:** Comments should explain complex logic or business rules

---

## 5. Acceptance Criteria

### 5.1 Feature Complete When:

✅ **AC-1:** User can increase quantity of any cart item by tapping plus button  
✅ **AC-2:** User can decrease quantity of any cart item by tapping minus button  
✅ **AC-3:** User receives confirmation before removing last unit of an item  
✅ **AC-4:** User can remove entire item via delete button after confirmation  
✅ **AC-5:** User can clear entire cart via "Clear Cart" button after confirmation  
✅ **AC-6:** All price updates happen immediately after quantity changes  
✅ **AC-7:** Empty cart displays "Your cart is empty" message  
✅ **AC-8:** "Clear Cart" button is hidden when cart is empty  
✅ **AC-9:** All confirmation dialogs can be cancelled without changes  
✅ **AC-10:** UI uses appropriate Material Design icons for all actions  
✅ **AC-11:** Layout is consistent with existing app styles  
✅ **AC-12:** All cart modifications properly update the Cart model state  
✅ **AC-13:** UI rebuilds correctly after all state changes  
✅ **AC-14:** No crashes or errors occur during any modification action  
✅ **AC-15:** "Back to Order" button remains functional in all states

### 5.2 Testing Checklist

**Functional Testing:**
- [ ] Increase quantity from 1 to 2, verify price updates
- [ ] Increase quantity from 2 to 5, verify price updates
- [ ] Decrease quantity from 5 to 4, verify price updates
- [ ] Decrease quantity from 2 to 1, verify no dialog appears
- [ ] Decrease quantity from 1 to 0, verify dialog appears and handles both outcomes
- [ ] Delete item with quantity > 1, verify dialog and complete removal
- [ ] Delete item with quantity = 1, verify dialog and complete removal
- [ ] Clear cart with multiple items, verify dialog and complete clearing
- [ ] Cancel all dialogs and verify no changes occur
- [ ] Modify different items in same cart session
- [ ] Remove all items one by one, verify empty state
- [ ] Clear cart and verify empty state
- [ ] Navigate back from empty cart and re-add items

**Edge Cases:**
- [ ] Cart with single item quantity 1 - decrease button behavior
- [ ] Cart with 10+ quantity item - multiple decreases
- [ ] Rapid button tapping - no duplicate operations
- [ ] Dialog shown then app backgrounded - proper state handling
- [ ] Multiple items in cart - modify each independently

**Visual Testing:**
- [ ] Buttons are properly sized and aligned
- [ ] Icons are clear and appropriate
- [ ] Spacing and padding are consistent
- [ ] Empty state message is centered and readable
- [ ] Dialogs display correctly on different screen sizes
- [ ] Colors match app theme
- [ ] Text styles match existing screens

---

## 6. Technical Constraints

### 6.1 Current Implementation Limitations
- Cart uses `Map<Sandwich, int>` where Sandwich objects are keys
- Identical sandwiches (same type, size, bread) may appear as separate entries if they are different object instances
- The modification UI must work with this current behavior (not required to fix the duplicate issue)

### 6.2 Dependencies
- Flutter SDK (existing)
- Material Design widgets (existing)
- Existing Cart model with `add`, `remove`, `clear` methods
- Existing PricingRepository for price calculations
- Existing `app_styles.dart` for text styles
- Existing `StyledButton` widget for major action buttons

### 6.3 Code Location
- Primary implementation: `lib/views/cart_screen.dart`
- Modify: `_CartScreenState` class
- Add new methods for dialog display and cart modification handlers
- No changes required to: Cart model, Sandwich model, PricingRepository

---

## 7. Out of Scope

The following items are explicitly NOT included in this feature:
- Fixing the duplicate sandwich entries issue in the Cart model
- Adding undo/redo functionality
- Implementing a quantity text input field (only +/- buttons)
- Adding animations or transitions beyond default Material animations
- Saving cart state between app sessions
- Adding a "Save for later" or favorites feature
- Editing sandwich properties (type, size, bread) from cart screen
- Implementing maximum quantity limits per item
- Adding discount or promotion code functionality
- Order history or past orders feature

---

## 8. Success Metrics

### 8.1 Definition of Done
- All functional requirements implemented
- All acceptance criteria met
- Code reviewed and approved
- No critical or high-priority bugs
- User testing completed with positive feedback
- Documentation updated (if applicable)

### 8.2 Quality Gates
- Code compiles without errors or warnings
- No runtime exceptions during normal usage
- UI renders correctly on iOS and Android
- App passes existing test suite (if any)
- Performance meets non-functional requirements