import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';

class QuantitySelector extends StatelessWidget {
  final int quantity;
  final ValueChanged<int> onQuantityChanged;
  final int min;
  final int max;
  final bool darkTheme;

  const QuantitySelector({
    super.key,
    required this.quantity,
    required this.onQuantityChanged,
    this.min = 1,
    this.max = 99,
    this.darkTheme = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 42,
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 3),
      decoration: BoxDecoration(
        color: darkTheme
            ? AppColors.surface.withValues(alpha: 0.1)
            : AppColors.surface,
        borderRadius: BorderRadius.circular(22),
        boxShadow: !darkTheme
            ? [
                BoxShadow(
                  color: AppColors.primaryDark.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ]
            : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Minus Button
          GestureDetector(
            onTap: quantity > min ? () => onQuantityChanged(quantity - 1) : null,
            child: Container(
              width: 32,
              height: 32,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.transparent,
              ),
              child: Center(
                child: Icon(
                  Icons.remove_rounded,
                  size: 16,
                  color: quantity > min
                      ? (darkTheme ? AppColors.textLight : AppColors.primaryDark)
                      : (darkTheme ? AppColors.textLight.withValues(alpha: 0.3) : AppColors.textMuted),
                ),
              ),
            ),
          ),
          const SizedBox(width: 4),
          // Quantity Badge (Lilac pill highlight)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.accentPurple,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              '$quantity',
              style: AppTypography.labelBold.copyWith(
                color: Colors.white,
                fontSize: 13,
              ),
            ),
          ),
          const SizedBox(width: 4),
          // Plus Button
          GestureDetector(
            onTap: quantity < max ? () => onQuantityChanged(quantity + 1) : null,
            child: Container(
              width: 32,
              height: 32,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.transparent,
              ),
              child: Center(
                child: Icon(
                  Icons.add_rounded,
                  size: 16,
                  color: quantity < max
                      ? (darkTheme ? AppColors.textLight : AppColors.primaryDark)
                      : (darkTheme ? AppColors.textLight.withValues(alpha: 0.3) : AppColors.textMuted),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
