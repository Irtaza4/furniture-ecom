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

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'All';
  double _maxPrice = 1000.0;
  final List<String> _recentSearches = ['Swivel Chair', 'Oak Bed', 'Stool', 'Pendant Lamp'];

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
  void dispose() {
    _searchController.dispose();
    super.dispose();
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

            // Top Header
            Padding(
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

            const SizedBox(height: 14),

            // Search Bar
            Padding(
              padding: AppSpacing.screenPadding,
              child: SearchFieldCustom(
                controller: _searchController,
                onChanged: (_) => setState(() {}),
                onFilterTap: () {
                  // Show bottom sheet for price range slider
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
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
              ),
            ),

            const SizedBox(height: 14),

            // Category Chips
            SizedBox(
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
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Text(
                        cat.name,
                        style: TextStyle(
                          color: isSelected ? Colors.white : AppColors.textPrimary,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 12),

            // Recent Searches Chips (if search is empty)
            if (_searchController.text.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                child: Row(
                  children: [
                    Text('Popular:', style: AppTypography.label),
                    const SizedBox(width: 8),
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: _recentSearches.map((term) {
                            return GestureDetector(
                              onTap: () {
                                _searchController.text = term;
                                setState(() {});
                              },
                              child: Container(
                                margin: const EdgeInsets.only(right: 6),
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppColors.secondaryGray.withValues(alpha: 0.35),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  term,
                                  style: AppTypography.label.copyWith(fontSize: 11, color: AppColors.primaryDark),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 6),

            // Results Grid or Empty State
            Expanded(
              child: results.isEmpty
                  ? EmptyState(
                      icon: Icons.search_off_rounded,
                      title: 'No furniture found',
                      subtitle: 'Try adjusting your search query or price filters.',
                    )
                  : GridView.builder(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 100),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 14,
                        crossAxisSpacing: 14,
                        childAspectRatio: 0.74,
                      ),
                      itemCount: results.length,
                      itemBuilder: (context, index) {
                        final product = results[index];
                        return ProductCard(
                          product: product,
                          onTap: () => _openProductDetail(product),
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
