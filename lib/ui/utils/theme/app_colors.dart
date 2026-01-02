import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static bool isDarkMode = true; // Dark mode first

  // ============================================
  // PREMIUM DARK MODE - MATERIAL DESIGN
  // ============================================

  /// Primary Colors - Indigo
  static const Color primary = Color(0xFF818CF8); // Indigo 400
  static const Color primaryDark = Color(0xFF6366F1); // Indigo 500
  static const Color primaryLight = Color(0xFFA5B4FC); // Indigo 300

  /// Background Colors - Premium Dark
  static const Color background = Color(0xFF050505); // Almost Black
  static const Color backgroundSecondary = Color(0xFF121212); // Material Dark Surface
  static const Color backgroundCard = Color(0xFF1A1A1A); // Card Background
  static const Color backgroundElevated = Color(0xFF242424); // Elevated Surface

  /// Text Colors - Material Dark
  static const Color textPrimary = Color(0xFFFFFFFF); // Pure White
  static const Color textSecondary = Color(0xFFB3B3B3); // Light Grey
  static const Color textTertiary = Color(0xFF808080); // Medium Grey
  static const Color textDisabled = Color(0xFF4D4D4D); // Dark Grey

  /// Accent Colors
  static const Color accent = Color(0xFF818CF8); // Indigo
  static const Color accentSecondary = Color(0xFFA78BFA); // Violet

  /// Status Colors - Material
  static const Color success = Color(0xFF4ADE80); // Green 400
  static const Color successDark = Color(0xFF22C55E); // Green 500
  static const Color successLight = Color(0xFF86EFAC); // Green 300

  static const Color error = Color(0xFFF87171); // Red 400
  static const Color errorDark = Color(0xFFEF4444); // Red 500
  static const Color errorLight = Color(0xFFFCA5A5); // Red 300

  static const Color warning = Color(0xFFFBBF24); // Amber 400
  static const Color warningDark = Color(0xFFF59E0B); // Amber 500
  static const Color warningLight = Color(0xFFFDE68A); // Amber 300

  static const Color info = Color(0xFF60A5FA); // Blue 400
  static const Color infoDark = Color(0xFF3B82F6); // Blue 500
  static const Color infoLight = Color(0xFF93C5FD); // Blue 300

  /// Utility Colors
  static const Color white = Color(0xFFFFFFFF); // Pure White
  static const Color pureWhite = Color(0xFFFFFFFF); // Pure White
  static const Color black = Color(0xFF000000); // Pure Black
  static const Color pureBlack = Color(0xFF000000); // Pure Black

  /// Grey Scale - Material Dark
  static const Color grey = Color(0xFF808080); // Medium Grey
  static const Color greyDark = Color(0xFF4D4D4D); // Dark Grey
  static const Color greyLight = Color(0xFFB3B3B3); // Light Grey
  static const Color greyMedium = Color(0xFF808080); // Medium Grey

  /// Border Colors
  static const Color borderColor = Color(0xFF2A2A2A); // Subtle Border
  static const Color borderLight = Color(0xFF333333); // Light Border
  static const Color borderDark = Color(0xFF1F1F1F); // Dark Border

  /// Divider Colors
  static const Color divider = Color(0xFF2A2A2A); // Divider
  static const Color dividerLight = Color(0xFF333333); // Light Divider

  /// Overlay Colors
  static const Color overlay = Color(0x80000000); // Dark Overlay
  static const Color overlayLight = Color(0x40000000); // Light Overlay
  static const Color overlayHeavy = Color(0xCC000000); // Heavy Overlay

  /// Transparent
  static const Color transparent = Color(0x00000000);

  // ============================================
  // LEGACY COLORS (For Compatibility)
  // ============================================

  static const Color secondary = Color(0xFFA78BFA); // Violet 400
  static const Color blue = Color(0xFF818CF8); // Indigo
  static const Color fontPrimaryColor = Color(0xFFFFFFFF); // White
  static const Color fontSecondaryColor = Color(0xFFB3B3B3); // Light Grey
  static const Color fontBlack = Color(0xFFFFFFFF); // White (inverted)

  static const Color clr7B7E91 = Color(0xFF808080);
  static const Color clr1C2142 = Color(0xFF1A1A1A);
  static const Color clrF1F1F1 = Color(0xFF1A1A1A); // Inverted
  static const Color clrFFE98E = Color(0xFFFBBF24);
  static const Color clrC2F3EC = Color(0xFF4ADE80);
  static const Color clr042930 = Color(0xFF121212);
  static const Color clr1A1A1A = Color(0xFF050505);
  static const Color clrEBEBEB = Color(0xFF1A1A1A);
  static const Color backgroundGrey = Color(0xFF1A1A1A);

  static const Color blackLight = Color(0x33FFFFFF); // Inverted for dark
  static const Color darkNavyBlue = Color(0xFF0F172A);

  static const Color redDark = Color(0xFFEF4444);
  static const Color redFF4A4A = Color(0xFFF87171);
  static const Color redLight = Color(0xFFFCA5A5);

  static const Color greenPrimary = Color(0xFF4ADE80);
  static const Color green = Color(0xFF22C55E);
  static const Color greenLight = Color(0xFF86EFAC);
  static const Color greenDim = Color(0xFF334155);
  static const Color greenDim2 = Color(0xFF1E293B);
  static const Color greyPrimary = Color(0xFF6B7280);

  static const Color greenDark = Color(0xFF166534);
  static const Color greenDark2 = Color(0xFF14532D);

  static const Color purple = Color(0xFFA78BFA); // Violet
  static const Color lightBlue = Color(0xFF60A5FA);
  static const Color textFieldLabelColor = Color(0xFFB3B3B3);
  static const Color errorColor = Color(0xFFF87171);
  static const Color orange = Color(0xFFFB923C);
  static const Color yellowDark = Color(0xFFF59E0B);
  static const Color yellowLight = Color(0xFFFDE68A);
  static const Color marron = Color(0xFFF87171);

  static const Color deliveredMarkerColor = Color(0xFF4ADE80);

  /// Shimmer - Dark Theme
  static final baseColor = const Color(0xFF1A1A1A);
  static final highlightColor = const Color(0xFF242424);

  /// Color Swatches - Indigo
  static MaterialColor colorPrimary = MaterialColor(0xFF818CF8, colorSwathes);

  static Map<int, Color> colorSwathes = {
    50: const Color.fromRGBO(129, 140, 248, .1),
    100: const Color.fromRGBO(129, 140, 248, .2),
    200: const Color.fromRGBO(129, 140, 248, .3),
    300: const Color.fromRGBO(129, 140, 248, .4),
    400: const Color.fromRGBO(129, 140, 248, .5),
    500: const Color.fromRGBO(129, 140, 248, .6),
    600: const Color.fromRGBO(129, 140, 248, .7),
    700: const Color.fromRGBO(129, 140, 248, .8),
    800: const Color.fromRGBO(129, 140, 248, .9),
    900: const Color.fromRGBO(129, 140, 248, 1),
  };

  // ============================================
  // THEME HELPERS
  // ============================================

  /// Get text color by theme
  static Color textByTheme() => isDarkMode ? textPrimary : black;

  /// Get main font color by theme
  static Color textMainFontByTheme() => isDarkMode ? textPrimary : black;

  /// Get scaffold background by theme
  static Color scaffoldBGByTheme() => isDarkMode ? background : white;

  /// Get card background by theme
  static Color cardBGByTheme() => isDarkMode ? backgroundCard : white;

  /// Get inverted text color
  static Color textWhiteByNewBlack2() => isDarkMode ? textPrimary : black;

  // ============================================
  // SPECIAL COLORS FOR FACE SCANNING
  // ============================================

  /// Face Scan Frame Colors
  static const Color scanFrameActive = Color(0xFF818CF8); // Indigo
  static const Color scanFrameSuccess = Color(0xFF4ADE80); // Green
  static const Color scanFrameError = Color(0xFFF87171); // Red

  /// Face Scan Overlay
  static const Color scanOverlay = Color(0xCC050505); // Dark Overlay
  static const Color scanOverlayLight = Color(0x80050505); // Light Overlay

  /// Face Scan Indicators
  static const Color scanIndicatorActive = Color(0xFF818CF8);
  static const Color scanIndicatorSuccess = Color(0xFF4ADE80);
  static const Color scanIndicatorError = Color(0xFFF87171);
  static const Color scanIndicatorWarning = Color(0xFFFBBF24);
}
