import 'package:flutter/material.dart';
import '../models/product.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/constants/app_spacing.dart';

class MaterialSelector extends StatelessWidget {
  final List<ProductMaterialOption> materials;
  final ProductMaterialOption selectedMaterial;
  final ValueChanged<ProductMaterialOption> onMaterialSelected;
  final Widget? trailingAction;

  const MaterialSelector({
    super.key,
    required this.materials,
    required this.selectedMaterial,
    required this.onMaterialSelected,
    this.trailingAction,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Material',
                  style: AppTypography.screenHeadingLight.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  selectedMaterial.name,
                  style: AppTypography.labelLight.copyWith(
                    color: AppColors.textLight.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
            ?trailingAction,
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        SizedBox(
          height: 62,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: materials.length,
            separatorBuilder: (context, index) => const SizedBox(width: 10),
            itemBuilder: (context, index) {
              final material = materials[index];
              final isSelected = material.id == selectedMaterial.id;

              return GestureDetector(
                onTap: () => onMaterialSelected(material),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.surface
                        : AppColors.surface.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.accentPurple
                          : Colors.white.withValues(alpha: 0.1),
                      width: isSelected ? 1.5 : 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Swatch thumbnail
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          width: 44,
                          height: 44,
                          color: AppColors.primaryDark,
                          child: Image.asset(
                            material.imageAsset,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Container(
                              color: AppColors.accentCoral,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            material.name,
                            style: AppTypography.bodyMedium.copyWith(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: isSelected
                                  ? AppColors.primaryDark
                                  : AppColors.textLight,
                            ),
                          ),
                          if (material.priceOffset > 0)
                            Text(
                              '+ \$${material.priceOffset.toStringAsFixed(0)}',
                              style: AppTypography.label.copyWith(
                                fontSize: 11,
                                color: isSelected
                                    ? AppColors.accentPurple
                                    : AppColors.textLight.withValues(alpha: 0.6),
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          else
                            Text(
                              'Standard',
                              style: AppTypography.label.copyWith(
                                fontSize: 11,
                                color: isSelected
                                    ? AppColors.textSecondary
                                    : AppColors.textLight.withValues(alpha: 0.5),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(width: 4),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
