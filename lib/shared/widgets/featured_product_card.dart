import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../services/cart_provider.dart';
import '../services/favorites_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/constants/app_spacing.dart';

class FeaturedProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onTap;
  final String? heroTag;
  final VoidCallback? onCartTap;
  final int cartCount;

  const FeaturedProductCard({
    super.key,
    required this.product,
    required this.onTap,
    this.heroTag,
    this.onCartTap,
    this.cartCount = 0,
  });

  Widget _buildImage() {
    final imageWidget = Image.asset(
      product.mainImage,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) => const Icon(
        Icons.chair_rounded,
        size: 100,
        color: AppColors.primaryDark,
      ),
    );

    final heroChild = heroTag != null && heroTag!.isNotEmpty
        ? Hero(
            tag: heroTag!,
            flightShuttleBuilder: (flightContext, animation, flightDirection, fromHeroContext, toHeroContext) {
              return Material(
                type: MaterialType.transparency,
                child: toHeroContext.widget,
              );
            },
            child: imageWidget,
          )
        : imageWidget;

    // Hold/Drag the featured product cutout itself
    return LongPressDraggable<Product>(
      data: product,
      delay: const Duration(milliseconds: 140),
      hapticFeedbackOnStart: true,
      feedback: Material(
        type: MaterialType.transparency,
        child: SizedBox(
          width: 240,
          height: 200,
          child: Image.asset(
            product.mainImage,
            fit: BoxFit.contain,
          ),
        ),
      ),
      childWhenDragging: heroChild,
      child: heroChild,
    );
  }

  @override
  Widget build(BuildContext context) {
    final favorites = Provider.of<FavoritesProvider>(context);
    final isFav = favorites.isFavorite(product.id);

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        decoration: BoxDecoration(
          color: product.cardBackgroundColor,
          borderRadius: BorderRadius.circular(AppSpacing.radiusHero),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryDark.withValues(alpha: 0.04),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(22, 22, 22, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Row: Headline + Subtitle on Left, White Squircle Cart on Right
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Find the best\nFurniture! 🛋️',
                          style: AppTypography.heroHeading.copyWith(
                            fontSize: 27,
                            fontWeight: FontWeight.w800,
                            height: 1.15,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          product.subtitle,
                          style: AppTypography.body.copyWith(
                            color: AppColors.textSecondary,
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  // White Squircle Cart Button with DragTarget
                  DragTarget<Product>(
                    onWillAcceptWithDetails: (details) {
                      HapticFeedback.selectionClick();
                      return true;
                    },
                    onAcceptWithDetails: (details) {
                      HapticFeedback.heavyImpact();
                      final cart = Provider.of<CartProvider>(context, listen: false);
                      cart.addItem(
                        product: details.data,
                        color: details.data.colors.first,
                        material: details.data.materials.first,
                      );
                      ScaffoldMessenger.of(context).clearSnackBars();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: AppColors.primaryDark,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          content: Text('Dropped & added ${details.data.name} to Cart! 🛍️'),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    },
                    builder: (context, candidateData, rejectedData) {
                      final isHovered = candidateData.isNotEmpty;
                      return GestureDetector(
                        onTap: onCartTap,
                        behavior: HitTestBehavior.opaque,
                        child: AnimatedScale(
                          duration: const Duration(milliseconds: 150),
                          scale: isHovered ? 1.25 : 1.0,
                          child: Container(
                            width: 52,
                            height: 52,
                            decoration: BoxDecoration(
                              color: isHovered ? AppColors.accentMint : Colors.white,
                              borderRadius: BorderRadius.circular(18),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primaryDark.withValues(alpha: 0.08),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Stack(
                              alignment: Alignment.center,
                              clipBehavior: Clip.none,
                              children: [
                                const Icon(
                                  Icons.shopping_cart_outlined,
                                  color: AppColors.primaryDark,
                                  size: 22,
                                ),
                                if (cartCount > 0)
                                  Positioned(
                                    top: -4,
                                    right: -4,
                                    child: Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: const BoxDecoration(
                                        color: AppColors.accentCoral,
                                        shape: BoxShape.circle,
                                      ),
                                      constraints: const BoxConstraints(
                                        minWidth: 18,
                                        minHeight: 18,
                                      ),
                                      child: Text(
                                        '$cartCount',
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          height: 1,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Large Product Image with Hold & Drag Support
              Center(
                child: SizedBox(
                  height: 200,
                  child: _buildImage(),
                ),
              ),
              const SizedBox(height: 14),
              // Bottom Row with Price Pill & Favorite Button (DragTarget)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Price Badge Pill
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
                    decoration: BoxDecoration(
                      color: AppColors.primaryDark,
                      borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primaryDark.withValues(alpha: 0.15),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Text(
                      '\$${product.price.toStringAsFixed(0)}',
                      style: AppTypography.priceLight.copyWith(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  // Favorite Round Button with DragTarget
                  DragTarget<Product>(
                    onWillAcceptWithDetails: (details) {
                      HapticFeedback.selectionClick();
                      return true;
                    },
                    onAcceptWithDetails: (details) {
                      HapticFeedback.heavyImpact();
                      favorites.toggleFavorite(details.data.id);
                      ScaffoldMessenger.of(context).clearSnackBars();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: AppColors.primaryDark,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          content: Text('Dropped & added ${details.data.name} to Wishlist! ❤️'),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    },
                    builder: (context, candidateData, rejectedData) {
                      final isHovered = candidateData.isNotEmpty;
                      return GestureDetector(
                        onTap: () => favorites.toggleFavorite(product.id),
                        behavior: HitTestBehavior.opaque,
                        child: AnimatedScale(
                          duration: const Duration(milliseconds: 150),
                          scale: isHovered ? 1.30 : 1.0,
                          child: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: isHovered
                                  ? AppColors.accentCoral.withValues(alpha: 0.3)
                                  : Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primaryDark.withValues(alpha: 0.08),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Icon(
                              isFav || isHovered ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                              color: isFav || isHovered ? AppColors.accentCoral : AppColors.primaryDark,
                              size: 22,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
