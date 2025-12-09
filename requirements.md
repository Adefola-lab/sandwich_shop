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

# Requirements Document: User Authentication Screen Feature

## 1. Feature Overview

### 1.1 Feature Name
User Authentication Screen (Sign-Up/Sign-In)

### 1.2 Purpose
Provide users with the ability to create accounts and sign in to their profiles within the sandwich shop application. This feature establishes the foundation for future personalization, order history tracking, and user-specific functionality. At this stage, it serves as a UI-only implementation without backend authentication or data persistence.

### 1.3 Feature Description
This feature introduces a new authentication screen that supports both account creation (sign-up) and user login (sign-in) through a unified, toggle-based interface. Users can access this screen from a link at the bottom of the Order Screen. The authentication screen provides form-based input with comprehensive validation, ensuring data quality while maintaining a smooth user experience. The feature is intentionally limited to UI and validation logic, with no actual authentication service integration or data storage.

### 1.4 Business Value
- Establishes user account infrastructure for future feature expansion
- Improves user engagement by creating a personalized experience foundation
- Enables future implementation of order history, saved preferences, and loyalty programs
- Demonstrates professional app design with standard authentication patterns
- Lays groundwork for user analytics and personalized marketing

---

## 2. User Stories

### Story 1: Access Authentication Screen
**As a** sandwich shop customer  
**I want to** easily access a sign-up/sign-in screen from the main order page  
**So that** I can create an account or log in without disrupting my shopping experience

**Acceptance Criteria:**
- Given I am on the Order Screen
- When I scroll to the bottom of the page
- Then I see a clearly labeled "Sign In / Create Account" button/link
- And when I tap this button
- Then I am navigated to the Authentication Screen
- And my current cart contents are preserved
- And my order form state (sandwich selections, quantity, etc.) is preserved

### Story 2: Toggle Between Sign-Up and Sign-In Modes
**As a** user on the authentication screen  
**I want to** easily switch between sign-up and sign-in modes  
**So that** I can create a new account or log into an existing one without navigating to separate screens

**Acceptance Criteria:**
- Given I am on the Authentication Screen
- When the screen loads, it defaults to Sign-In mode
- And I see a toggle control (tabs, buttons, or segmented control) to switch modes
- When I tap the toggle to switch to Sign-Up mode
- Then the screen title changes from "Sign In" to "Sign Up"
- And the form fields update to show sign-up specific fields (Name, Phone, Confirm Password)
- And all form fields are cleared
- And any previous validation errors are removed
- And the submit button label changes to "Create Account"
- When I switch back to Sign-In mode
- Then only email and password fields are displayed
- And all fields are cleared again
- And the submit button label changes to "Sign In"

### Story 3: Create New Account (Sign-Up)
**As a** new customer  
**I want to** create an account by providing my personal information  
**So that** I can access personalized features and have my information ready for future orders

**Acceptance Criteria:**
- Given I am on the Authentication Screen in Sign-Up mode
- When I enter valid information in all required fields:
  - Full Name: "John Smith" (at least 2 characters)
  - Email: "john.smith@example.com" (valid email format)
  - Phone: "1234567890" (optional, valid format if provided)
  - Password: "Pass1234" (at least 8 characters, contains letter and number)
  - Confirm Password: "Pass1234" (matches password)
- And I tap the "Create Account" button
- Then I see a success SnackBar message: "Account created successfully! Welcome, John Smith"
- And I am automatically navigated back to the Order Screen
- And my cart contents remain unchanged
- And the SnackBar displays for 3-4 seconds before disappearing

### Story 4: Sign In to Existing Account
**As a** returning customer  
**I want to** sign in with my email and password  
**So that** I can access my account and personalized features

**Acceptance Criteria:**
- Given I am on the Authentication Screen in Sign-In mode
- When I enter valid information:
  - Email: "john.smith@example.com" (valid email format)
  - Password: "Pass1234" (at least 8 characters)
- And I tap the "Sign In" button
- Then I see a success SnackBar message: "Welcome back, John Smith!"
- And I am automatically navigated back to the Order Screen
- And my cart contents remain unchanged
- And the SnackBar displays for 3-4 seconds before disappearing
- Note: For this UI-only implementation, any valid email format is accepted and the name is extracted from the email prefix

### Story 5: Validation Error Feedback (Invalid Full Name)
**As a** user creating an account  
**I want to** receive clear feedback when my name is invalid  
**So that** I know what correction to make

**Acceptance Criteria:**
- Given I am on the Authentication Screen in Sign-Up mode
- When I enter a name with less than 2 characters (e.g., "J")
- And I tap "Create Account"
- Then I see an error message below the Full Name field: "Name must be at least 2 characters"
- And the form does not submit
- And I remain on the Authentication Screen
- When I enter a name with special characters or numbers (e.g., "John123")
- And I tap "Create Account"
- Then I see an error message: "Name can only contain letters and spaces"
- And the form does not submit

### Story 6: Validation Error Feedback (Invalid Email)
**As a** user creating an account or signing in  
**I want to** receive clear feedback when my email format is invalid  
**So that** I can correct it before submitting

**Acceptance Criteria:**
- Given I am on the Authentication Screen (either mode)
- When I enter an invalid email format (e.g., "notanemail", "missing@domain", "no@.com")
- And I tap the submit button
- Then I see an error message below the Email field: "Please enter a valid email address"
- And the form does not submit
- And I remain on the Authentication Screen
- And other field values are preserved

### Story 7: Validation Error Feedback (Invalid Password)
**As a** user creating an account or signing in  
**I want to** receive clear feedback about password requirements  
**So that** I can create a secure password that meets the criteria

**Acceptance Criteria:**
- Given I am on the Authentication Screen (either mode)
- When I enter a password with less than 8 characters (e.g., "Pass12")
- And I tap the submit button
- Then I see an error message below the Password field: "Password must be at least 8 characters"
- And the form does not submit
- When I enter a password with 8+ characters but no numbers (e.g., "Password")
- And I tap the submit button
- Then I see an error message: "Password must contain at least one letter and one number"
- And the form does not submit
- When I enter a password with 8+ characters but no letters (e.g., "12345678")
- And I tap the submit button
- Then I see the same error message about letter and number requirement

### Story 8: Validation Error Feedback (Password Mismatch)
**As a** user creating an account  
**I want to** be notified if my password and confirmation don't match  
**So that** I can correct the mismatch before creating my account

**Acceptance Criteria:**
- Given I am on the Authentication Screen in Sign-Up mode
- When I enter a password: "Pass1234"
- And I enter a different confirm password: "Pass5678"
- And I tap "Create Account"
- Then I see an error message below the Confirm Password field: "Passwords do not match"
- And the form does not submit
- And I remain on the Authentication Screen
- When I correct the confirm password to match
- And all other fields are valid
- And I tap "Create Account"
- Then the form submits successfully

### Story 9: Validation Error Feedback (Invalid Phone Number)
**As a** user creating an account  
**I want to** receive feedback if my phone number format is invalid  
**So that** I can provide a correctly formatted number

