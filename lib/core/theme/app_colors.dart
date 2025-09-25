import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF6C63FF);
  static const Color primaryDark = Color(0xFF5A52D5);
  static const Color secondary = Color(0xFF00D9FF);
  static const Color accent = Color(0xFFFF6B35);

  static const Color background = Color(0xFF0A0A0A);
  static const Color surface = Color(0xFF1A1A1A);
  static const Color surfaceVariant = Color(0xFF2D2D2D);

  static const Color onBackground = Color(0xFFFFFFFF);
  static const Color onSurface = Color(0xFFE5E5E5);
  static const Color onSurfaceSecondary = Color(0xFFB0B0B0);

  static const Color error = Color(0xFFFF4444);
  static const Color success = Color(0xFF00C851);
  static const Color warning = Color(0xFFFFA726);

  static const Color cardBackground = Color(0xFF1E1E1E);
  static const Color borderColor = Color(0xFF404040);

  static const Color neonGreen = Color(0xFF39FF14);
  static const Color neonBlue = Color(0xFF1B03A3);
  static const Color neonPink = Color(0xFFFF10F0);
  static const Color neonOrange = Color(0xFFFF8C00);

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient gameGradient = LinearGradient(
    colors: [neonBlue, primary, neonPink],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}