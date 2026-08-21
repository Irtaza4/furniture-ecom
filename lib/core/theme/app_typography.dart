import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTypography {
  // Base Font Family
  static TextStyle get _base => GoogleFonts.plusJakartaSans();

  // Hero Headings (32 - 38px)
  static TextStyle get heroHeading => _base.copyWith(
        fontSize: 34,
        fontWeight: FontWeight.w700,
        height: 1.15,
        letterSpacing: -0.8,
        color: AppColors.textPrimary,
      );

  static TextStyle get heroHeadingLight => heroHeading.copyWith(
        color: AppColors.textLight,
      );

  // Screen Headings (24 - 28px)
  static TextStyle get screenHeading => _base.copyWith(
        fontSize: 26,
        fontWeight: FontWeight.w700,
        height: 1.25,
        letterSpacing: -0.5,
        color: AppColors.textPrimary,
      );

  static TextStyle get screenHeadingLight => screenHeading.copyWith(
        color: AppColors.textLight,
      );

  // Section Titles (20 - 22px)
  static TextStyle get sectionTitle => _base.copyWith(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        height: 1.3,
        letterSpacing: -0.3,
        color: AppColors.textPrimary,
      );

  static TextStyle get sectionTitleLight => sectionTitle.copyWith(
        color: AppColors.textLight,
      );

  // Product Name (16 - 18px)
  static TextStyle get productName => _base.copyWith(
        fontSize: 17,
        fontWeight: FontWeight.w600,
        height: 1.3,
        letterSpacing: -0.2,
        color: AppColors.textPrimary,
      );

  static TextStyle get productNameLight => productName.copyWith(
        color: AppColors.textLight,
      );

  // Price (15 - 17px Bold)
  static TextStyle get price => _base.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.2,
        color: AppColors.textPrimary,
      );

  static TextStyle get priceLight => price.copyWith(
        color: AppColors.textLight,
      );

  // Subtitles & Supporting Text (13 - 15px)
  static TextStyle get body => _base.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.5,
        color: AppColors.textSecondary,
      );

  static TextStyle get bodyMedium => _base.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        height: 1.4,
        color: AppColors.textPrimary,
      );

  static TextStyle get bodyLight => body.copyWith(
        color: AppColors.textLight.withValues(alpha: 0.85),
      );

  // Small Labels (11 - 12px Medium)
  static TextStyle get label => _base.copyWith(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        height: 1.3,
        color: AppColors.textSecondary,
      );

  static TextStyle get labelBold => _base.copyWith(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.2,
        color: AppColors.textPrimary,
      );

  static TextStyle get labelLight => label.copyWith(
        color: AppColors.textLight.withValues(alpha: 0.8),
      );

  // Button Text (15 - 16px SemiBold)
  static TextStyle get button => _base.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.1,
        color: AppColors.textLight,
      );

  static TextStyle get buttonDark => button.copyWith(
        color: AppColors.primaryDark,
      );
}
