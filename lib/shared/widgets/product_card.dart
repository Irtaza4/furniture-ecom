import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../services/favorites_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/constants/app_spacing.dart';

class ProductCard extends StatefulWidget {
  final Product product;
  final VoidCallback onTap;
  final double? height;
  final String? heroTag;

  const ProductCard({
    super.key,
    required this.product,
    required this.onTap,
    this.height,
    this.heroTag,
  });

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.96).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildImage() {
    final imageWidget = Image.asset(
      widget.product.mainImage,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) => const Icon(
        Icons.chair_rounded,
        size: 50,
        color: AppColors.primaryDark,
      ),
    );

    final heroChild = widget.heroTag != null && widget.heroTag!.isNotEmpty
        ? Hero(
            tag: widget.heroTag!,
            flightShuttleBuilder: (flightContext, animation, flightDirection, fromHeroContext, toHeroContext) {
              return Material(
                type: MaterialType.transparency,
                child: toHeroContext.widget,
              );
            },
            child: imageWidget,
          )
        : imageWidget;

    // Hold/Drag the product cutout itself
    return LongPressDraggable<Product>(
      data: widget.product,
      delay: const Duration(milliseconds: 140),
      hapticFeedbackOnStart: true,
      feedback: Material(
        type: MaterialType.transparency,
        child: SizedBox(
          width: 125,
          height: 125,
          child: Image.asset(
            widget.product.mainImage,
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
    final isFav = favorites.isFavorite(widget.product.id);

    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        widget.onTap();
      },
      onTapCancel: () => _controller.reverse(),
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          height: widget.height,
          decoration: BoxDecoration(
            color: widget.product.cardBackgroundColor,
            borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
          ),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 12),
                    // Product Image (Draggable)
                    Expanded(
                      child: Center(
                        child: _buildImage(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Product Name
                    Text(
                      widget.product.name,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.productName.copyWith(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Price
                    Text(
                      '\$${widget.product.price.toStringAsFixed(0)}',
                      style: AppTypography.price.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                  ],
                ),
              ),
              // Favorite Heart Button (Top Right with DragTarget support)
              Positioned(
                top: 10,
                right: 10,
                child: DragTarget<Product>(
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
                        content: Text('Added ${details.data.name} to Wishlist! ❤️'),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                  builder: (context, candidateData, rejectedData) {
                    final isHovered = candidateData.isNotEmpty;
                    return GestureDetector(
                      onTap: () => favorites.toggleFavorite(widget.product.id),
                      child: AnimatedScale(
                        duration: const Duration(milliseconds: 150),
                        scale: isHovered ? 1.35 : 1.0,
                        child: Container(
                          width: 34,
                          height: 34,
                          decoration: BoxDecoration(
                            color: isHovered
                                ? AppColors.accentCoral.withValues(alpha: 0.3)
                                : AppColors.surface.withValues(alpha: 0.9),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primaryDark.withValues(alpha: 0.08),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Icon(
                            isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                            color: isFav || isHovered ? AppColors.accentCoral : AppColors.primaryDark,
                            size: 16,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
