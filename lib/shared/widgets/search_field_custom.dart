import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/constants/app_spacing.dart';

class SearchFieldCustom extends StatelessWidget {
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onFilterTap;
  final VoidCallback? onTap;
  final bool readOnly;
  final String hintText;
  final bool hasActiveFilters;
  final Animation<double>? entranceAnimation;

  const SearchFieldCustom({
    super.key,
    this.controller,
    this.onChanged,
    this.onFilterTap,
    this.onTap,
    this.readOnly = false,
    this.hintText = 'Search items...',
    this.hasActiveFilters = false,
    this.entranceAnimation,
  });

  @override
  Widget build(BuildContext context) {
    if (entranceAnimation == null) {
      return _buildFullBar(context, 1.0, 1.0);
    }

    return AnimatedBuilder(
      animation: entranceAnimation!,
      builder: (context, child) {
        final progress = entranceAnimation!.value;
        return _buildFullBar(context, progress, progress);
      },
    );
  }

  Widget _buildFullBar(BuildContext context, double widthProgress, double elementsProgress) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final totalWidth = constraints.maxWidth;
        // Start as a circle (58px) and expand to full width
        final currentWidth = 58.0 + (totalWidth - 58.0) * widthProgress.clamp(0.0, 1.0);
        final isExpanded = widthProgress > 0.3;

        return Align(
          alignment: Alignment.centerLeft,
          child: Opacity(
            opacity: widthProgress > 0.05 ? 1.0 : (widthProgress * 20).clamp(0.0, 1.0),
            child: Container(
              height: 58,
              width: currentWidth,
              padding: const EdgeInsets.only(left: 18, right: 6, top: 5, bottom: 5),
              decoration: BoxDecoration(
                color: AppColors.primaryDark,
                borderRadius: BorderRadius.circular(AppSpacing.radiusNav),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryDark.withValues(alpha: 0.18 * widthProgress.clamp(0.0, 1.0)),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Search Icon
                  const Icon(
                    Icons.search_rounded,
                    color: AppColors.textMuted,
                    size: 22,
                  ),
                  if (isExpanded) ...[
                    const SizedBox(width: AppSpacing.sm),
                    // Search Input field
                    Expanded(
                      child: Opacity(
                        opacity: ((widthProgress - 0.3) / 0.7).clamp(0.0, 1.0),
                        child: TextField(
                          controller: controller,
                          readOnly: readOnly,
                          onTap: onTap,
                          onChanged: onChanged,
                          cursorColor: AppColors.accentPurple,
                          style: AppTypography.body.copyWith(
                            color: AppColors.textLight,
                            fontSize: 15,
                          ),
                          decoration: InputDecoration(
                            hintText: hintText,
                            hintStyle: AppTypography.body.copyWith(
                              color: AppColors.textMuted,
                              fontSize: 14,
                            ),
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            contentPadding: EdgeInsets.zero,
                            isDense: true,
                            fillColor: Colors.transparent,
                            filled: false,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    // Mint Filter Button sliding/popping in on the right
                    Transform.scale(
                      scale: ((widthProgress - 0.4) / 0.6).clamp(0.0, 1.0),
                      child: Opacity(
                        opacity: ((widthProgress - 0.4) / 0.6).clamp(0.0, 1.0),
                        child: GestureDetector(
                          onTap: onFilterTap,
                          child: Container(
                            width: 46,
                            height: 46,
                            decoration: BoxDecoration(
                              color: hasActiveFilters ? AppColors.accentPurple : AppColors.accentMint,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.accentMint.withValues(alpha: 0.25),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Icon(
                              Icons.tune_rounded,
                              size: 22,
                              color: hasActiveFilters ? AppColors.textLight : AppColors.primaryDark,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
