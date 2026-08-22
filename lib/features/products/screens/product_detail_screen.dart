import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../shared/models/product.dart';
import '../../../shared/services/cart_provider.dart';
import '../../../shared/services/favorites_provider.dart';
import '../../../shared/widgets/icon_button_custom.dart';
import '../../../shared/widgets/color_selector.dart';
import '../../../shared/widgets/material_selector.dart';
import '../../../shared/widgets/app_button.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;
  final String? heroTag;

  const ProductDetailScreen({
    super.key,
    required this.product,
    this.heroTag,
  });

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  late ProductColorOption _selectedColor;
  late ProductMaterialOption _selectedMaterial;
  int _quantity = 1;
  int _currentImageIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _selectedColor = widget.product.colors.first;
    _selectedMaterial = widget.product.materials.first;
    _pageController = PageController(viewportFraction: 0.74);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  double get _currentPrice =>
      (widget.product.price + _selectedMaterial.priceOffset) * _quantity;

  String _getImageForColorAndAngle(int angleIndex) {
    final baseList = widget.product.images;
    if (baseList.isEmpty) return widget.product.mainImage;

    final pid = widget.product.id;
    final cid = _selectedColor.id;

    if (pid == 'p_hero_chair') {
      final suffix = angleIndex == 1 ? '_side' : (angleIndex == 2 ? '_angle' : '');
      switch (cid) {
        case 'c_pink':
          return 'assets/images/armchair_pink$suffix.png';
        case 'c_cyan':
          return 'assets/images/armchair_cyan$suffix.png';
        case 'c_charcoal':
          return 'assets/images/armchair_charcoal$suffix.png';
        case 'c_grey':
        default:
          return 'assets/images/armchair_grey$suffix.png';
      }
    } else if (pid == 'p_leather_swivel') {
      final suffix = angleIndex == 1 ? '_side' : (angleIndex == 2 ? '_angle' : '');
      switch (cid) {
        case 'c_cyan':
          return 'assets/images/leather_swivel_cyan$suffix.png';
        case 'c_mustard':
          return 'assets/images/leather_swivel_mustard$suffix.png';
        case 'c_charcoal':
          return 'assets/images/leather_swivel_charcoal$suffix.png';
        case 'c_pink':
        default:
          return 'assets/images/leather_swivel_chair$suffix.png';
      }
    } else if (pid == 'p_stool_table') {
      final suffix = angleIndex == 1 ? '_angle' : '';
      switch (cid) {
        case 'c_mustard':
          return 'assets/images/stool_table_mustard$suffix.png';
        case 'c_charcoal':
          return 'assets/images/stool_table_charcoal$suffix.png';
        case 'c_mint':
        default:
          return 'assets/images/stool_table$suffix.png';
      }
    } else if (pid == 'p_ceiling_lamp') {
      final suffix = angleIndex == 1 ? '_angle' : '';
      switch (cid) {
        case 'c_charcoal':
          return 'assets/images/ceiling_lamp_charcoal$suffix.png';
        case 'c_cyan':
          return 'assets/images/ceiling_lamp_cyan$suffix.png';
        case 'c_mustard':
        default:
          return 'assets/images/ceiling_lamp$suffix.png';
      }
    } else if (pid == 'p_nordic_stool') {
      final suffix = angleIndex == 1 ? '_side' : '';
      switch (cid) {
        case 'c_cyan':
          return 'assets/images/nordic_stool_cyan$suffix.png';
        case 'c_grey':
          return 'assets/images/nordic_stool_grey$suffix.png';
        case 'c_pink':
        default:
          return 'assets/images/nordic_stool$suffix.png';
      }
    } else if (pid == 'p_cloud_sofa') {
      final suffix = angleIndex == 1 ? '_angle' : '';
      switch (cid) {
        case 'c_charcoal':
          return 'assets/images/velvet_sofa_charcoal$suffix.png';
        case 'c_pink':
          return 'assets/images/velvet_sofa_pink$suffix.png';
        case 'c_grey':
        default:
          return 'assets/images/velvet_sofa$suffix.png';
      }
    }

    return baseList[angleIndex.clamp(0, baseList.length - 1)];
  }

  Widget _buildProductImage(int index) {
    final imageAsset = _getImageForColorAndAngle(index);

    final img = Image.asset(
      imageAsset,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) => const Icon(
        Icons.chair_rounded,
        size: 120,
        color: AppColors.primaryDark,
      ),
    );

    if (index == 0 && widget.heroTag != null && widget.heroTag!.isNotEmpty) {
      return Hero(
        tag: widget.heroTag!,
        flightShuttleBuilder: (flightContext, animation, flightDirection, fromHeroContext, toHeroContext) {
          return Material(
            type: MaterialType.transparency,
            child: toHeroContext.widget,
          );
        },
        child: img,
      );
    }
    return img;
  }

  Widget _buildCardStepper() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Plus Button (White Circle)
        GestureDetector(
          onTap: () {
            setState(() {
              _quantity++;
            });
          },
          child: Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Center(
              child: Icon(Icons.add, size: 18, color: AppColors.primaryDark),
            ),
          ),
        ),
        const SizedBox(width: 6),
        // Quantity Badge (Lavender Circle)
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: const Color(0xFF948BE5),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF948BE5).withValues(alpha: 0.35),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Center(
            child: Text(
              '$_quantity',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 16,
              ),
            ),
          ),
        ),
        const SizedBox(width: 6),
        // Minus Button (White Circle)
        GestureDetector(
          onTap: _quantity > 1
              ? () {
                  setState(() {
                    _quantity--;
                  });
                }
              : null,
          child: Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Center(
              child: Icon(
                Icons.remove,
                size: 18,
                color: _quantity > 1 ? AppColors.primaryDark : AppColors.textMuted,
              ),
            ),
          ),
        ),
      ],
    );
  }

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
                'Added ${_quantity}x ${widget.product.name} (${_selectedColor.name}) to cart',
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
            // Top Navigation Bar
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
                          style: AppTypography.screenHeading.copyWith(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
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

            // Scrollable Body
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    const SizedBox(height: 8),

                    // Multi-Card Peek Animated Carousel (viewportFraction: 0.74)
                    SizedBox(
                      height: 350,
                      child: AnimatedBuilder(
                        animation: _pageController,
                        builder: (context, child) {
                          return PageView.builder(
                            controller: _pageController,
                            physics: const BouncingScrollPhysics(),
                            itemCount: widget.product.images.length,
                            onPageChanged: (index) {
                              setState(() {
                                _currentImageIndex = index;
                              });
                            },
                            itemBuilder: (context, index) {
                              // Calculate page offset for smooth 3D scaling
                              double pageOffset = 0.0;
                              if (_pageController.position.haveDimensions && _pageController.page != null) {
                                pageOffset = (_pageController.page! - index);
                              } else {
                                pageOffset = (_currentImageIndex - index).toDouble();
                              }

                              final scale = (1.0 - (pageOffset.abs() * 0.12)).clamp(0.86, 1.0);
                              final opacity = (1.0 - (pageOffset.abs() * 0.35)).clamp(0.60, 1.0);

                              return Opacity(
                                opacity: opacity,
                                child: Transform.scale(
                                  scale: scale,
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
                                    decoration: BoxDecoration(
                                      color: widget.product.cardBackgroundColor, // Card stays static pastel!
                                      borderRadius: BorderRadius.circular(36),
                                      boxShadow: [
                                        BoxShadow(
                                          color: AppColors.primaryDark.withValues(alpha: 0.08),
                                          blurRadius: 18,
                                          offset: const Offset(0, 6),
                                        ),
                                      ],
                                    ),
                                    child: Stack(
                                      children: [
                                        // Centered Product Cutout for the exact selected color & angle
                                        Center(
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(20, 20, 20, 70),
                                            child: _buildProductImage(index),
                                          ),
                                        ),

                                        // Bottom Row: Stepper (+ [1] -) & Price Tag Pill
                                        Positioned(
                                          left: 16,
                                          right: 16,
                                          bottom: 16,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              // Floating Stepper (+ [1] -)
                                              _buildCardStepper(),

                                              // Dark Navy Price Tag Pill ($299)
                                              Container(
                                                padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
                                                decoration: BoxDecoration(
                                                  color: AppColors.primaryDark,
                                                  borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: AppColors.primaryDark.withValues(alpha: 0.20),
                                                      blurRadius: 10,
                                                      offset: const Offset(0, 4),
                                                    ),
                                                  ],
                                                ),
                                                child: Text(
                                                  '\$${_currentPrice.toStringAsFixed(0)}',
                                                  style: AppTypography.priceLight.copyWith(
                                                    fontSize: 17,
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
                              );
                            },
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Pagination Indicator Dots
                    if (widget.product.images.length > 1)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          widget.product.images.length,
                          (index) => AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            margin: const EdgeInsets.symmetric(horizontal: 3),
                            width: _currentImageIndex == index ? 22 : 6,
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

                          // Color Swatches (Updates product color in real-time)
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
