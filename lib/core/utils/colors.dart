import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors
  static const Color primary = Color(0xFF1E3A8A); // Space Blue
  static const Color secondary = Color(0xFFF59E0B); // Rocket Orange
  static const Color accent = Color(0xFF8B5CF6); // Purple Accent

  // Status Colors
  static const Color success = Color(0xFF10B981); // Mission Green
  static const Color error = Color(0xFFEF4444); // Launch Red
  static const Color warning = Color(0xFFF59E0B); // Warning Orange

  // Background Colors
  static const Color background = Color(0xFF0F172A); // Dark Space
  static const Color surface = Color(0xFF1E293B); // Card Surface
  static const Color lightBackground = Color(0xFFF8FAFC); // Light Background
  static const Color lightSurface = Color(0xFFFFFFFF); // Light Surface

  // Text Colors
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFF94A3B8);
  static const Color textLight = Color(0xFF1E293B);
  static const Color textLightSecondary = Color(0xFF64748B);

  // Gradient Colors
  static const LinearGradient spaceGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF1E3A8A), Color(0xFF3B82F6), Color(0xFF8B5CF6)],
  );

  static const LinearGradient rocketGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFF59E0B), Color(0xFFEF4444)],
  );
}
