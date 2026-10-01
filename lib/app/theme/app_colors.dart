import 'package:flutter/material.dart';

/// Charte graphique officielle HAVENA (cahier des charges, annexe) :
/// Vert #1E7A4B — Orange #E8792E — Blanc.
class AppColors {
  AppColors._();

  static const Color primary = Color(0xFF1E7A4B);
  static const Color secondary = Color(0xFFE8792E);
  // Variante sombre pour les textes orange sur fond clair.
  static const Color secondaryText = Color(0xFF9C4715);
  static const Color secondarySurface = Color(0xFFFFF0E5);
  static const Color background = Color(0xFFF5F7FA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color textPrimary = Color(0xFF111827);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color border = Color(0xFFE5E7EB);

  // Alertes du tableau de bord (cahier des charges §5) : Rouge / Orange /
  // Jaune / Vert. L'orange et le vert reprennent la charte de marque.
  static const Color alertRed = Color(0xFFDC2626);
  static const Color alertOrange = secondary;
  static const Color alertYellow = Color(0xFFD9A404);
  static const Color alertGreen = primary;

  static const Color error = alertRed;
  static const Color warning = alertOrange;
  static const Color success = alertGreen;
}
