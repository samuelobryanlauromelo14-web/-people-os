// lib/core/tema.dart
//
// Todas as cores, fontes e estilos em um único lugar.
// Mudar o visual do app = mudar apenas este arquivo.

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Tema {
  // ── Paleta ────────────────────────────────────────────────────────────────
  static const Color fundo        = Color(0xFF0D0F14);
  static const Color superficie   = Color(0xFF161920);
  static const Color card         = Color(0xFF1E2128);
  static const Color borda        = Color(0xFF2A2D38);
  static const Color acento       = Color(0xFF4F8EF7);  // azul executivo
  static const Color acentoSuave  = Color(0xFF1A2D4A);
  static const Color sucesso      = Color(0xFF34C78A);
  static const Color erro         = Color(0xFFFF5C6A);
  static const Color textoForte   = Color(0xFFEEF0F8);
  static const Color textoSuave   = Color(0xFF6B7280);
  static const Color textoDimmer  = Color(0xFF3A3F4D);

  // ── Avatares: cor por índice ──────────────────────────────────────────────
  static const List<Color> avatarCores = [
    Color(0xFF4F8EF7),
    Color(0xFF34C78A),
    Color(0xFFFF8C42),
    Color(0xFFB06EFF),
    Color(0xFFFF5C6A),
    Color(0xFF00C6D4),
    Color(0xFFFFD166),
    Color(0xFFFF6B9D),
    Color(0xFF72EFDD),
    Color(0xFFF4A261),
  ];

  static Color avatarCor(int index) => avatarCores[index % avatarCores.length];

  // ── ThemeData ─────────────────────────────────────────────────────────────
  static ThemeData get dark {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: fundo,
      colorScheme: const ColorScheme.dark(
        primary: acento,
        surface: superficie,
        error: erro,
      ),
      textTheme: TextTheme(
        // Títulos grandes — fonte editorial
        displayMedium: GoogleFonts.playfairDisplay(
          fontSize: 28,
          fontWeight: FontWeight.w700,
          color: textoForte,
          letterSpacing: -0.5,
        ),
        // Título de seção
        titleLarge: GoogleFonts.playfairDisplay(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: textoForte,
        ),
        // Nome do usuário no card
        titleMedium: GoogleFonts.dmSans(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: textoForte,
        ),
        // Corpo padrão
        bodyMedium: GoogleFonts.dmSans(
          fontSize: 13,
          color: textoSuave,
          height: 1.5,
        ),
        bodySmall: GoogleFonts.dmSans(
          fontSize: 11,
          color: textoSuave,
          letterSpacing: 0.3,
        ),
        // Labels de botão
        labelLarge: GoogleFonts.dmSans(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.2,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: fundo,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.playfairDisplay(
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: textoForte,
        ),
        iconTheme: const IconThemeData(color: textoForte),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: card,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: borda),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: borda),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: acento, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: erro),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: erro, width: 1.5),
        ),
        labelStyle: GoogleFonts.dmSans(color: textoSuave, fontSize: 13),
        hintStyle: GoogleFonts.dmSans(color: textoDimmer, fontSize: 13),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: acento,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle: GoogleFonts.dmSans(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: acento,
          textStyle: GoogleFonts.dmSans(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ),
      dividerTheme: const DividerThemeData(color: borda, thickness: 1),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: card,
        contentTextStyle: GoogleFonts.dmSans(color: textoForte, fontSize: 13),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
