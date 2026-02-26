import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // ===========================================================================
  // BRAND
  // ===========================================================================
  static const Color primary = Color(0xFF121212);
  static const Color secondary = Color(0xFF312ECB);

  // ===========================================================================
  // BACKGROUNDS & SURFACES
  // ===========================================================================
  static const Color background = Color(0xFF0A0A0A);
  static const Color surface = Color(0xFF1E1E1E);
  static const Color surfaceVariant = Color(0xFF262626);
  static const Color surfaceElevated = Color(0xFF141414);
  static const Color inputBackground = Color(0x1AFFFFFF); // 10% white

  // ===========================================================================
  // TEXT
  // ===========================================================================
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xCCFFFFFF); // 80% white
  static const Color textTertiary = Color(0x99FFFFFF); // 60% white
  static const Color textDisabled = Color(0x4DFFFFFF); // 30% white

  // ===========================================================================
  // BORDERS & DIVIDERS
  // ===========================================================================
  static const Color border = Color(0x1AFFFFFF); // 10% white
  static const Color divider = Color(0x1AFFFFFF); // 10% white
  static const Color focusedBorder = Color(0xFF312ECB);

  // ===========================================================================
  // OVERLAYS (used in gradients, modals, image overlays)
  // ===========================================================================
  static const Color overlay10 = Color(0x1A000000);
  static const Color overlay35 = Color(0x59000000); // onboarding image tint
  static const Color overlay50 = Color(0x80000000);
  static const Color overlay70 = Color(0xB3000000);

  // ===========================================================================
  // STATUS
  // ===========================================================================
  static const Color errorColor = Color(0xFFFF3437);
  static const Color successColor = Color(0xFF34FF4C);
  static const Color warningColor = Color(0xFFFBBF24);
  static const Color infoColor = Color(0xFF0EA5E9);

  // FAB Gradient
  static const Color fabGradientStart = Color(0xFF20DE39);
  static const Color fabGradientEnd = Color(0xFF147721);
  static const LinearGradient fabGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [fabGradientStart, fabGradientEnd],
  );

  // Income / Expense Card Gradients
  static const LinearGradient incomeCardGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF0F8300), Color(0xFF031C00)],
  );
  static const LinearGradient expenseCardGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFB50303), Color(0xFF250000)],
  );

  // Progress Gradient
  static const Color progressGradientStart = Color(0xFF1DC533);
  static const Color progressGradientEnd = Color(0xFF0E5F19);
  static const LinearGradient progressGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [progressGradientStart, progressGradientEnd],
  );

  // ===========================================================================
  // UTILITY
  // ===========================================================================
  static const Color transparent = Colors.transparent;
  static const Color black = Colors.black;
  static const Color white = Colors.white;
  static const Color shadow = Color(0x1A000000);
}
