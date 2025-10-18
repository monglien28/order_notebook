import 'package:flutter/material.dart';

/// Palette (from your logo)
const Color kBeigePrimary = Color(0xFFF3DDAE); // main beige
const Color kBeigeLight = Color.fromRGBO(204, 180, 136, 1);
const Color kBeigeSurface = Color(0xFFF1DAA8);
const Color kBeigeAccent = Color(0xFFF2DBA9);
const Color kBrownDark = Color(0xFF5B3A2E); // outline / primary text color
const Color kBrownMedium = Color(0xFF70492F);
const Color kBrownSoft = Color(0xFF8B5E43);
const Color kSoftWhite = Color(0xFFFDF9F2);

final ThemeData notebookTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,

  // Core color fields
  primaryColor: kBeigePrimary,
  primaryColorLight: kBeigeLight,
  primaryColorDark: kBrownMedium,
  scaffoldBackgroundColor: kBeigeLight,
  canvasColor: kSoftWhite,
  cardColor: kBeigeSurface,
  dividerColor: kBrownSoft.withValues(alpha: 0.25),
  shadowColor: kBrownDark.withValues(alpha: 0.12),
  splashColor: kBeigePrimary.withValues(alpha: 0.12),
  highlightColor: kBeigePrimary.withValues(alpha: 0.08),
  hoverColor: kBeigePrimary.withValues(alpha: 0.06),
  focusColor: kBrownMedium.withValues(alpha: 0.12),
  hintColor: kBrownSoft.withValues(alpha: 0.6),
  disabledColor: Colors.grey.shade400,
  unselectedWidgetColor: kBrownSoft.withValues(alpha: 0.6),

  // Color scheme (keeps things consistent)
  colorScheme: ColorScheme(
    brightness: Brightness.light,
    primary: kBeigePrimary,
    onPrimary: kBrownDark,
    secondary: kBrownMedium,
    onSecondary: kSoftWhite,
    error: Colors.red.shade700,
    onError: Colors.white,
    surface: kBeigeSurface,
    onSurface: kBrownDark,
  ),

  // Text and typography
  typography: Typography.material2021(),
  textTheme: TextTheme(
    displayLarge: TextStyle(
      color: kBrownDark,
      fontSize: 28,
      fontWeight: FontWeight.bold,
    ),
    displayMedium: TextStyle(
      color: kBrownDark,
      fontSize: 22,
      fontWeight: FontWeight.w600,
    ),
    titleLarge: TextStyle(
      color: kBrownDark,
      fontSize: 18,
      fontWeight: FontWeight.w700,
    ),
    titleMedium: TextStyle(
      color: kBrownDark,
      fontSize: 16,
      fontWeight: FontWeight.w600,
    ),
    bodyLarge: TextStyle(color: kBrownDark, fontSize: 16),
    bodyMedium: TextStyle(color: kBrownDark, fontSize: 14),
    bodySmall: TextStyle(color: kBrownSoft, fontSize: 12),
    labelLarge: TextStyle(
      color: kBrownDark,
      fontSize: 14,
      fontWeight: FontWeight.w600,
    ),
  ),

  // Icon themes
  iconTheme: IconThemeData(color: kBrownDark, size: 20),
  primaryIconTheme: IconThemeData(color: kBrownDark, size: 22),
  actionIconTheme: null,

  // App bar
  appBarTheme: AppBarTheme(
    backgroundColor: kBeigePrimary,
    foregroundColor: kBrownDark,
    elevation: 0,
    centerTitle: false,
    iconTheme: IconThemeData(color: kBrownDark),
    titleTextStyle: TextStyle(
      color: kBrownDark,
      fontSize: 18,
      fontWeight: FontWeight.w700,
    ),
  ),

  // Buttons
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: kBrownDark,
      foregroundColor: kSoftWhite,
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: kBrownDark,
      side: BorderSide(color: kBrownSoft.withValues(alpha: 0.6)),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: kBrownDark,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
    ),
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: kBrownMedium,
    foregroundColor: kSoftWhite,
    elevation: 6,
  ),

  // Input fields
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: kSoftWhite,
    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
    floatingLabelBehavior: FloatingLabelBehavior.auto,
    labelStyle: TextStyle(color: kBrownSoft),
    hintStyle: TextStyle(color: kBrownSoft.withValues(alpha: 0.8)),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: kBrownSoft.withValues(alpha: 0.2)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: kBrownMedium),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: Colors.red.shade400),
    ),
  ),

  // Cards, lists, tiles
  cardTheme: CardThemeData(
    color: kBeigeSurface,
    elevation: 3,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
    margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
  ),
  listTileTheme: ListTileThemeData(
    tileColor: kSoftWhite,
    selectedColor: kBrownMedium,
    iconColor: kBrownDark,
    textColor: kBrownDark,
  ),

  // Bottom navigation
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: kBeigePrimary,
    selectedItemColor: kBrownDark,
    unselectedItemColor: kBrownSoft,
    showUnselectedLabels: true,
    elevation: 8,
  ),

  // Chips, snackbars, dialogs
  chipTheme: ChipThemeData(
    backgroundColor: kBeigePrimary,
    selectedColor: kBrownMedium,
    labelStyle: TextStyle(color: kBrownDark),
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
  ),
  snackBarTheme: SnackBarThemeData(
    backgroundColor: kBrownDark,
    contentTextStyle: TextStyle(color: kSoftWhite, fontWeight: FontWeight.w600),
    behavior: SnackBarBehavior.floating,
  ),
  dialogTheme: DialogThemeData(
    backgroundColor: kSoftWhite,
    elevation: 6,
    titleTextStyle: TextStyle(
      color: kBrownDark,
      fontSize: 18,
      fontWeight: FontWeight.bold,
    ),
    contentTextStyle: TextStyle(color: kBrownSoft),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  ),

  // Sliders, switches, progress
  sliderTheme: SliderThemeData(
    activeTrackColor: kBrownMedium,
    inactiveTrackColor: kBrownSoft.withValues(alpha: 0.3),
    thumbColor: kBrownDark,
    valueIndicatorColor: kBrownMedium,
  ),

  progressIndicatorTheme: ProgressIndicatorThemeData(
    color: kBrownMedium,
    linearTrackColor: kBeigeSurface,
  ),

  // Tabs & tooltips
  tabBarTheme: TabBarThemeData(
    labelColor: kBrownDark,
    unselectedLabelColor: kBrownSoft,
    indicator: UnderlineTabIndicator(
      borderSide: BorderSide(color: kBrownDark, width: 2),
    ),
  ),
  tooltipTheme: TooltipThemeData(
    decoration: BoxDecoration(
      color: kBrownDark,
      borderRadius: BorderRadius.circular(6),
    ),
    textStyle: TextStyle(color: kSoftWhite),
  ),

  // Visual density and page transitions
  visualDensity: VisualDensity.adaptivePlatformDensity,
  pageTransitionsTheme: const PageTransitionsTheme(
    builders: {
      TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
      TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      TargetPlatform.linux: FadeUpwardsPageTransitionsBuilder(),
      TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
      TargetPlatform.windows: FadeUpwardsPageTransitionsBuilder(),
    },
  ),
);
