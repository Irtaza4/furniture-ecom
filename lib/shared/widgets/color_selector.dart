import 'package:flutter/material.dart';
import '../models/product.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/constants/app_spacing.dart';

class ColorSelector extends StatelessWidget {
  final List<ProductColorOption> colors;
  final ProductColorOption selectedColor;
  final ValueChanged<ProductColorOption> onColorSelected;

  const ColorSelector({
    super.key,
    required this.colors,
    required this.selectedColor,
    required this.onColorSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Choose Color',
              style: AppTypography.screenHeadingLight.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              selectedColor.name,
              style: AppTypography.labelLight.copyWith(
                color: AppColors.textLight.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        Row(
          children: colors.map((colorOption) {
            final isSelected = colorOption.id == selectedColor.id;
            return GestureDetector(
              onTap: () => onColorSelected(colorOption),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.only(right: 12),
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: colorOption.color,
                  borderRadius: BorderRadius.circular(14),
                  border: isSelected
                      ? Border.all(color: Colors.white, width: 2.5)
                      : Border.all(color: Colors.white.withValues(alpha: 0.15), width: 1),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: colorOption.color.withValues(alpha: 0.4),
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                        ]
                      : null,
                ),
                child: isSelected
                    ? Icon(
                        Icons.check_rounded,
                        size: 20,
                        color: colorOption.color.computeLuminance() > 0.5
                            ? AppColors.primaryDark
                            : Colors.white,
                      )
                    : null,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
