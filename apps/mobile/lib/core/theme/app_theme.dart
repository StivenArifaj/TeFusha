import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get light {
    final baseTheme = ThemeData(
      useMaterial3: false,
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.scaffoldBg,
    );

    return baseTheme.copyWith(
      textTheme: GoogleFonts.outfitTextTheme(baseTheme.textTheme).copyWith(
        displayLarge:  GoogleFonts.outfit(fontSize: 32, fontWeight: FontWeight.w700, color: AppColors.textDark),
        displayMedium: GoogleFonts.outfit(fontSize: 28, fontWeight: FontWeight.w700, color: AppColors.textDark),
        displaySmall:  GoogleFonts.outfit(fontSize: 24, fontWeight: FontWeight.w700, color: AppColors.textDark),
        headlineMedium: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.textDark),
        titleLarge:    GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textDark),
        titleMedium:   GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w500, color: AppColors.textDark),
        titleSmall:    GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.textDark),
        bodyLarge:     GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w400, color: AppColors.textDark),
        bodyMedium:    GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.w400, color: AppColors.textMedium),
        labelLarge:    GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.white),
      ),

      appBarTheme: AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: AppColors.textDark,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColors.textDark),
        titleTextStyle: GoogleFonts.outfit(
          fontSize: 18, 
          fontWeight: FontWeight.w700, 
          color: AppColors.textDark,
        ),
      ),

      cardTheme: CardThemeData(
        color: AppColors.cardBg,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          textStyle: GoogleFonts.outfit(
            fontSize: 16, 
            fontWeight: FontWeight.w700,
          ),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.primary, width: 1.5),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          textStyle: GoogleFonts.outfit(
            fontSize: 16, 
            fontWeight: FontWeight.w700,
          ),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          textStyle: GoogleFonts.outfit(
            fontSize: 14, 
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.inputFill,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.error, width: 1.5),
        ),
        hintStyle: GoogleFonts.outfit(fontSize: 14, color: AppColors.textLight),
        labelStyle: GoogleFonts.outfit(fontSize: 14, color: AppColors.textMedium),
      ),

      chipTheme: ChipThemeData(
        backgroundColor: AppColors.inputFill,
        selectedColor: AppColors.primary,
        labelStyle: GoogleFonts.outfit(
          fontSize: 13, 
          fontWeight: FontWeight.w500,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),

      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textLight,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        selectedLabelStyle: GoogleFonts.outfit(fontSize: 11, fontWeight: FontWeight.w600),
        unselectedLabelStyle: GoogleFonts.outfit(fontSize: 11, fontWeight: FontWeight.w400),
      ),

      dividerTheme: const DividerThemeData(
        color: AppColors.divider,
        thickness: 1,
        space: 1,
      ),
    );
  }
}
