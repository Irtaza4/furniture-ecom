import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_strings.dart';
import '../../../shared/services/favorites_provider.dart';
import '../../../shared/widgets/product_card.dart';
import '../../../shared/widgets/empty_state.dart';
import '../../products/screens/product_detail_screen.dart';

class FavoritesScreen extends StatefulWidget {
  final VoidCallback? onExploreTap;

  const FavoritesScreen({
    super.key,
    this.onExploreTap,
  });

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _headerFade;
  late Animation<Offset> _headerSlide;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _animController.forward(from: 0.0);
      }
    });
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final favorites = Provider.of<FavoritesProvider>(context);
    final favList = favorites.favoriteProducts;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: favList.isEmpty
            ? EmptyState(
                icon: Icons.favorite_border_rounded,
                title: AppStrings.emptyFavoritesTitle,
                subtitle: AppStrings.emptyFavoritesSubtitle,
                buttonText: AppStrings.exploreFurniture,
                onButtonPressed: widget.onExploreTap,
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),

                  // Header: Slide Down & Fade
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
                                  AppStrings.favorites,
                                  style: AppTypography.screenHeading.copyWith(
                                    fontSize: 26,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                Text(
                                  '${favList.length} saved items',
                                  style: AppTypography.label.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                            if (favList.isNotEmpty)
                              TextButton(
                                onPressed: () => favorites.clearFavorites(),
                                child: Text(
                                  'Clear All',
                                  style: AppTypography.labelBold.copyWith(color: AppColors.accentCoral),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 14),

                  // 2-Column Staggered Grid
                  Expanded(
                    child: GridView.builder(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 14,
                        crossAxisSpacing: 14,
                        childAspectRatio: 0.74,
                      ),
                      itemCount: favList.length,
                      itemBuilder: (context, index) {
                        final product = favList[index];

                        final start = (0.20 + (index * 0.08)).clamp(0.0, 0.85);
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
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) => ProductDetailScreen(product: product),
                                    ),
                                  );
                                },
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