**Acceptance Criteria:**
- Given I am on the Authentication Screen in Sign-Up mode
- When I leave the Phone field empty
- And I tap "Create Account"
- Then no error is shown for the Phone field (it's optional)
- And validation proceeds to check other required fields
- When I enter a phone number with less than 10 digits (e.g., "123456")
- And I tap "Create Account"
- Then I see an error message below the Phone field: "Please enter a valid phone number (at least 10 digits)"
- And the form does not submit
- When I enter a phone number with letters or special characters in wrong places (e.g., "abc1234567")
- And I tap "Create Account"
- Then I see an error message: "Please enter a valid phone number"

### Story 10: Multiple Validation Errors
**As a** user filling out the authentication form  
**I want to** see all validation errors at once when I submit  
**So that** I can fix all issues in one go rather than discovering them one at a time

**Acceptance Criteria:**
- Given I am on the Authentication Screen in Sign-Up mode
- When I leave all fields empty or fill them with invalid data
- And I tap "Create Account"
- Then I see error messages below ALL invalid fields simultaneously
- And each error message is specific to that field's validation issue
- And the form does not submit
- And I can scroll through the form to see all errors
- When I correct some but not all fields
- And I tap "Create Account" again
- Then I see error messages only for the remaining invalid fields
- And previously corrected fields show no errors

### Story 11: Cancel/Navigate Back
**As a** user on the authentication screen  
**I want to** return to the order screen without submitting the form  
**So that** I can continue shopping without creating an account

**Acceptance Criteria:**
- Given I am on the Authentication Screen
- When I tap the system back button or a cancel/back button in the app bar
- Then I am navigated back to the Order Screen
- And my cart contents remain unchanged
- And my order form state (sandwich selections, quantity) remains unchanged
- And no SnackBar or confirmation message is displayed
- And any data I entered in the authentication form is discarded

### Story 12: Keyboard and Scrolling Behavior
**As a** user filling out the authentication form on a mobile device  
**I want to** be able to see and access all form fields even when the keyboard is open  
**So that** I can complete the form without the keyboard blocking fields

**Acceptance Criteria:**
- Given I am on the Authentication Screen
- When I tap any text field
- Then the keyboard appears for that field type:
  - Standard keyboard for Name field
  - Email keyboard for Email field
  - Numeric keyboard for Phone field
  - Password keyboard (with obscured characters) for Password fields
- And the form is scrollable
- And when the keyboard appears, the screen automatically scrolls to keep the active field visible
- And I can scroll manually to see other fields while keyboard is open
- When I tap outside the text fields
- Then the keyboard dismisses
- And I can see the full form again

### Story 13: Form Field Visual Feedback
**As a** user interacting with the form  
**I want to** see visual indicators of which field I'm currently editing  
**So that** I have clear feedback about where my input will go

**Acceptance Criteria:**
- Given I am on the Authentication Screen
- When a text field is not focused
- Then it displays with a neutral border color
- When I tap a text field to focus it
- Then the field's border color changes to indicate focus (e.g., primary color)
- And a cursor appears in the field
- When a field has a validation error
- Then the field's border color changes to indicate error (e.g., red)
- And the error message appears below in red text
- When I correct an error and the field passes validation
- Then the error styling and message disappear

---

## 3. Technical Acceptance Criteria

### 3.1 Code Structure
- [ ] New file `lib/views/auth_screen.dart` exists with AuthScreen StatefulWidget
- [ ] AuthScreen contains GlobalKey<FormState> for form validation
- [ ] All text fields use TextEditingController
- [ ] All controllers are properly disposed in dispose() method
- [ ] File follows existing code style and conventions from the project

### 3.2 Navigation Implementation
- [ ] OrderScreen contains navigation link/button to AuthScreen
- [ ] Navigation link is positioned at the bottom of OrderScreen after cart summary
- [ ] Navigation uses Navigator.push with MaterialPageRoute
- [ ] Optional: AuthScreen is added to named routes in main.dart as '/auth'
- [ ] Navigation preserves OrderScreen state (cart contents, form values)
- [ ] Back navigation returns to OrderScreen without data loss

### 3.3 Form Validation Implementation
- [ ] Form widget wraps all input fields
- [ ] Each TextFormField has a validator function
- [ ] Validation occurs on form submit, not on keystroke (unless specified otherwise)
- [ ] All validation rules match specifications:
  - Full Name: min 2 chars, letters and spaces only
  - Email: valid email regex pattern
  - Phone: optional, but if provided must be 10+ digits
  - Password: min 8 chars, must contain letter and number
  - Confirm Password: must match password field exactly
- [ ] Form displays all validation errors simultaneously on submit
- [ ] Invalid form prevents submission and navigation

### 3.4 UI/UX Requirements
- [ ] Screen title dynamically changes based on mode ("Sign Up" / "Sign In")
- [ ] Toggle control allows switching between modes
- [ ] Form fields are cleared when switching modes
- [ ] Sign-Up mode shows 5 fields (Name, Email, Phone, Password, Confirm Password)
- [ ] Sign-In mode shows 2 fields (Email, Password)
- [ ] Submit button label changes based on mode ("Create Account" / "Sign In")
- [ ] Password fields use obscureText: true
- [ ] Form is wrapped in SingleChildScrollView for keyboard handling
- [ ] Form uses appropriate keyboard types for each field
- [ ] Success SnackBar appears on valid submission with user's name
- [ ] Success SnackBar displays for 3-4 seconds
- [ ] Styling is consistent with app_styles.dart

### 3.5 State Management
- [ ] AuthScreen maintains boolean state for mode (isSignUpMode)
- [ ] Mode toggle clears all text controllers
- [ ] Mode toggle resets form validation state
- [ ] Submit handlers call setState() after validation
- [ ] No data persistence occurs (no SharedPreferences, no database)

### 3.6 Error Handling
- [ ] Each validation error displays a clear, specific message
- [ ] Error messages appear below their respective fields
- [ ] Multiple errors can be displayed simultaneously
- [ ] Errors clear when fields are corrected
- [ ] No crashes occur from edge cases (null values, empty strings, etc.)

---

## 4. Definition of Done

The feature is considered complete when:

1. ✅ All code files are created and modified as specified in deliverables
2. ✅ All user stories have passing acceptance criteria
3. ✅ All technical acceptance criteria are met
4. ✅ The app compiles without errors or warnings related to the new feature
5. ✅ Manual testing confirms all user flows work as expected:
   - Navigation to/from auth screen
   - Mode switching
   - Form validation (all error cases)
   - Successful sign-up flow
   - Successful sign-in flow
   - Back navigation
   - Keyboard/scroll behavior
6. ✅ Cart state is preserved across navigation
7. ✅ Order screen state is preserved across navigation
8. ✅ Code follows project conventions and style guidelines
9. ✅ No actual authentication or data persistence is implemented (as specified)
10. ✅ UI is responsive and works on different screen sizes

---

## 5. Out of Scope (Future Enhancements)

The following items are explicitly **NOT** part of this implementation:

- Backend authentication service integration
- Data persistence (SharedPreferences, SQLite, Firebase)
- Password reset/forgot password functionality
- Email verification
- Social media login (Google, Facebook, etc.)
- User profile management screen
- Logout functionality
- Session management
- Token storage
- API integration
- User data encryption
- Remember me functionality
- Biometric authentication
- Order history tied to user accounts
- Saved payment methods
- Address management

These features may be implemented in future iterations once the authentication infrastructure is established.

---

## 6. Testing Scenarios

### Manual Testing Checklist

#### Scenario 1: Complete Sign-Up Flow (Happy Path)
1. Open app, see Order Screen
2. Scroll to bottom, tap "Sign In / Create Account"
3. Verify navigation to Auth Screen in Sign-In mode
4. Tap toggle to switch to Sign-Up mode
5. Enter valid data in all fields
6. Tap "Create Account"
7. Verify success SnackBar appears with name
8. Verify navigation back to Order Screen
9. Verify cart contents unchanged

#### Scenario 2: Complete Sign-In Flow (Happy Path)
1. Navigate to Auth Screen
2. Verify default mode is Sign-In
3. Enter valid email and password
4. Tap "Sign In"
5. Verify success SnackBar appears
6. Verify navigation back to Order Screen

#### Scenario 3: Validation Errors (All Fields Invalid)
1. Navigate to Auth Screen, switch to Sign-Up mode
2. Leave all fields empty or enter invalid data
3. Tap "Create Account"
4. Verify multiple error messages appear
5. Verify no navigation occurs
6. Verify form remains editable

#### Scenario 4: Mode Switching
1. Navigate to Auth Screen
2. Enter data in Sign-In fields
3. Switch to Sign-Up mode
4. Verify fields are cleared
5. Enter data in Sign-Up fields
6. Switch back to Sign-In mode
7. Verify fields are cleared again

#### Scenario 5: Back Navigation
1. Add items to cart on Order Screen
2. Navigate to Auth Screen
3. Enter some data in form
4. Press back button
5. Verify return to Order Screen
6. Verify cart contents unchanged
7. Verify order form state unchanged

#### Scenario 6: Keyboard Behavior
1. Navigate to Auth Screen
2. Tap each field and verify correct keyboard appears
3. Verify form scrolls to show active field
4. Tap outside fields, verify keyboard dismisses
5. Verify can scroll while keyboard is open

#### Scenario 7: Password Mismatch
1. Navigate to Auth Screen, Sign-Up mode
2. Enter valid data in all fields
3. Enter different passwords in Password and Confirm Password
4. Tap "Create Account"
5. Verify error message appears for Confirm Password field
6. Verify form does not submit

#### Scenario 8: Optional Phone Field
1. Navigate to Auth Screen, Sign-Up mode
2. Leave Phone field empty
3. Fill all other required fields with valid data
4. Tap "Create Account"
5. Verify successful submission (phone is optional)

---

## 7. Dependencies

### External Dependencies
- No new package dependencies required
- Uses existing Flutter Material package
- Uses existing app_styles.dart for styling

### Internal Dependencies
- Requires OrderScreen to add navigation button
- Requires main.dart route configuration (optional)
- Must maintain Cart model state across navigation

---

## 8. Design Considerations

### Accessibility
- Form fields should have proper labels and hints
- Error messages should be screen-reader friendly
- Touch targets should be minimum 48x48 pixels
- Color contrast should meet WCAG standards
- Focus order should be logical (top to bottom)

### Performance
- Form validation should be instant (no noticeable lag)
- Navigation transitions should be smooth
- No memory leaks from undisposed controllers

### Security (Future Consideration)
- While no actual authentication is implemented, the UI should follow security best practices:
  - Passwords are obscured
  - Form demonstrates secure input patterns
  - Code structure allows for easy future security integration

### UX Polish (Optional Enhancements)
- Consider adding field icons (person icon for name, email icon, etc.)
- Consider showing password strength indicator
- Consider adding eye icon to toggle password visibility
- Consider animating the transition between sign-up and sign-in modes
- Consider disabling submit button while form is invalid (instead of showing errors on submit)

---

## 9. Success Metrics (Post-Implementation)

While this is a UI-only implementation, future success can be measured by:
- User adoption rate (% of users who create accounts)
- Form completion rate (% who start vs. finish sign-up)
- Validation error frequency (identifies confusing requirements)
- Time to complete sign-up (indicates form complexity)
- Return sign-in rate (indicates successful account creation)

These metrics can be implemented once analytics are added in future iterations.
# Requirements Document: App-Wide Navigation Drawer with Responsive Design

## 1. Feature Overview

### 1.1 Feature Name
App-Wide Navigation Drawer with Responsive Layout

### 1.2 Purpose
Provide users with consistent, accessible navigation throughout the sandwich shop application while reducing code duplication across screens. The feature adapts to different device sizes, offering a traditional slide-in drawer on mobile/tablet devices and a permanent navigation rail on desktop displays. This creates a professional, user-friendly interface that follows modern responsive design patterns.

### 1.3 Feature Description
This feature introduces a centralized navigation system consisting of two main components:

1. **Reusable Navigation Drawer**: A custom widget containing all primary navigation options (Home, Cart, Account, About) that can be integrated into any screen without code duplication. The drawer includes visual indicators for the current screen and conditional logic for cart-related navigation.

2. **Responsive Layout System**: A wrapper widget that automatically adapts the navigation pattern based on screen width:
   - **Small/Medium screens (< 840px)**: Traditional drawer that slides in from the left when the hamburger menu is tapped
   - **Large screens (≥ 840px)**: Permanent NavigationRail or sidebar that remains visible alongside the main content

This architecture centralizes navigation logic, ensures consistency across the app, and provides an optimal experience for users regardless of their device type.

### 1.4 Business Value
- **Improved User Experience**: Users can navigate to any screen from anywhere in the app with a single tap
- **Increased Engagement**: Easy access to cart and account features encourages users to complete purchases
- **Professional Appearance**: Responsive design demonstrates quality and attention to modern UX standards
- **Reduced Development Time**: Reusable components eliminate repetitive code across screens
- **Easier Maintenance**: Changes to navigation only need to be made in one location
- **Accessibility**: Consistent navigation patterns help users learn the app faster
- **Cross-Device Optimization**: Desktop users get a tailored experience that utilizes larger screen space

---

## 2. User Stories

### Story 1: Access Navigation Menu on Mobile/Tablet
**As a** mobile or tablet user  
**I want to** access a navigation menu from any screen via a hamburger icon  
**So that** I can quickly navigate to other parts of the app without using back buttons repeatedly

**Acceptance Criteria:**
- Given I am on any screen in the app (Order, Cart, Checkout, Auth, About)
- And my device screen width is less than 840px
- When the screen loads
- Then I see a hamburger menu icon (☰) in the top-left corner of the AppBar
- When I tap the hamburger menu icon
- Then a drawer slides in from the left edge of the screen
- And the main content dims with a semi-transparent overlay
- And I can see all navigation menu items in the drawer
- When I tap outside the drawer or press the back button
- Then the drawer slides out and closes
- And I remain on the current screen

### Story 2: Navigate to Home from Anywhere
**As a** user browsing the app  
**I want to** return to the home screen (Order Screen) from any other screen  
**So that** I can start a new order or modify my current sandwich selections

**Acceptance Criteria:**
- Given I am on any screen except the Order Screen
- And I have opened the navigation drawer
- When I tap the "Home" menu item (with home/restaurant icon)
- Then the drawer closes immediately
- And I am navigated to the Order Screen
- And the navigation stack is cleared (back button won't return to previous screens)
- And my cart contents are preserved
- And the "Home" item is highlighted in the navigation menu on the Order Screen

**Additional Scenario - Already on Home:**
- Given I am on the Order Screen
- And I open the navigation drawer
- When I see the "Home" item is already highlighted
- And I tap the "Home" item
- Then the drawer closes
- And no navigation occurs (I remain on Order Screen)

### Story 3: Navigate to Cart from Anywhere
**As a** user who has added items to my cart  
**I want to** view my cart from any screen  
**So that** I can review my order and proceed to checkout without navigating through multiple screens

**Acceptance Criteria:**
- Given I am on any screen in the app
- And my cart contains at least one item
- And I have opened the navigation drawer
- When I tap the "My Cart" menu item (with shopping cart icon)
- Then the drawer closes immediately
- And I am navigated to the Cart Screen
- And I can see all my cart items with quantities and prices
- And the "My Cart" item is highlighted in the navigation menu on the Cart Screen
- And the back button will return me to the previous screen

**Scenario - Empty Cart:**
- Given my cart is empty (0 items)
- And I have opened the navigation drawer
- When I tap the "My Cart" menu item
- Then the drawer closes immediately
- And a SnackBar appears with message "Your cart is empty"
- And I remain on the current screen (no navigation occurs)
- And the SnackBar disappears after 2-3 seconds

**Optional - Cart Badge:**
- Given my cart contains items
- When I view the navigation drawer
- Then I see a small badge on the "My Cart" menu item showing the item count
- And the badge updates automatically when items are added or removed

### Story 4: Navigate to Account Screen
**As a** user who wants to manage my account  
**I want to** access the sign-in or account screen from anywhere  
**So that** I can log in, create an account, or manage my profile without starting from the home screen

**Acceptance Criteria:**
- Given I am on any screen in the app
- And I have opened the navigation drawer
- When I tap the "Account" menu item (with person/account icon)
- Then the drawer closes immediately
- And I am navigated to the Auth Screen
- And the Auth Screen opens in its default Sign-In mode
- And the "Account" item is highlighted in the navigation menu on the Auth Screen
- And any previous screen state is preserved (I can navigate back)

### Story 5: Navigate to About Screen
**As a** curious user  
**I want to** learn more about the sandwich shop  
**So that** I can read about the business, contact information, or other details

**Acceptance Criteria:**
- Given I am on any screen in the app
- And I have opened the navigation drawer
- When I tap the "About Us" menu item (with info icon)
- Then the drawer closes immediately
- And I am navigated to the About Screen using the named route '/about'
- And I can see information about the sandwich shop
- And the "About Us" item is highlighted in the navigation menu on the About Screen
- And the back button will return me to the previous screen

### Story 6: See Current Location Highlighted
**As a** user navigating the app  
**I want to** see which screen I'm currently on in the navigation menu  
**So that** I have clear orientation and know where I am in the app

**Acceptance Criteria:**
- Given I am on any screen in the app
- When I open the navigation drawer
- Then I see all four navigation menu items (Home, My Cart, Account, About Us)
- And the menu item corresponding to my current screen has a visual highlight:
  - Different background color (e.g., light blue or primary color variant)
  - Or different text color
  - Or a selection indicator (e.g., vertical bar on the left)
- And all other menu items appear in their normal, unhighlighted state
- When I navigate to a different screen
- And I open the drawer again
- Then the new current screen is highlighted
- And the previous screen is no longer highlighted

### Story 7: Desktop User with Permanent Navigation
**As a** desktop user with a large screen  
**I want to** see the navigation menu permanently visible alongside the content  
**So that** I can navigate efficiently without opening and closing a drawer repeatedly

**Acceptance Criteria:**
- Given I am using a device with screen width ≥ 840px (desktop)
- When I open the app and navigate to any screen
- Then I see a permanent navigation component on the left side of the screen:
  - Either a NavigationRail (narrow, icon-focused vertical bar)
  - Or a permanent Drawer (wider sidebar with full labels)
- And the navigation is always visible (doesn't slide in/out)
- And the main content appears to the right of the navigation
- And there is NO hamburger menu icon in the AppBar (navigation is already visible)
- And the current screen is highlighted in the navigation component
- When I click any navigation item
- Then the main content area updates to show the new screen
- And the navigation remains visible and functional
- And the newly selected item becomes highlighted

### Story 8: Responsive Transition Between Layouts
**As a** user who resizes my browser window or rotates my device  
**I want to** see the navigation automatically adapt to the new screen size  
**So that** I always have an optimal viewing and navigation experience

**Acceptance Criteria:**
- Given I am using the app in a desktop browser at width ≥ 840px
- And I see the permanent navigation rail on the left
- When I resize the browser window to width < 840px
- Then the permanent navigation rail disappears
- And a hamburger menu icon appears in the AppBar
- And the main content expands to use the full width
- And my current screen and cart state are preserved

**Reverse Scenario:**
- Given I am using the app on mobile/tablet at width < 840px
- And I see the hamburger menu in the AppBar
- When I rotate my device to landscape or expand the browser to width ≥ 840px
- Then the hamburger menu icon disappears
- And the permanent navigation rail appears on the left
- And the main content adjusts to share the screen with the navigation
- And my current screen and cart state are preserved
- And if the drawer was open, it transitions to the permanent navigation

### Story 9: Drawer Header Identity
**As a** user opening the navigation drawer  
**I want to** see clear app branding in the drawer header  
**So that** I have visual confirmation of which app I'm using and feel oriented

**Acceptance Criteria:**
- Given I am on any screen in the app (on mobile/tablet layout)
- When I open the navigation drawer
- Then I see a visually distinct header section at the top of the drawer
- And the header displays:
  - An app icon or logo (e.g., `Icons.storefront` or sandwich-related icon)
  - The app name "Sandwich Shop" in a prominent heading style
  - Optional: A subtitle or tagline (e.g., "Fresh & Delicious")
- And the header has a distinct background color or gradient
- And the header is visually separated from the menu items below
- And the header does not respond to taps (it's decorative, not interactive)

### Story 10: Seamless Cart State Management
**As a** user with items in my cart  
**I want to** maintain my cart contents when navigating between screens via the drawer  
**So that** I don't lose my order regardless of where I navigate

**Acceptance Criteria:**
- Given I am on the Order Screen
- And I have added 3 sandwiches to my cart
- When I open the drawer and navigate to the Account screen
- Then my cart still contains 3 sandwiches
- When I open the drawer again and navigate to the Cart Screen
- Then I see all 3 sandwiches displayed
- When I navigate back to the Order Screen via the drawer
- Then my cart count remains at 3
- And I can add more items without losing the previous 3
- And this behavior is consistent regardless of which screens I navigate between

---

## 3. Functional Requirements

### 3.1 App Drawer Widget (`lib/views/app_drawer.dart`)

**FR-1.1:** Create a new `AppDrawer` StatelessWidget in `lib/views/app_drawer.dart`

**FR-1.2:** AppDrawer must accept the following constructor parameters:
- `cart` (Cart) - Required, used for cart-related navigation logic
- `currentRoute` (String) - Required, used to highlight the active menu item

**FR-1.3:** AppDrawer must contain a `Drawer` widget with the following structure:
- `DrawerHeader` at the top
- `ListView` containing navigation menu items

**FR-1.4:** DrawerHeader must display:
- App icon using `Icons.storefront` or similar (size 48-64)
- App title "Sandwich Shop" using `heading1` style
- Optional subtitle using `normalText` style
- Background color distinct from menu items (e.g., primary color or gradient)
- Appropriate padding (minimum 16px all sides)

**FR-1.5:** Navigation menu must contain exactly four `ListTile` items in order:
1. **Home** - Icon: `Icons.home` or `Icons.restaurant_menu`, Label: "Home"
2. **My Cart** - Icon: `Icons.shopping_cart`, Label: "My Cart"
3. **Account** - Icon: `Icons.person` or `Icons.account_circle`, Label: "Account"
4. **About Us** - Icon: `Icons.info` or `Icons.info_outline`, Label: "About Us"

**FR-1.6:** Each `ListTile` must:
- Display an icon on the left
- Display a label text
- Have an `onTap` handler that performs navigation
- Use the `selected` property to highlight when `currentRoute` matches
- Apply distinct styling when selected (different background color or text color)

**FR-1.7:** Home menu item tap behavior:
- If `currentRoute != '/home'`: Call `Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => OrderScreen(...)), (route) => false)`
- If `currentRoute == '/home'`: Only close drawer with `Navigator.pop(context)`

**FR-1.8:** My Cart menu item tap behavior:
- If `cart.isEmpty`: Show SnackBar "Your cart is empty" and only close drawer
- If `cart.isNotEmpty`: Close drawer and navigate to CartScreen with `Navigator.push()`, passing cart object

**FR-1.9:** Account menu item tap behavior:
- Close drawer with `Navigator.pop(context)`
- Navigate to AuthScreen with `Navigator.push(context, MaterialPageRoute(builder: (context) => AuthScreen()))`

**FR-1.10:** About Us menu item tap behavior:
- Close drawer with `Navigator.pop(context)`
- Navigate using named route: `Navigator.pushNamed(context, '/about')`

**FR-1.11:** Optional - Cart Badge:
- Display a `Badge` widget on the My Cart icon when `cart.countOfItems > 0`
- Badge should show the item count as a number
- Badge should be small and positioned on top-right of the cart icon

### 3.2 Responsive Scaffold Widget (`lib/views/responsive_layout.dart`)

**FR-2.1:** Create a new `ResponsiveScaffold` StatelessWidget in `lib/views/responsive_layout.dart`

**FR-2.2:** ResponsiveScaffold must accept the following constructor parameters:
- `appBar` (PreferredSizeWidget) - Required, the AppBar to display
- `body` (Widget) - Required, the main screen content
- `cart` (Cart) - Required, for passing to navigation components
- `currentRoute` (String) - Required, for highlighting current location

**FR-2.3:** ResponsiveScaffold must use `MediaQuery.of(context).size.width` to determine screen width

**FR-2.4:** ResponsiveScaffold must define layout breakpoints:
- Mobile/Tablet: `screenWidth < 840`
- Desktop: `screenWidth >= 840`

**FR-2.5:** For Mobile/Tablet layout (`screenWidth < 840`):
- Return a standard `Scaffold` widget
- Include `appBar` parameter in AppBar property
- Include `drawer` property with `AppDrawer(cart: cart, currentRoute: currentRoute)`
- Include `body` parameter in body property
- Hamburger menu icon automatically appears in AppBar (Flutter default)

**FR-2.6:** For Desktop layout (`screenWidth >= 840`):
- Return a `Scaffold` with AppBar and custom body layout
- Body must be a `Row` containing:
  - Navigation component on the left (NavigationRail OR permanent Drawer)
  - `VerticalDivider` (thickness: 1, width: 1)
  - `Expanded` widget containing the `body` content
- Do NOT include `drawer` property in Scaffold
- AppBar should NOT show hamburger menu icon

**FR-2.7:** Desktop Navigation - Option A (NavigationRail approach):
- Use `NavigationRail` widget with:
  - `selectedIndex` calculated based on `currentRoute` (0=Home, 1=Cart, 2=Account, 3=About)
  - `onDestinationSelected` callback that navigates to corresponding screen
  - Four `NavigationRailDestination` items matching drawer menu items
  - Optional: Set `extended: true` for wider rail with full labels

**FR-2.8:** Desktop Navigation - Option B (Permanent Drawer approach):
- Wrap `AppDrawer` in a `SizedBox` with fixed width (e.g., 250px)
- Place directly in Row without Scaffold drawer property
- Drawer remains visible and doesn't slide

**FR-2.9:** Navigation logic in desktop layout must:
- Close any open dialogs before navigating
- Navigate to the correct screen based on index/tap
- Pass cart object where needed
- Handle empty cart case for Cart navigation (show SnackBar)

**FR-2.10:** Responsive transitions must be smooth:
- No flickering when screen size changes
- State is preserved during layout transitions
- Cart contents are not lost

### 3.3 Screen Integration

**FR-3.1:** Modify the following screen files to use `ResponsiveScaffold`:
- `lib/views/order_screen.dart`
- `lib/views/cart_screen.dart`
- `lib/views/checkout_screen.dart`
- `lib/views/auth_screen.dart`
- `lib/views/about_screen.dart`

**FR-3.2:** Replace each screen's `Scaffold` widget with `ResponsiveScaffold` maintaining:
- Existing AppBar configuration
- Existing body content
- Appropriate cart reference (`_cart`, `widget.cart`, or new `Cart()`)
- Correct currentRoute value

**FR-3.3:** Route name constants for each screen:
- Order Screen: `'/'` or `'/home'`
- Cart Screen: `'/cart'`
- Checkout Screen: `'/checkout'`
- Auth Screen: `'/auth'`
- About Screen: `'/about'`

**FR-3.4:** Cart object handling per screen:
- **OrderScreen**: Pass `_cart` (local instance variable)
- **CartScreen**: Pass `widget.cart` (received as parameter)
- **CheckoutScreen**: Pass `widget.cart` (received as parameter)
- **AuthScreen**: Pass `Cart()` (new empty instance) OR make cart optional in ResponsiveScaffold
- **AboutScreen**: Pass `Cart()` (new empty instance) OR make cart optional in ResponsiveScaffold

**FR-3.5:** All screens must preserve existing functionality:
- No breaking changes to current features
- Navigation between screens still works as before
- Back button behavior remains consistent
- Cart state management unchanged (except now shared across navigation)

### 3.4 Styling and Visual Design

**FR-4.1:** All navigation components must use existing styles from `app_styles.dart`:
- `heading1` for drawer header title
- `heading2` for menu item labels (if custom styling needed)
- `normalText` for drawer header subtitle

**FR-4.2:** Add new style constants to `app_styles.dart` if needed:
- `drawerHeaderBackground` - Color for drawer header
- `selectedMenuItemBackground` - Color for highlighted menu item
- `navigationRailBackground` - Background color for NavigationRail

**FR-4.3:** Visual highlighting for selected menu item must be clear:
- Use `ListTile.selected = true` when `currentRoute` matches
- Apply a distinct color (e.g., `Colors.blue.shade100` or theme primary color with opacity)
- Ensure text contrast meets accessibility standards

**FR-4.4:** Icon sizes must be consistent:
- Drawer header icon: 48-64 logical pixels
- Menu item icons: 24 logical pixels (default)
- NavigationRail icons: 24 logical pixels (default)

**FR-4.5:** Spacing and padding:
- Drawer header padding: 16px minimum on all sides
- Menu items: Use default ListTile padding
- NavigationRail: Use default spacing or customize for brand consistency

**FR-4.6:** Desktop NavigationRail visual requirements:
- Use theme colors for consistency
- Selected item should have clear visual indicator
- Ensure adequate contrast between background and content

### 3.5 Navigation Behavior and State Management

**FR-5.1:** Navigation stack management:
- Home navigation must clear stack: `Navigator.pushAndRemoveUntil(..., (route) => false)`
- Other navigation should allow back: `Navigator.push(...)`
- Named route navigation: `Navigator.pushNamed(...)`

**FR-5.2:** Drawer closing sequence:
- Always call `Navigator.pop(context)` before navigating to close drawer
- Use `await` if needed to ensure drawer closes before navigation
- Prevent navigation stutter by proper sequencing

**FR-5.3:** Cart state must persist across all navigation:
- Cart object passed through widget tree (no global state)
- Same cart instance shared when possible
- Cart modifications reflected immediately in navigation badge (if implemented)

**FR-5.4:** Screen size detection must be reactive:
- Use `MediaQuery.of(context).size.width` in build method
- Layout updates automatically when screen size changes
- No manual refresh required

**FR-5.5:** Route highlighting logic:
- Each screen must pass its route identifier to ResponsiveScaffold
- ResponsiveScaffold passes route to AppDrawer
- AppDrawer compares route to each menu item
- Selected item gets `selected: true` property

### 3.6 Error Handling and Edge Cases

**FR-6.1:** Handle null or empty cart gracefully:
- Check `cart.isEmpty` before cart navigation
- Show user-friendly message when attempting to view empty cart
- Don't crash if cart is null (use null-safety operators)

**FR-6.2:** Handle rapid navigation taps:
- Prevent multiple simultaneous navigation operations
- Ignore taps while navigation is in progress
- Use proper async/await patterns

**FR-6.3:** Handle screen rotation and resizing:
- Layout must adapt without losing state
- Cart contents preserved during orientation change
- Current screen remains the same
- No crashes during rapid resizing

**FR-6.4:** Handle back button behavior:
- On mobile: If drawer is open, back button closes drawer (not navigation)
- On desktop: Back button performs standard navigation (no drawer to close)
- Ensure Flutter's default back button handling is preserved

**FR-6.5:** Handle case where cart is null (for screens without cart):
- Make cart parameter optional in ResponsiveScaffold: `Cart? cart`
- Handle null case in drawer: disable or hide cart navigation if cart is null
- Provide default empty cart if needed

---

## 4. Non-Functional Requirements

### 4.1 Performance

**NFR-1.1:** Drawer animation must be smooth (60fps)
- Opening/closing drawer should not drop frames
- No lag when tapping hamburger menu or closing drawer

**NFR-1.2:** Screen size detection must be efficient
- MediaQuery should not cause unnecessary rebuilds
- Layout transitions should complete within 300ms

**NFR-1.3:** Navigation operations must be fast
- Screen transitions should complete within 500ms
- No noticeable delay between tap and navigation start

**NFR-1.4:** Responsive layout switching must be seamless
- No flickering during layout transitions
- Smooth transition between drawer and navigation rail

### 4.2 Usability

**NFR-2.1:** Touch targets must be adequately sized
- All interactive elements minimum 48x48 logical pixels
- Easy to tap on mobile devices without precision

**NFR-2.2:** Visual feedback must be immediate
- Menu items show pressed state on tap
- Selected item highlighting is clearly visible
- Icons are intuitive and recognizable

**NFR-2.3:** Navigation patterns must be intuitive
- Follows Material Design guidelines
- Matches user expectations for drawer/rail behavior
- Clear visual hierarchy in navigation menu

**NFR-2.4:** Consistency across devices
- Same functionality on mobile, tablet, and desktop
- Only layout pattern changes, not features
- All navigation options available on all devices

### 4.3 Accessibility

**NFR-3.1:** Screen reader support
- All navigation items must have semantic labels
- Drawer header content should be properly announced
- Selected item state should be announced

**NFR-3.2:** Keyboard navigation (desktop)
- NavigationRail items should be keyboard-accessible
- Tab order should be logical
- Enter/Space should activate navigation items

**NFR-3.3:** Color contrast
- Text on backgrounds must meet WCAG AA standards (4.5:1 ratio)
- Icons must be distinguishable from background
- Selected state must be visible to colorblind users (not rely on color alone)

**NFR-3.4:** Focus indicators
- Keyboard focus should be visible
- Focus order should be logical
- Focus should not get trapped in drawer

### 4.4 Maintainability

**NFR-4.1:** Code organization
- Navigation logic centralized in AppDrawer and ResponsiveScaffold
- No duplication of navigation code across screens
- Clear separation of concerns

**NFR-4.2:** Code readability
- Well-named variables and methods
- Clear comments for complex logic
- Consistent code style with existing project

**NFR-4.3:** Extensibility
- Easy to add new navigation items
- Easy to modify navigation behavior
- Easy to customize styling

**NFR-4.4:** Testing
- Navigation logic should be testable
- Layout switching logic should be testable
- Edge cases should be handled gracefully

### 4.5 Compatibility

**NFR-5.1:** Platform support
- Must work on Android (all drawer navigation)
- Must work on iOS (all drawer navigation)
- Must work on Web (responsive layouts)
- Must work on Windows/Mac/Linux desktop (responsive layouts)

**NFR-5.2:** Screen size support
- Minimum supported width: 360px (small phones)
- Maximum supported width: No limit (ultra-wide monitors)
- Portrait and landscape orientations

**NFR-5.3:** Flutter version compatibility
- Compatible with current Flutter stable channel
- No deprecated APIs used
- Future-proof implementation

---

## 5. User Acceptance Criteria

### 5.1 Drawer Functionality (Mobile/Tablet)

✅ **UAC-1:** Hamburger menu icon appears in AppBar on all screens when width < 840px

✅ **UAC-2:** Tapping hamburger icon opens drawer with smooth slide-in animation

✅ **UAC-3:** Drawer displays branded header with app icon and "Sandwich Shop" title

✅ **UAC-4:** Drawer displays all four navigation items (Home, My Cart, Account, About)

✅ **UAC-5:** Current screen is visually highlighted in drawer menu

✅ **UAC-6:** Tapping any menu item closes drawer and navigates to correct screen

✅ **UAC-7:** Tapping outside drawer or back button closes drawer without navigation

✅ **UAC-8:** Cart navigation shows SnackBar when cart is empty and doesn't navigate

✅ **UAC-9:** Cart navigation works correctly when cart has items

✅ **UAC-10:** All navigation preserves cart contents

### 5.2 Responsive Desktop Layout

✅ **UAC-11:** Permanent navigation appears on left when width ≥ 840px

✅ **UAC-12:** No hamburger icon appears in AppBar on desktop layout

✅ **UAC-13:** Navigation rail/sidebar shows all four navigation options

✅ **UAC-14:** Current screen is highlighted in navigation rail/sidebar

✅ **UAC-15:** Clicking navigation items updates main content area

✅ **UAC-16:** Main content appears to the right of navigation

✅ **UAC-17:** Navigation remains visible and functional at all times on desktop

### 5.3 Responsive Transitions

✅ **UAC-18:** Resizing window from desktop to mobile width switches layout correctly

✅ **UAC-19:** Resizing window from mobile to desktop width switches layout correctly

✅ **UAC-20:** Device rotation triggers correct layout for new orientation

✅ **UAC-21:** Cart contents preserved during layout transitions

✅ **UAC-22:** Current screen preserved during layout transitions

✅ **UAC-23:** No flickering or visual glitches during transitions

### 5.4 Integration with Existing Screens

✅ **UAC-24:** Order Screen integrates navigation without breaking existing functionality

✅ **UAC-25:** Cart Screen integrates navigation without breaking cart management features

✅ **UAC-26:** Checkout Screen integrates navigation without breaking payment flow

✅ **UAC-27:** Auth Screen integrates navigation without breaking form validation

✅ **UAC-28:** About Screen integrates navigation correctly

✅ **UAC-29:** All existing navigation (buttons, back navigation) still works

✅ **UAC-30:** No regression in any existing features

### 5.5 Code Quality

✅ **UAC-31:** No code duplication across screen files

✅ **UAC-32:** AppDrawer widget is reusable and well-structured

✅ **UAC-33:** ResponsiveScaffold widget properly encapsulates layout logic

✅ **UAC-34:** All screens use ResponsiveScaffold consistently

✅ **UAC-35:** Code follows project conventions and style guidelines

✅ **UAC-36:** No compiler warnings or errors

✅ **UAC-37:** Proper disposal of resources (controllers, listeners)

### 5.6 Visual and UX Quality

✅ **UAC-38:** Navigation styling is consistent with app theme

✅ **UAC-39:** Selected item highlighting is clear and visible

✅ **UAC-40:** Icons are appropriate and intuitive

✅ **UAC-41:** Spacing and padding provide good visual hierarchy

✅ **UAC-42:** Touch targets are adequately sized (minimum 48x48dp)

✅ **UAC-43:** Animations are smooth and professional

✅ **UAC-44:** Color contrast meets accessibility standards

---

## 6. Testing Requirements

### 6.1 Functional Testing Scenarios

#### Test Scenario 1: Mobile Drawer Navigation - Complete Flow
1. Open app on mobile device (or browser at 600px width)
2. Verify hamburger icon appears in AppBar on Order Screen
3. Tap hamburger icon
4. Verify drawer slides in from left
5. Verify drawer header shows "Sandwich Shop" with icon
6. Verify all four menu items are visible
7. Verify "Home" is highlighted (current screen)
8. Add 2 items to cart
9. Tap "My Cart" in drawer
10. Verify drawer closes
11. Verify navigation to Cart Screen
12. Verify 2 items appear in cart
13. Open drawer again
14. Verify "My Cart" is now highlighted
15. Tap "Home" in drawer
16. Verify return to Order Screen
17. Verify cart still has 2 items
18. Open drawer, tap "Account"
19. Verify navigation to Auth Screen
20. Open drawer, tap "About Us"
21. Verify navigation to About Screen
22. Use back button to return through navigation history
23. Verify cart contents preserved throughout

#### Test Scenario 2: Empty Cart Handling
1. Start with empty cart on Order Screen
2. Open drawer
3. Tap "My Cart"
4. Verify drawer closes
5. Verify SnackBar appears: "Your cart is empty"
6. Verify no navigation occurs (still on Order Screen)
7. Verify SnackBar disappears after 2-3 seconds

#### Test Scenario 3: Desktop Layout - Permanent Navigation
1. Open app in browser at 1920px width
2. Verify no hamburger icon in AppBar
3. Verify permanent navigation rail/sidebar visible on left
4. Verify main content on right side of navigation
5. Verify "Home" is highlighted in navigation
6. Add items to cart
7. Click "My Cart" in navigation
8. Verify main content updates to show Cart Screen
9. Verify navigation remains visible
10. Verify "My Cart" now highlighted
11. Click "Account" in navigation
12. Verify main content updates to Auth Screen
13. Verify navigation remains visible
14. Click "About Us" in navigation
15. Verify main content updates to About Screen
16. Click "Home" in navigation
17. Verify return to Order Screen
18. Verify cart contents preserved

#### Test Scenario 4: Responsive Transition - Mobile to Desktop
1. Open app in browser at 600px width (mobile layout)
2. Verify hamburger icon visible
3. Add 3 items to cart
4. Navigate to Cart Screen via drawer
5. Slowly resize browser to 1000px width
6. Observe layout transition at 840px breakpoint
7. Verify hamburger icon disappears
8. Verify permanent navigation rail appears
9. Verify main content adjusts to share screen
10. Verify still on Cart Screen (no navigation occurred)
11. Verify cart still has 3 items
12. Verify "My Cart" is highlighted in navigation rail
13. Verify no visual glitches during transition

#### Test Scenario 5: Responsive Transition - Desktop to Mobile
1. Open app in browser at 1200px width (desktop layout)
2. Verify permanent navigation visible
3. Navigate to different screens, verify highlighting
4. Slowly resize browser to 600px width
5. Observe layout transition at 840px breakpoint
6. Verify permanent navigation disappears
7. Verify hamburger icon appears
8. Verify main content expands to full width
9. Verify current screen preserved
10. Open drawer
11. Verify correct screen is highlighted
12. Verify cart contents preserved

#### Test Scenario 6: Navigation Stack Management
1. Start on Order Screen (Home)
2. Use drawer to navigate: Home → Cart → Account → About
3. Press back button repeatedly
4. Verify navigation goes: About → Account → Cart → Order (home)
5. From Order Screen, use drawer to navigate to About
6. Open drawer, tap "Home"
7. Press back button
8. Verify app exits (no navigation stack remaining - correct behavior for Home)

#### Test Scenario 7: Cart Badge Display (If Implemented)
1. Start with empty cart
2. Open drawer
3. Verify no badge on "My Cart" item
4. Close drawer, add 1 item to cart
5. Open drawer
6. Verify badge shows "1" on cart icon
7. Close drawer, add 2 more items (3 total)
8. Open drawer
9. Verify badge shows "3"
10. Navigate to cart, remove all items
11. Open drawer
12. Verify badge is hidden again

#### Test Scenario 8: Multiple Screen Integration
1. Test drawer on Order Screen - verify correct route passed
2. Test drawer on Cart Screen - verify correct route passed
3. Test drawer on Checkout Screen - verify correct route passed
4. Test drawer on Auth Screen - verify correct route passed
5. Test drawer on About Screen - verify correct route passed
6. Verify highlighting works correctly on each screen
7. Verify navigation works from each screen to all others
8. Verify cart state preserved throughout all navigation

### 6.2 Edge Case Testing

**Edge Case 1: Rapid Menu Tapping**
- Open drawer, rapidly tap multiple menu items
- Expected: Only first tap should register, no crashes or navigation errors

**Edge Case 2: Back Button While Drawer Opening**
- Tap hamburger icon, immediately press back button
- Expected: Drawer animation stops, drawer closes, no navigation

**Edge Case 3: Screen Rotation During Drawer Open**
- Open drawer on mobile
- Rotate device to landscape
- Expected: Drawer remains functional or closes gracefully based on new width

**Edge Case 4: Null Cart Handling**
- Navigate to screen where cart is null (if applicable)
- Open navigation
- Tap "My Cart"
- Expected: Graceful handling (disabled, or shows "cart unavailable" message)

**Edge Case 5: Very Narrow Screen**
- Set browser width to 320px (very small phone)
- Open drawer
- Expected: Drawer and content remain usable, no overflow errors

**Edge Case 6: Ultra-Wide Screen**
- Set browser width to 3840px (4K monitor)
- Expected: Navigation rail remains reasonable size, content scales appropriately

**Edge Case 7: Rapid Resizing**
- Rapidly resize browser window back and forth across 840px breakpoint
- Expected: No crashes, layout switches smoothly, no state loss

### 6.3 Visual Testing Checklist

- [ ] Drawer header has appropriate background color and padding
- [ ] App icon in drawer header is properly sized and visible
- [ ] Menu items are properly aligned and spaced
- [ ] Icons are appropriate size and clearly visible
- [ ] Selected item highlighting is clearly distinguishable
- [ ] Text in drawer is readable (good contrast)
- [ ] NavigationRail on desktop has appropriate width
- [ ] NavigationRail icons and labels are aligned properly
- [ ] Main content doesn't overlap with navigation rail
- [ ] VerticalDivider between navigation and content is visible
- [ ] Drawer animation is smooth (no stuttering)
- [ ] Layout transition from mobile to desktop is smooth
- [ ] No visual artifacts during screen size changes
- [ ] Consistent styling across all screens

### 6.4 Accessibility Testing

- [ ] Screen reader announces drawer opening/closing
- [ ] Screen reader announces each menu item correctly
- [ ] Screen reader announces selected item state
- [ ] Keyboard tab order is logical in navigation rail
- [ ] Keyboard Enter/Space activates navigation items
- [ ] Focus indicators are visible on navigation items
- [ ] Color contrast meets WCAG AA standards
- [ ] Selected state is distinguishable without relying on color alone
- [ ] Touch targets are minimum 48x48 pixels

### 6.5 Performance Testing

- [ ] Drawer opens within 300ms of tapping hamburger icon
- [ ] Navigation completes within 500ms of tapping menu item
- [ ] Layout transition completes within 300ms of resizing
- [ ] No frame drops during drawer animation
- [ ] No frame drops during layout transition
- [ ] App remains responsive during all navigation operations
- [ ] Memory usage remains stable after multiple navigations

---

## 7. Implementation Checklist

### Phase 1: Create Reusable Drawer
- [ ] Create `lib/views/app_drawer.dart` file
- [ ] Implement `AppDrawer` StatelessWidget with constructor parameters
- [ ] Implement `DrawerHeader` with branding
- [ ] Implement four navigation menu items with icons and labels
- [ ] Implement highlighting logic based on `currentRoute`
- [ ] Implement navigation handlers for each menu item
- [ ] Implement empty cart handling for cart navigation
- [ ] Test AppDrawer in isolation by adding to one screen

### Phase 2: Create Responsive Layout
- [ ] Create `lib/views/responsive_layout.dart` file
- [ ] Implement `ResponsiveScaffold` StatelessWidget with constructor parameters
- [ ] Implement screen width detection using MediaQuery
- [ ] Implement mobile/tablet layout (standard Scaffold with drawer)
- [ ] Implement desktop layout (Row with NavigationRail/permanent drawer)
- [ ] Implement navigation logic in desktop layout
- [ ] Test responsive behavior by resizing browser window

### Phase 3: Integrate with Screens
- [ ] Refactor `order_screen.dart` to use ResponsiveScaffold
- [ ] Refactor `cart_screen.dart` to use ResponsiveScaffold
- [ ] Refactor `checkout_screen.dart` to use ResponsiveScaffold
- [ ] Refactor `auth_screen.dart` to use ResponsiveScaffold
- [ ] Refactor `about_screen.dart` to use ResponsiveScaffold
- [ ] Ensure correct cart object passed to each screen
- [ ] Ensure correct route identifier passed to each screen
- [ ] Test navigation from each screen to all others

### Phase 4: Styling and Polish
- [ ] Add any new color/style constants to `app_styles.dart`
- [ ] Apply consistent styling to drawer header
- [ ] Apply consistent styling to menu items
- [ ] Apply consistent styling to NavigationRail
- [ ] Ensure selected item highlighting is clear
- [ ] Verify color contrast for accessibility
- [ ] Add cart badge to menu item (if implementing)

### Phase 5: Testing and Refinement
- [ ] Execute all functional test scenarios
- [ ] Execute all edge case tests
- [ ] Execute visual testing checklist
- [ ] Execute accessibility testing checklist
- [ ] Execute performance testing checklist
- [ ] Fix any bugs discovered
- [ ] Verify no regressions in existing features
- [ ] Get user feedback and iterate

### Phase 6: Documentation and Cleanup
- [ ] Add code comments for complex logic
- [ ] Remove any debug print statements
- [ ] Remove unused imports
- [ ] Verify no compiler warnings
- [ ] Update any relevant documentation (README, etc.)

---

## 8. Definition of Done

The feature is considered complete and ready for deployment when:

1. ✅ All code files (`app_drawer.dart`, `responsive_layout.dart`) are created
2. ✅ All five screens are refactored to use `ResponsiveScaffold`
3. ✅ All functional requirements (FR-1.1 through FR-6.5) are implemented
4. ✅ All user stories have passing acceptance criteria
5. ✅ All user acceptance criteria (UAC-1 through UAC-44) are verified
6. ✅ All test scenarios pass without errors
7. ✅ No regressions in existing features
8. ✅ Code compiles without errors or warnings
9. ✅ Drawer navigation works on mobile/tablet layout
10. ✅ Permanent navigation works on desktop layout
11. ✅ Responsive transitions work smoothly
12. ✅ Cart state is preserved across all navigation
13. ✅ Visual design is consistent and polished
14. ✅ Accessibility requirements are met
15. ✅ Performance requirements are met
16. ✅ Code follows project conventions
17. ✅ No code duplication across screens
18. ✅ Navigation logic is centralized
19. ✅ User testing completed with positive feedback
20. ✅ All documentation updated

---

## 9. Out of Scope

The following items are explicitly **NOT** included in this implementation:

### Navigation Features
- Breadcrumb navigation
- Navigation history/recent items
- Customizable navigation menu (user-defined shortcuts)
- Multi-level or nested navigation menus
- Context-sensitive navigation options

### Advanced Responsive Features
- Three-column layouts for very large screens
- Adaptive icon sizes based on screen density
- Different navigation patterns for tablet landscape vs portrait
- Picture-in-picture or split-screen modes

### Cart Features
- Real-time cart synchronization across devices
- Cart badge animations
- Shopping cart quick preview in drawer
- Mini-cart display in navigation

### User Features
- User profile picture in drawer header
- Personalized navigation based on user preferences
- Recently viewed items in navigation
- Quick actions or shortcuts in drawer

### Technical Features
- Route transition animations customization
- Programmatic drawer control from child widgets
- Navigation state persistence across app restarts
- Deep linking integration with drawer navigation
- Navigation analytics tracking

### Authentication Integration
- Role-based navigation (different menus for different user types)
- Conditional menu items based on login state
- Protected routes requiring authentication

### Future Enhancements
- Dark mode toggle in drawer
- Language selector in drawer
- Settings screen access from drawer
- Help/support section in drawer
- Notification center in navigation

These features may be considered for future iterations after the core navigation system is established and validated.

---

## 10. Dependencies and Prerequisites

### External Dependencies
- No new package dependencies required
- Uses existing Flutter Material package
- Uses existing app models (Cart, Sandwich)

### Internal Dependencies
- Requires existing screens: OrderScreen, CartScreen, CheckoutScreen, AuthScreen, AboutScreen
- Requires existing models: Cart (with countOfItems, isEmpty properties)
- Requires existing styles: app_styles.dart
- Requires existing navigation setup in main.dart

### Prerequisites
- All existing screens must be functional
- Cart model must have necessary properties and methods
- Named route for About screen must exist in main.dart
- App must compile and run without errors before starting

---

## 11. Risks and Mitigation

### Risk 1: Breaking Existing Navigation
**Impact:** High  
**Likelihood:** Medium  
**Mitigation:**
- Test existing navigation before and after changes
- Implement feature branch and test thoroughly before merging
- Keep backup of original screen files
- Implement changes incrementally (one screen at a time)

### Risk 2: Performance Issues on Low-End Devices
**Impact:** Medium  
**Likelihood:** Low  
**Mitigation:**
- Test on variety of devices (low-end to high-end)
- Profile app performance before and after changes
- Optimize any identified bottlenecks
- Use const constructors where possible to reduce rebuilds

### Risk 3: Responsive Layout Not Working on All Screen Sizes
**Impact:** Medium  
**Likelihood:** Medium  
**Mitigation:**
- Test on multiple screen sizes during development
- Use Flutter's device preview tools
- Test on actual devices (phone, tablet, desktop)
- Have fallback layout if MediaQuery fails

### Risk 4: Cart State Loss During Navigation
**Impact:** High  
**Likelihood:** Low  
**Mitigation:**
- Careful cart object passing through widget tree
- Test cart preservation after every navigation operation
- Add assertions to verify cart is not null where expected
- Consider implementing cart state provider if issues persist

### Risk 5: Confusion About Current Location
**Impact:** Low  
**Likelihood:** Low  
**Mitigation:**
- Implement clear highlighting for current screen
- Ensure AppBar title accurately reflects current screen
- Test with actual users to verify clarity
- Adjust highlighting styling if users report confusion

---

## 12. Success Metrics (Post-Implementation)

After implementation, success can be measured by:

### Quantitative Metrics
- **Code Reduction**: Measure lines of navigation code removed through centralization
- **Navigation Usage**: Track which navigation items are used most frequently
- **Screen Transitions**: Measure time spent navigating vs. time on content screens
- **Error Rate**: Monitor crash reports related to navigation (should be zero)
- **Performance**: Measure frame rate during drawer animations (should be 60fps)

### Qualitative Metrics
- **User Feedback**: Survey users about ease of navigation
- **Usability Testing**: Observe users navigating the app, count successful vs. failed attempts
- **Developer Feedback**: Assess ease of maintaining navigation code
- **Code Quality**: Review code for duplication, clarity, and maintainability

### Key Performance Indicators (KPIs)
- 95%+ of users can successfully navigate to cart from any screen
- 100% of responsive layout transitions complete without errors
- 0 navigation-related crashes in production
- <500ms average navigation time from tap to screen load
- 90%+ developer satisfaction with code maintainability

---

## 13. Maintenance and Support

### Ongoing Maintenance Tasks
- Monitor crash reports for navigation-related issues
- Update navigation icons if Material Design guidelines change
- Adjust responsive breakpoints based on usage analytics
- Add new navigation items as app features expand

### Support Considerations
- Provide clear documentation for adding new navigation items
- Create guide for modifying responsive breakpoints
- Document cart state management approach
- Provide troubleshooting guide for common navigation issues

### Future Enhancement Path
1. Add navigation usage analytics
2. Implement personalized navigation based on user behavior
3. Add quick actions or shortcuts in navigation
4. Implement bottom navigation bar for mobile (alternative pattern)
5. Add navigation gestures (swipe to open drawer, etc.)
6. Integrate with deep linking for external navigation

---

## End of Requirements Document