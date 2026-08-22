import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../shared/models/product.dart';
import '../../../shared/services/furniture_data_service.dart';
import '../../../shared/services/cart_provider.dart';
import '../../../shared/widgets/featured_product_card.dart';
import '../../../shared/widgets/product_card.dart';
import '../../../shared/widgets/search_field_custom.dart';
import '../../../shared/widgets/icon_button_custom.dart';
import '../../products/screens/product_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  final ValueChanged<int>? onNavigateTab;

  const HomeScreen({
    super.key,
    this.onNavigateTab,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  String _selectedCategory = 'All';
  final TextEditingController _searchController = TextEditingController();
  late AnimationController _entranceController;

  late Animation<double> _headerFade;
  late Animation<Offset> _headerSlide;

  late Animation<double> _heroFade;
  late Animation<double> _heroScale;
  late Animation<Offset> _heroSlide;

  late Animation<double> _searchAnimation;

  late Animation<double> _categoriesFade;
  late Animation<Offset> _categoriesSlide;

  late Animation<double> _sectionHeaderFade;

  @override
  void initState() {
    super.initState();
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    );

    // 1. Header (0.05 -> 0.35)
    _headerFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.05, 0.35, curve: Curves.easeOut),
      ),
    );
    _headerSlide = Tween<Offset>(begin: const Offset(0, -0.5), end: Offset.zero).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.05, 0.35, curve: Curves.easeOutCubic),
      ),
    );

    // 2. Hero Card (0.15 -> 0.55)
    _heroFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.15, 0.48, curve: Curves.easeOut),
      ),
    );
    _heroScale = Tween<double>(begin: 0.88, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.15, 0.55, curve: Curves.easeOutBack),
      ),
    );
    _heroSlide = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.15, 0.55, curve: Curves.easeOutCubic),
      ),
    );

    // 3. Search Bar Dynamic Expansion (0.30 -> 0.70)
    _searchAnimation = CurvedAnimation(
      parent: _entranceController,
      curve: const Interval(0.30, 0.70, curve: Curves.easeOutCubic),
    );

    // 4. Categories Carousel (0.42 -> 0.78)
    _categoriesFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.42, 0.75, curve: Curves.easeOut),
      ),
    );
    _categoriesSlide = Tween<Offset>(begin: const Offset(0.3, 0), end: Offset.zero).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.42, 0.78, curve: Curves.easeOutCubic),
      ),
    );

    // 5. Section Header (0.50 -> 0.80)
    _sectionHeaderFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.50, 0.80, curve: Curves.easeOut),
      ),
    );

    // Trigger after frame is mounted and page transition completes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 200), () {
        if (mounted) {
          _entranceController.forward(from: 0.0);
        }
      });
    });
  }

  @override
  void dispose() {
    _entranceController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  List<Product> get _filteredProducts {
    var list = FurnitureDataService.products;
    if (_selectedCategory != 'All') {
      list = list.where((p) => p.category == _selectedCategory).toList();
    }
    if (_searchController.text.trim().isNotEmpty) {
      final query = _searchController.text.trim().toLowerCase();
      list = list
          .where((p) =>
              p.name.toLowerCase().contains(query) ||
              p.subtitle.toLowerCase().contains(query) ||
              p.category.toLowerCase().contains(query))
          .toList();
    }
    return list;
  }

  void _openProductDetail(Product product, {String? heroTag}) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => ProductDetailScreen(
          product: product,
          heroTag: heroTag,
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.05),
                end: Offset.zero,
              ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic)),
              child: child,
            ),
          );
        },
        transitionDuration: const Duration(milliseconds: 300),
      ),
    );
  }

  void _showFilterModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: AppSpacing.bottomSheetPadding,
              decoration: const BoxDecoration(
                color: AppColors.primaryDark,
                borderRadius: AppSpacing.roundedSheet,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Filter Furniture',
                    style: AppTypography.screenHeadingLight.copyWith(fontSize: 22),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Categories',
                    style: AppTypography.bodyMedium.copyWith(color: AppColors.textLight),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      'All',
                      'Chairs',
                      'Tables',
                      'Lighting',
                      'Sofa',
                      'Bed',
                      'Decoration',
                    ].map((cat) {
                      final isSelected = _selectedCategory == cat;
                      return GestureDetector(
                        onTap: () {
                          setModalState(() {
                            setState(() {
                              _selectedCategory = cat;
                            });
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          decoration: BoxDecoration(
                            color: isSelected ? AppColors.accentPurple : Colors.white.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            cat,
                            style: AppTypography.bodyMedium.copyWith(
                              color: isSelected ? Colors.white : AppColors.textLight.withValues(alpha: 0.8),
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 28),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.accentMint,
                        foregroundColor: AppColors.primaryDark,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppSpacing.radiusButton),
                        ),
                      ),
                      child: Text(
                        'Apply Filters',
                        style: AppTypography.buttonDark.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final cartCount = Provider.of<CartProvider>(context).itemCount;
    final heroProduct = FurnitureDataService.products.first;
    final productsList = _filteredProducts;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.only(bottom: 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),

              // 1. Top Bar: Animated Slide and Fade from Top
              SlideTransition(
                position: _headerSlide,
                child: FadeTransition(
                  opacity: _headerFade,
                  child: Padding(
                    padding: AppSpacing.screenPadding,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Location',
                              style: AppTypography.label.copyWith(
                                fontSize: 11,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Row(
                              children: [
                                const Icon(
                                  Icons.location_on_rounded,
                                  size: 15,
                                  color: AppColors.accentPurple,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'San Francisco, CA',
                                  style: AppTypography.bodyMedium.copyWith(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const Icon(
                                  Icons.keyboard_arrow_down_rounded,
                                  size: 18,
                                  color: AppColors.textSecondary,
                                ),
                              ],
                            ),
                          ],
                        ),
                        // Shopping Bag Button
                        IconButtonCustom(
                          icon: Icons.shopping_bag_outlined,
                          badge: cartCount > 0 ? '$cartCount' : null,
                          onPressed: () => widget.onNavigateTab?.call(2),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // 2. Hero Featured Card: Pop & Scale from Bottom
              SlideTransition(
                position: _heroSlide,
                child: ScaleTransition(
                  scale: _heroScale,
                  child: FadeTransition(
                    opacity: _heroFade,
                    child: Padding(
                      padding: AppSpacing.screenPadding,
                      child: FeaturedProductCard(
                        product: heroProduct,
                        heroTag: 'home_hero_${heroProduct.id}',
                        onTap: () => _openProductDetail(heroProduct, heroTag: 'home_hero_${heroProduct.id}'),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // 3. Dark Search Bar: Expands from Left with Search Icon & Mint Filter Button
              Padding(
                padding: AppSpacing.screenPadding,
                child: SearchFieldCustom(
                  controller: _searchController,
                  entranceAnimation: _searchAnimation,
                  onChanged: (_) => setState(() {}),
                  onFilterTap: _showFilterModal,
                  hasActiveFilters: _selectedCategory != 'All',
                ),
              ),

              const SizedBox(height: 20),

              // 4. Category Pills: Sliding in horizontally with fade
              SlideTransition(
                position: _categoriesSlide,
                child: FadeTransition(
                  opacity: _categoriesFade,
                  child: SizedBox(
                    height: 40,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: FurnitureDataService.categories.length,
                      itemBuilder: (context, index) {
                        final cat = FurnitureDataService.categories[index];
                        final isSelected = _selectedCategory == cat.name;

                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedCategory = cat.name;
                            });
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            margin: const EdgeInsets.only(right: 10),
                            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                            decoration: BoxDecoration(
                              color: isSelected ? AppColors.primaryDark : AppColors.surface,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primaryDark.withValues(alpha: isSelected ? 0.12 : 0.03),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  cat.icon,
                                  size: 16,
                                  color: isSelected ? Colors.white : AppColors.textSecondary,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  cat.name,
                                  style: AppTypography.bodyMedium.copyWith(
                                    fontSize: 13,
                                    color: isSelected ? Colors.white : AppColors.textPrimary,
                                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // 5. Section Heading: Fade in
              FadeTransition(
                opacity: _sectionHeaderFade,
                child: Padding(
                  padding: AppSpacing.screenPadding,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _selectedCategory == 'All' ? 'Popular Furniture' : '$_selectedCategory Collection',
                        style: AppTypography.sectionTitle.copyWith(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        '${productsList.length} items',
                        style: AppTypography.label.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 14),

              // 6. Staggered Animated 2-Column Product Grid
              Padding(
                padding: AppSpacing.screenPadding,
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 14,
                    crossAxisSpacing: 14,
                    childAspectRatio: 0.74,
                  ),
                  itemCount: productsList.length,
                  itemBuilder: (context, index) {
                    final product = productsList[index];

                    // Calculate Staggered Interval for each individual card
                    final start = (0.50 + (index * 0.08)).clamp(0.0, 0.85);
                    final end = (start + 0.35).clamp(0.0, 1.0);

                    final cardFade = Tween<double>(begin: 0.0, end: 1.0).animate(
                      CurvedAnimation(
                        parent: _entranceController,
                        curve: Interval(start, (start + 0.20).clamp(0.0, 1.0), curve: Curves.easeOut),
                      ),
                    );

                    final cardSlide = Tween<Offset>(
                      begin: const Offset(0, 0.40),
                      end: Offset.zero,
                    ).animate(
                      CurvedAnimation(
                        parent: _entranceController,
                        curve: Interval(start, end, curve: Curves.easeOutBack),
                      ),
                    );

                    final cardScale = Tween<double>(begin: 0.82, end: 1.0).animate(
                      CurvedAnimation(
                        parent: _entranceController,
                        curve: Interval(start, end, curve: Curves.easeOutBack),
                      ),
                    );

                    return SlideTransition(
                      position: cardSlide,
                      child: ScaleTransition(
                        scale: cardScale,
                        child: FadeTransition(
                          opacity: cardFade,
                          child: ProductCard(
                            product: product,
                            onTap: () => _openProductDetail(product),
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
