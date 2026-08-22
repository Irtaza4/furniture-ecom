import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../shared/models/product.dart';
import '../../../shared/services/furniture_data_service.dart';
import '../../../shared/widgets/search_field_custom.dart';
import '../../../shared/widgets/product_card.dart';
import '../../../shared/widgets/empty_state.dart';
import '../../products/screens/product_detail_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'All';
  double _maxPrice = 1000.0;
  final List<String> _recentSearches = ['Swivel Chair', 'Oak Bed', 'Stool', 'Pendant Lamp'];

  late AnimationController _animController;
  late Animation<double> _headerFade;
  late Animation<Offset> _headerSlide;
  late Animation<double> _searchAnimation;
  late Animation<double> _chipsFade;
  late Animation<Offset> _chipsSlide;
  late Animation<double> _gridFade;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1300),
    );

    // 1. Header (0.0 -> 0.35)
    _headerFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0.0, 0.35, curve: Curves.easeOut),
      ),
    );
    _headerSlide = Tween<Offset>(begin: const Offset(0, -0.4), end: Offset.zero).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0.0, 0.35, curve: Curves.easeOutCubic),
      ),
    );

    // 2. Search Bar expansion (0.15 -> 0.55)
    _searchAnimation = CurvedAnimation(
      parent: _animController,
      curve: const Interval(0.15, 0.55, curve: Curves.easeOutCubic),
    );

    // 3. Category & Recent Chips (0.30 -> 0.70)
    _chipsFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0.30, 0.65, curve: Curves.easeOut),
      ),
    );
    _chipsSlide = Tween<Offset>(begin: const Offset(0.2, 0), end: Offset.zero).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0.30, 0.70, curve: Curves.easeOutCubic),
      ),
    );

    // 4. Grid header fade (0.45 -> 0.80)
    _gridFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0.45, 0.80, curve: Curves.easeOut),
      ),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _animController.forward(from: 0.0);
      }
    });
  }

  @override
  void dispose() {
    _animController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  List<Product> get _filteredProducts {
    final query = _searchController.text.trim().toLowerCase();
    return FurnitureDataService.products.where((p) {
      final matchesQuery = query.isEmpty ||
          p.name.toLowerCase().contains(query) ||
          p.subtitle.toLowerCase().contains(query) ||
          p.category.toLowerCase().contains(query);
      final matchesCategory = _selectedCategory == 'All' || p.category == _selectedCategory;
      final matchesPrice = p.price <= _maxPrice;
      return matchesQuery && matchesCategory && matchesPrice;
    }).toList();
  }

  void _openProductDetail(Product product) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => ProductDetailScreen(product: product)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final results = _filteredProducts;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            const SizedBox(height: 8),

            // Top Header: Slide down & fade
            SlideTransition(
              position: _headerSlide,
              child: FadeTransition(
                opacity: _headerFade,
                child: Padding(
                  padding: AppSpacing.screenPadding,
                  child: Row(
                    children: [
                      Text(
                        'Explore Collection',
                        style: AppTypography.screenHeading.copyWith(
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 14),

            // Expanding Search Bar
            Padding(
              padding: AppSpacing.screenPadding,
              child: SearchFieldCustom(
                controller: _searchController,
                entranceAnimation: _searchAnimation,
                onChanged: (_) => setState(() {}),
                onFilterTap: () {
                  showModalBottomSheet(
                    context: context,
                    backgroundColor: AppColors.primaryDark,
                    shape: const RoundedRectangleBorder(borderRadius: AppSpacing.roundedSheet),
                    builder: (ctx) {
                      return StatefulBuilder(
                        builder: (ctx, setSheetState) {
                          return Padding(
                            padding: AppSpacing.bottomSheetPadding,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Max Price Filter', style: AppTypography.screenHeadingLight.copyWith(fontSize: 20)),
                                const SizedBox(height: 10),
                                Text(
                                  'Up to \$${_maxPrice.toStringAsFixed(0)}',
                                  style: AppTypography.heroHeadingLight.copyWith(fontSize: 24, color: AppColors.accentMint),
                                ),
                                Slider(
                                  value: _maxPrice,
                                  min: 50,
                                  max: 1000,
                                  divisions: 19,
                                  activeColor: AppColors.accentPurple,
                                  inactiveColor: Colors.white24,
                                  onChanged: (val) {
                                    setSheetState(() => _maxPrice = val);
                                    setState(() => _maxPrice = val);
                                  },
                                ),
                                const SizedBox(height: 16),
                                ElevatedButton(
                                  onPressed: () => Navigator.of(ctx).pop(),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.accentMint,
                                    foregroundColor: AppColors.primaryDark,
                                    minimumSize: const Size(double.infinity, 50),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(AppSpacing.radiusButton),
                                    ),
                                  ),
                                  child: const Text('Done', style: TextStyle(fontWeight: FontWeight.bold)),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  );
                },
                hasActiveFilters: _maxPrice < 1000 || _selectedCategory != 'All',
              ),
            ),

            const SizedBox(height: 14),

            // Category Chips: Slide & Fade
            SlideTransition(
              position: _chipsSlide,
              child: FadeTransition(
                opacity: _chipsFade,
                child: SizedBox(
                  height: 38,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: FurnitureDataService.categories.length,
                    itemBuilder: (context, index) {
                      final cat = FurnitureDataService.categories[index];
                      final isSelected = _selectedCategory == cat.name;

                      return GestureDetector(
                        onTap: () => setState(() => _selectedCategory = cat.name),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          margin: const EdgeInsets.only(right: 8),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: isSelected ? AppColors.primaryDark : AppColors.surface,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primaryDark.withValues(alpha: isSelected ? 0.12 : 0.03),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Text(
                            cat.name,
                            style: AppTypography.bodyMedium.copyWith(
                              fontSize: 13,
                              color: isSelected ? Colors.white : AppColors.textPrimary,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Recent Searches Chips (if query is empty)
            if (_searchController.text.isEmpty)
              FadeTransition(
                opacity: _chipsFade,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      const Text(
                        'Recent:',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          child: Row(
                            children: _recentSearches.map((term) {
                              return Padding(
                                padding: const EdgeInsets.only(right: 6),
                                child: ActionChip(
                                  label: Text(term, style: const TextStyle(fontSize: 11, color: AppColors.textPrimary)),
                                  backgroundColor: AppColors.surface,
                                  side: BorderSide.none,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  onPressed: () {
                                    _searchController.text = term;
                                    setState(() {});
                                  },
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            const SizedBox(height: 10),

            // Results count
            FadeTransition(
              opacity: _gridFade,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Results',
                      style: AppTypography.sectionTitle.copyWith(fontSize: 16),
                    ),
                    Text(
                      '${results.length} items found',
                      style: AppTypography.label.copyWith(color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 6),

            // 2-Column Staggered Product Grid
            Expanded(
              child: results.isEmpty
                  ? EmptyState(
                      icon: Icons.search_off_rounded,
                      title: 'No furniture found',
                      subtitle: 'Try adjusting your search keywords or price filter',
                      buttonText: 'Reset Filters',
                      onButtonPressed: () {
                        setState(() {
                          _searchController.clear();
                          _selectedCategory = 'All';
                          _maxPrice = 1000.0;
                        });
                      },
                    )
                  : GridView.builder(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 14,
                        crossAxisSpacing: 14,
                        childAspectRatio: 0.74,
                      ),
                      itemCount: results.length,
                      itemBuilder: (context, index) {
                        final product = results[index];

                        // Staggered calculation
                        final start = (0.35 + (index * 0.06)).clamp(0.0, 0.85);
                        final end = (start + 0.35).clamp(0.0, 1.0);

                        final cardFade = Tween<double>(begin: 0.0, end: 1.0).animate(
                          CurvedAnimation(
                            parent: _animController,
                            curve: Interval(start, (start + 0.20).clamp(0.0, 1.0), curve: Curves.easeOut),
                          ),
                        );

                        final cardSlide = Tween<Offset>(
                          begin: const Offset(0, 0.35),
                          end: Offset.zero,
                        ).animate(
                          CurvedAnimation(
                            parent: _animController,
                            curve: Interval(start, end, curve: Curves.easeOutBack),
                          ),
                        );

                        final cardScale = Tween<double>(begin: 0.85, end: 1.0).animate(
                          CurvedAnimation(
                            parent: _animController,
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
    );
  }
}
