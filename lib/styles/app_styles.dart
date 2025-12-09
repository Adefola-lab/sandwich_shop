import 'package:flutter/material.dart';

// ============================================================================
// TEXT STYLES
// ============================================================================

/// Large heading style for screen titles and drawer header
const TextStyle heading1 = TextStyle(
  fontSize: 24,
  fontWeight: FontWeight.bold,
  color: Colors.black87,
);

/// Medium heading style for section headers
const TextStyle heading2 = TextStyle(
  fontSize: 20,
  fontWeight: FontWeight.w600,
  color: Colors.black87,
);

/// Normal body text style
const TextStyle normalText = TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.normal,
  color: Colors.black87,
);

/// Small text style for labels and hints
const TextStyle smallText = TextStyle(
  fontSize: 14,
  fontWeight: FontWeight.normal,
  color: Colors.black54,
);

/// Drawer header subtitle style
const TextStyle drawerSubtitle = TextStyle(
  fontSize: 14,
  fontWeight: FontWeight.normal,
  color: Colors.black54,
);

/// Navigation menu item text style
const TextStyle menuItemText = TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.w500,
  color: Colors.black87,
);

// ============================================================================
// COLORS
// ============================================================================

/// Primary brand color
const Color primaryColor = Color(0xFF2196F3); // Blue

/// Primary color variant for lighter backgrounds
const Color primaryColorLight = Color(0xFFBBDEFB); // Light Blue

/// Accent color for highlights and CTAs
const Color accentColor = Color(0xFFFF9800); // Orange

/// Background color for drawer header
const Color drawerHeaderBackground = Color(0xFFE3F2FD); // Very Light Blue

/// Background color for selected menu item
const Color selectedMenuItemBackground = Color(0xFFE3F2FD); // Very Light Blue

/// Background color for navigation rail (desktop)
const Color navigationRailBackground = Color(0xFFFAFAFA); // Very Light Grey

/// Divider color
const Color dividerColor = Color(0xFFE0E0E0); // Light Grey

/// Error color for validation messages
const Color errorColor = Color(0xFFD32F2F); // Red

/// Success color for confirmations
const Color successColor = Color(0xFF388E3C); // Green

// ============================================================================
// SPACING AND DIMENSIONS
// ============================================================================

/// Standard padding for most containers
const double standardPadding = 16.0;

/// Small padding for compact layouts
const double smallPadding = 8.0;

/// Large padding for spacious layouts
const double largePadding = 24.0;

/// Minimum touch target size (accessibility)
const double minTouchTarget = 48.0;

/// Drawer header height
const double drawerHeaderHeight = 160.0;

/// Navigation rail width when extended
const double navigationRailWidth = 250.0;

/// Icon size for drawer header
const double drawerHeaderIconSize = 56.0;

/// Icon size for menu items
const double menuIconSize = 24.0;

/// Border radius for cards and containers
const double borderRadius = 8.0;

// ============================================================================
// UTILITY FUNCTIONS
// ============================================================================

/// Returns a BoxDecoration for cards and containers
BoxDecoration cardDecoration({Color? color}) {
  return BoxDecoration(
    color: color ?? Colors.white,
    borderRadius: BorderRadius.circular(borderRadius),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.1),
        blurRadius: 4,
        offset: const Offset(0, 2),
      ),
    ],
  );
}

/// Returns a TextStyle with custom color
TextStyle textStyleWithColor(TextStyle baseStyle, Color color) {
  return baseStyle.copyWith(color: color);
}

// ============================================================================
// THEME DATA
// ============================================================================

/// App-wide theme configuration
ThemeData get appTheme => ThemeData(
  primaryColor: primaryColor,
  primaryColorLight: primaryColorLight,
  colorScheme: ColorScheme.fromSeed(
    seedColor: primaryColor,
    secondary: accentColor,
  ),
  scaffoldBackgroundColor: Colors.white,
  appBarTheme: const AppBarTheme(
    backgroundColor: primaryColor,
    foregroundColor: Colors.white,
    elevation: 2,
    centerTitle: false,
    titleTextStyle: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: Colors.white,
    ),
  ),
  drawerTheme: const DrawerThemeData(
    backgroundColor: Colors.white,
    elevation: 16,
  ),
  listTileTheme: const ListTileThemeData(
    contentPadding: EdgeInsets.symmetric(
      horizontal: standardPadding,
      vertical: smallPadding,
    ),
    iconColor: Colors.black54,
    textColor: Colors.black87,
    selectedColor: primaryColor,
    selectedTileColor: selectedMenuItemBackground,
  ),
  navigationRailTheme: const NavigationRailThemeData(
    backgroundColor: navigationRailBackground,
    selectedIconTheme: IconThemeData(
      color: primaryColor,
      size: menuIconSize,
    ),
    unselectedIconTheme: IconThemeData(
      color: Colors.black54,
      size: menuIconSize,
    ),
    selectedLabelTextStyle: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: primaryColor,
    ),
    unselectedLabelTextStyle: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.normal,
      color: Colors.black54,
    ),
  ),
  snackBarTheme: const SnackBarThemeData(
    backgroundColor: Colors.black87,
    contentTextStyle: TextStyle(
      fontSize: 14,
      color: Colors.white,
    ),
    behavior: SnackBarBehavior.floating,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(
        horizontal: largePadding,
        vertical: standardPadding,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      elevation: 2,
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: primaryColor,
      padding: const EdgeInsets.symmetric(
        horizontal: standardPadding,
        vertical: smallPadding,
      ),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(borderRadius),
    ),
    contentPadding: const EdgeInsets.symmetric(
      horizontal: standardPadding,
      vertical: standardPadding,
    ),
  ),
);
