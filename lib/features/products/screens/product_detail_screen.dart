import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../shared/models/product.dart';
import '../../../shared/services/cart_provider.dart';
import '../../../shared/services/favorites_provider.dart';
import '../../../shared/widgets/icon_button_custom.dart';
import '../../../shared/widgets/quantity_selector.dart';
import '../../../shared/widgets/color_selector.dart';
import '../../../shared/widgets/material_selector.dart';
import '../../../shared/widgets/app_button.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;

  const ProductDetailScreen({
    super.key,
    required this.product,
  });

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  late ProductColorOption _selectedColor;
  late ProductMaterialOption _selectedMaterial;
  int _quantity = 1;
  int _currentImageIndex = 0;
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    _selectedColor = widget.product.colors.first;
    _selectedMaterial = widget.product.materials.first;
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  double get _currentPrice =>
      (widget.product.price + _selectedMaterial.priceOffset) * _quantity;

  void _handleAddToCart() {
    final cart = Provider.of<CartProvider>(context, listen: false);
    cart.addItem(
      product: widget.product,
      color: _selectedColor,
      material: _selectedMaterial,
      quantity: _quantity,
    );

    // Show compact feedback snackbar
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
              child: const Icon(
                Icons.check_rounded,
                size: 16,
                color: AppColors.primaryDark,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Added ${_quantity}x ${widget.product.name} to cart',
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
    final favorites = Provider.of<FavoritesProvider>(context);
    final isFav = favorites.isFavorite(widget.product.id);
    final cartCount = Provider.of<CartProvider>(context).itemCount;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Top Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Row(
                children: [
                  IconButtonCustom(
                    icon: Icons.arrow_back_ios_new_rounded,
                    iconSize: 18,
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.product.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTypography.screenHeading.copyWith(
                            fontSize: 19,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          widget.product.subtitle,
                          style: AppTypography.label.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButtonCustom(
                    icon: Icons.shopping_bag_outlined,
                    badge: cartCount > 0 ? '$cartCount' : null,
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),

            // Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    const SizedBox(height: 8),

                    // Main Product Card with Image Gallery
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Container(
                        height: 310,
                        decoration: BoxDecoration(
                          color: widget.product.cardBackgroundColor,
                          borderRadius: BorderRadius.circular(AppSpacing.radiusHero),
                        ),
                        child: Stack(
                          children: [
                            // Gallery PageView
                            PageView.builder(
                              controller: _pageController,
                              onPageChanged: (index) {
                                setState(() {
                                  _currentImageIndex = index;
                                });
                              },
                              itemCount: widget.product.images.length,
                              itemBuilder: (context, index) {
                                return Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(24.0),
                                    child: Hero(
                                      tag: index == 0
                                          ? 'product_image_${widget.product.id}'
                                          : 'product_img_${widget.product.id}_$index',
                                      child: Image.asset(
                                        widget.product.images[index],
                                        fit: BoxFit.contain,
                                        errorBuilder: (context, error, stackTrace) => const Icon(
                                          Icons.chair_rounded,
                                          size: 120,
                                          color: AppColors.primaryDark,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),

                            // Pagination Dots
                            if (widget.product.images.length > 1)
                              Positioned(
                                top: 18,
                                left: 0,
                                right: 0,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: List.generate(
                                    widget.product.images.length,
                                    (index) => Container(
                                      margin: const EdgeInsets.symmetric(horizontal: 3),
                                      width: _currentImageIndex == index ? 20 : 6,
                                      height: 6,
                                      decoration: BoxDecoration(
                                        color: _currentImageIndex == index
                                            ? AppColors.primaryDark
                                            : AppColors.primaryDark.withValues(alpha: 0.2),
                                        borderRadius: BorderRadius.circular(3),
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                            // Stepper & Price Bar at bottom of card
                            Positioned(
                              left: 16,
                              right: 16,
                              bottom: 16,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  // Stepper pill
                                  QuantitySelector(
                                    quantity: _quantity,
                                    onQuantityChanged: (newQty) {
                                      setState(() {
                                        _quantity = newQty;
                                      });
                                    },
                                  ),

                                  // Price Tag Pill
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                    decoration: BoxDecoration(
                                      color: AppColors.primaryDark,
                                      borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
                                    ),
                                    child: Text(
                                      '\$${_currentPrice.toStringAsFixed(0)}',
                                      style: AppTypography.priceLight.copyWith(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Dark Customization Panel (Bottom Sheet style)
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 14),
                      padding: const EdgeInsets.fromLTRB(22, 24, 22, 32),
                      decoration: BoxDecoration(
                        color: AppColors.primaryDark,
                        borderRadius: BorderRadius.circular(AppSpacing.radiusSheet),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primaryDark.withValues(alpha: 0.2),
                            blurRadius: 24,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Material Selection Row with Favorite Button
                          MaterialSelector(
                            materials: widget.product.materials,
                            selectedMaterial: _selectedMaterial,
                            onMaterialSelected: (material) {
                              setState(() {
                                _selectedMaterial = material;
                              });
                            },
                            trailingAction: GestureDetector(
                              onTap: () => favorites.toggleFavorite(widget.product.id),
                              child: Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: AppColors.surface,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: 0.1),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                                  color: isFav ? AppColors.accentCoral : AppColors.primaryDark,
                                  size: 22,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 22),

                          // Color Swatches
                          ColorSelector(
                            colors: widget.product.colors,
                            selectedColor: _selectedColor,
                            onColorSelected: (color) {
                              setState(() {
                                _selectedColor = color;
                              });
                            },
                          ),

                          const SizedBox(height: 22),

                          // Description snippet
                          Text(
                            widget.product.description,
                            style: AppTypography.bodyLight.copyWith(
                              fontSize: 13,
                              height: 1.5,
                              color: Colors.white.withValues(alpha: 0.7),
                            ),
                          ),

                          const SizedBox(height: 26),

                          // Full Width "Add to cart" CTA Button (White button on dark background)
                          AppButton(
                            text: 'Add to cart',
                            variant: AppButtonVariant.primaryLight,
                            height: 58,
                            borderRadius: AppSpacing.radiusButton,
                            trailingIcon: const Icon(
                              Icons.arrow_forward_rounded,
                              size: 18,
                              color: AppColors.primaryDark,
                            ),
                            onPressed: _handleAddToCart,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
