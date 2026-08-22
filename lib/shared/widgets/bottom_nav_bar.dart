import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../services/cart_provider.dart';
import '../services/favorites_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/constants/app_spacing.dart';

class BottomNavBar extends StatefulWidget {
  final int currentIndex;
  final ValueChanged<int> onTabSelected;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTabSelected,
  });

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> with SingleTickerProviderStateMixin {
  bool _isHolding = false;
  int? _previewIndex;

  void _handleTouchMove(Offset localPosition, double totalWidth, int itemCount) {
    if (totalWidth <= 0) return;
    const paddingHorizontal = 10.0;
    final usableWidth = totalWidth - (paddingHorizontal * 2);
    final relativeX = (localPosition.dx - paddingHorizontal).clamp(0.0, usableWidth);
    final tabWidth = usableWidth / itemCount;
    final hoveredIndex = (relativeX / tabWidth).floor().clamp(0, itemCount - 1);

    if (_previewIndex != hoveredIndex) {
      HapticFeedback.selectionClick();
      setState(() {
        _previewIndex = hoveredIndex;
      });
      // The screen will only change when the user stops/releases on that tab!
    }
  }

  void _commitSelection() {
    if (_previewIndex != null && _previewIndex != widget.currentIndex) {
      HapticFeedback.mediumImpact();
      widget.onTabSelected(_previewIndex!);
    }
    setState(() {
      _isHolding = false;
      _previewIndex = null;
    });
  }

  void _handleDropOnCart(Product product) {
    HapticFeedback.heavyImpact();
    final cart = Provider.of<CartProvider>(context, listen: false);
    cart.addItem(
      product: product,
      color: product.colors.first,
      material: product.materials.first,
    );

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppColors.primaryDark,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: const BoxDecoration(
                color: AppColors.accentMint,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.shopping_bag_rounded, size: 16, color: AppColors.primaryDark),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Dropped & added ${product.name} to Cart! 🛍️',
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _handleDropOnFavorites(Product product) {
    HapticFeedback.heavyImpact();
    final favs = Provider.of<FavoritesProvider>(context, listen: false);
    favs.toggleFavorite(product.id);

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppColors.primaryDark,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: const BoxDecoration(
                color: AppColors.accentCoral,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.favorite_rounded, size: 16, color: Colors.white),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Dropped & added ${product.name} to Wishlist! ❤️',
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cartItemCount = Provider.of<CartProvider>(context).itemCount;

    final navItems = [
      {'icon': Icons.home_rounded, 'label': 'Home'},
      {'icon': Icons.grid_view_rounded, 'label': 'Explore'},
      {'icon': Icons.shopping_bag_outlined, 'label': 'Cart', 'badge': cartItemCount},
      {'icon': Icons.favorite_border_rounded, 'label': 'Favorites'},
      {'icon': Icons.person_outline_rounded, 'label': 'Profile'},
    ];

    // During drag/hold, the indicator follows _previewIndex; otherwise it sits on currentIndex
    final activeIndex = _isHolding ? (_previewIndex ?? widget.currentIndex) : widget.currentIndex;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(left: 24, right: 24, bottom: 12),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final barWidth = constraints.maxWidth;
            final itemCount = navItems.length;

            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onPanDown: (details) {
                setState(() {
                  _isHolding = true;
                  _previewIndex = widget.currentIndex;
                });
                _handleTouchMove(details.localPosition, barWidth, itemCount);
              },
              onPanStart: (details) {
                setState(() => _isHolding = true);
                _handleTouchMove(details.localPosition, barWidth, itemCount);
              },
              onPanUpdate: (details) {
                _handleTouchMove(details.localPosition, barWidth, itemCount);
              },
              onPanEnd: (_) => _commitSelection(),
              onPanCancel: () {
                setState(() {
                  _isHolding = false;
                  _previewIndex = null;
                });
              },
              child: AnimatedScale(
                duration: const Duration(milliseconds: 180),
                scale: _isHolding ? 1.03 : 1.0,
                curve: Curves.easeOutCubic,
                child: Container(
                  height: 64,
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.primaryDark,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusNav),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryDark.withValues(alpha: _isHolding ? 0.35 : 0.22),
                        blurRadius: _isHolding ? 24 : 16,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      // Sliding Active Indicator Capsule
                      AnimatedAlign(
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.easeOutBack,
                        alignment: Alignment(
                          -1.0 + (activeIndex / (itemCount - 1)) * 2.0,
                          0.0,
                        ),
                        child: FractionallySizedBox(
                          widthFactor: 1.0 / itemCount,
                          heightFactor: 1.0,
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            decoration: BoxDecoration(
                              color: _isHolding
                                  ? AppColors.accentPurple.withValues(alpha: 0.35)
                                  : Colors.white.withValues(alpha: 0.16),
                              borderRadius: BorderRadius.circular(18),
                              border: _isHolding
                                  ? Border.all(color: Colors.white.withValues(alpha: 0.25), width: 1)
                                  : null,
                            ),
                          ),
                        ),
                      ),

                      // Interactive Tab Icon Items (with DragTarget for Cart & Favorites)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: List.generate(navItems.length, (index) {
                          final item = navItems[index];
                          final isSelected = activeIndex == index;
                          final badge = item['badge'] as int?;

                          Widget tabContent(bool isHovered) {
                            return GestureDetector(
                              onTap: () {
                                HapticFeedback.selectionClick();
                                widget.onTabSelected(index);
                              },
                              behavior: HitTestBehavior.opaque,
                              child: Center(
                                child: AnimatedScale(
                                  duration: const Duration(milliseconds: 180),
                                  scale: isHovered ? 1.35 : (isSelected ? 1.15 : 1.0),
                                  curve: Curves.easeOutBack,
                                  child: Container(
                                    padding: isHovered ? const EdgeInsets.all(6) : EdgeInsets.zero,
                                    decoration: isHovered
                                        ? BoxDecoration(
                                            color: index == 2
                                                ? AppColors.accentMint.withValues(alpha: 0.3)
                                                : AppColors.accentCoral.withValues(alpha: 0.3),
                                            shape: BoxShape.circle,
                                          )
                                        : null,
                                    child: Stack(
                                      clipBehavior: Clip.none,
                                      children: [
                                        Icon(
                                          item['icon'] as IconData,
                                          size: 22,
                                          color: isHovered
                                              ? (index == 2 ? AppColors.accentMint : AppColors.accentCoral)
                                              : (isSelected ? Colors.white : AppColors.textMuted),
                                        ),
                                        if (badge != null && badge > 0)
                                          Positioned(
                                            top: -6,
                                            right: -8,
                                            child: Container(
                                              padding: const EdgeInsets.all(4),
                                              decoration: const BoxDecoration(
                                                color: AppColors.accentCoral,
                                                shape: BoxShape.circle,
                                              ),
                                              constraints: const BoxConstraints(
                                                minWidth: 16,
                                                minHeight: 16,
                                              ),
                                              child: Text(
                                                '$badge',
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 9,
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
                              ),
                            );
                          }

                          if (index == 2) {
                            // Cart Tab DragTarget
                            return Expanded(
                              child: DragTarget<Product>(
                                onWillAcceptWithDetails: (details) {
                                  HapticFeedback.selectionClick();
                                  return true;
                                },
                                onAcceptWithDetails: (details) {
                                  _handleDropOnCart(details.data);
                                },
                                builder: (context, candidateData, rejectedData) {
                                  return tabContent(candidateData.isNotEmpty);
                                },
                              ),
                            );
                          } else if (index == 3) {
                            // Favorites Tab DragTarget
                            return Expanded(
                              child: DragTarget<Product>(
                                onWillAcceptWithDetails: (details) {
                                  HapticFeedback.selectionClick();
                                  return true;
                                },
                                onAcceptWithDetails: (details) {
                                  _handleDropOnFavorites(details.data);
                                },
                                builder: (context, candidateData, rejectedData) {
                                  return tabContent(candidateData.isNotEmpty);
                                },
                              ),
                            );
                          }

                          return Expanded(
                            child: tabContent(false),
                          );
                        }),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
