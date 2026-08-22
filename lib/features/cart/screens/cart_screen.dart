import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_strings.dart';
import '../../../shared/services/cart_provider.dart';
import '../../../shared/widgets/icon_button_custom.dart';
import '../../../shared/widgets/empty_state.dart';
import '../../checkout/screens/checkout_screen.dart';

class CartScreen extends StatefulWidget {
  final VoidCallback? onExploreTap;

  const CartScreen({
    super.key,
    this.onExploreTap,
  });

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _headerFade;
  late Animation<Offset> _headerSlide;
  late Animation<Offset> _bottomPanelSlide;
  late Animation<double> _bottomPanelFade;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
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

    // 2. Bottom Checkout Panel (0.25 -> 0.70)
    _bottomPanelSlide = Tween<Offset>(begin: const Offset(0, 0.6), end: Offset.zero).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0.25, 0.70, curve: Curves.easeOutBack),
      ),
    );
    _bottomPanelFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0.25, 0.60, curve: Curves.easeOut),
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

  void _proceedToCheckout() {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => const CheckoutScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1, 0),
              end: Offset.zero,
            ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic)),
            child: child,
          );
        },
      ),
    );
  }

  Widget _buildItemStepper(dynamic item, CartProvider cart) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Plus Button (Left)
        GestureDetector(
          onTap: () => cart.updateQuantity(item.id, item.quantity + 1),
          child: Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: AppColors.background,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Center(
              child: Icon(Icons.add, size: 14, color: AppColors.primaryDark),
            ),
          ),
        ),
        const SizedBox(width: 4),
        // Quantity Badge (Lavender Circle)
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: const Color(0xFF948BE5),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF948BE5).withValues(alpha: 0.3),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Center(
            child: Text(
              '${item.quantity}',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 14,
              ),
            ),
          ),
        ),
        const SizedBox(width: 4),
        // Minus Button (Right)
        GestureDetector(
          onTap: item.quantity > 1
              ? () => cart.updateQuantity(item.id, item.quantity - 1)
              : () => cart.removeItem(item.id),
          child: Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: AppColors.background,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Center(
              child: Icon(
                Icons.remove,
                size: 14,
                color: item.quantity > 1 ? AppColors.primaryDark : AppColors.textMuted,
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: cart.items.isEmpty
            ? EmptyState(
                icon: Icons.shopping_bag_outlined,
                title: AppStrings.emptyCartTitle,
                subtitle: AppStrings.emptyCartSubtitle,
                buttonText: AppStrings.exploreFurniture,
                onButtonPressed: widget.onExploreTap,
              )
            : Column(
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
                                  AppStrings.myCart,
                                  style: AppTypography.screenHeading.copyWith(
                                    fontSize: 26,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                Text(
                                  'Find the best (${cart.itemCount} items)',
                                  style: AppTypography.label.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                            IconButtonCustom(
                              icon: Icons.delete_sweep_outlined,
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (ctx) => AlertDialog(
                                    backgroundColor: AppColors.surface,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    title: const Text('Clear Cart?'),
                                    content: const Text('Are you sure you want to remove all items from your cart?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.of(ctx).pop(),
                                        child: const Text('Cancel'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          cart.clearCart();
                                          Navigator.of(ctx).pop();
                                        },
                                        child: const Text('Clear', style: TextStyle(color: AppColors.accentCoral)),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Items List: Swipe-to-Delete Dismissible Cards
                  Expanded(
                    child: ListView.separated(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: cart.items.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final item = cart.items[index];

                        final start = (0.15 + (index * 0.08)).clamp(0.0, 0.80);
                        final end = (start + 0.35).clamp(0.0, 1.0);

                        final itemFade = Tween<double>(begin: 0.0, end: 1.0).animate(
                          CurvedAnimation(
                            parent: _animController,
                            curve: Interval(start, (start + 0.20).clamp(0.0, 1.0), curve: Curves.easeOut),
                          ),
                        );

                        final itemSlide = Tween<Offset>(
                          begin: const Offset(0.20, 0),
                          end: Offset.zero,
                        ).animate(
                          CurvedAnimation(
                            parent: _animController,
                            curve: Interval(start, end, curve: Curves.easeOutCubic),
                          ),
                        );

                        final itemScale = Tween<double>(begin: 0.92, end: 1.0).animate(
                          CurvedAnimation(
                            parent: _animController,
                            curve: Interval(start, end, curve: Curves.easeOutBack),
                          ),
                        );

                        return SlideTransition(
                          position: itemSlide,
                          child: ScaleTransition(
                            scale: itemScale,
                            child: FadeTransition(
                              opacity: itemFade,
                              child: Dismissible(
                                key: ValueKey(item.id),
                                direction: DismissDirection.endToStart,
                                onDismissed: (direction) {
                                  final removedItemName = item.product.name;
                                  cart.removeItem(item.id);
                                  ScaffoldMessenger.of(context).clearSnackBars();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      backgroundColor: AppColors.primaryDark,
                                      behavior: SnackBarBehavior.floating,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                                      content: Text('Removed $removedItemName from cart'),
                                      duration: const Duration(seconds: 2),
                                    ),
                                  );
                                },
                                background: Container(
                                  alignment: Alignment.centerRight,
                                  padding: const EdgeInsets.only(right: 26),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFE8C68), // Coral delete background
                                    borderRadius: BorderRadius.circular(24),
                                  ),
                                  child: const Icon(
                                    Icons.delete_outline_rounded,
                                    color: Colors.white,
                                    size: 28,
                                  ),
                                ),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                                  decoration: BoxDecoration(
                                    color: AppColors.surface,
                                    borderRadius: BorderRadius.circular(24),
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.primaryDark.withValues(alpha: 0.04),
                                        blurRadius: 10,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    children: [
                                      // Product Thumbnail
                                      Container(
                                        width: 72,
                                        height: 72,
                                        decoration: BoxDecoration(
                                          color: item.product.cardBackgroundColor,
                                          borderRadius: BorderRadius.circular(18),
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(18),
                                          child: Image.asset(
                                            item.product.mainImage,
                                            fit: BoxFit.contain,
                                            errorBuilder: (context, error, stackTrace) => const Icon(
                                              Icons.chair_rounded,
                                              size: 36,
                                              color: AppColors.primaryDark,
                                            ),
                                          ),
                                        ),
                                      ),

                                      const SizedBox(width: 14),

                                      // Details: Product Name & Pill Price Tag
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              item.product.name,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: AppTypography.productName.copyWith(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            // Price Tag Pill Box
                                            Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                                              decoration: BoxDecoration(
                                                color: AppColors.background,
                                                borderRadius: BorderRadius.circular(12),
                                                border: Border.all(
                                                  color: AppColors.primaryDark.withValues(alpha: 0.06),
                                                ),
                                              ),
                                              child: Text(
                                                '\$${item.unitPrice.toStringAsFixed(0)}',
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.w800,
                                                  fontSize: 13,
                                                  color: AppColors.primaryDark,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                      // Quantity Stepper (+ [1] -)
                                      _buildItemStepper(item, cart),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  // Bottom Summary Card: Slide Up from Bottom with Spring
                  SlideTransition(
                    position: _bottomPanelSlide,
                    child: FadeTransition(
                      opacity: _bottomPanelFade,
                      child: Container(
                        margin: const EdgeInsets.fromLTRB(16, 8, 16, 96),
                        padding: const EdgeInsets.all(22),
                        decoration: BoxDecoration(
                          color: AppColors.primaryDark,
                          borderRadius: BorderRadius.circular(32),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primaryDark.withValues(alpha: 0.35),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Subtotal',
                                  style: AppTypography.bodyLight.copyWith(color: Colors.white70),
                                ),
                                Text(
                                  '\$${cart.subtotal.toStringAsFixed(0)}',
                                  style: AppTypography.bodyLight.copyWith(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Delivery',
                                  style: AppTypography.bodyLight.copyWith(color: Colors.white70),
                                ),
                                Text(
                                  cart.deliveryFee == 0 ? 'FREE' : '\$${cart.deliveryFee.toStringAsFixed(0)}',
                                  style: AppTypography.bodyLight.copyWith(
                                    color: AppColors.accentMint,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            if (cart.discountAmount > 0) ...[
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Discount (${cart.appliedPromoCode})',
                                    style: AppTypography.bodyLight.copyWith(color: AppColors.accentMint),
                                  ),
                                  Text(
                                    '-\$${cart.discountAmount.toStringAsFixed(0)}',
                                    style: AppTypography.bodyLight.copyWith(
                                      color: AppColors.accentMint,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                            const Divider(color: Colors.white12, height: 24),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  AppStrings.grandTotal,
                                  style: AppTypography.screenHeadingLight.copyWith(
                                    fontSize: 18,
                                  ),
                                ),
                                Text(
                                  '\$${cart.grandTotal.toStringAsFixed(0)}',
                                  style: AppTypography.priceLight.copyWith(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: _proceedToCheckout,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: AppColors.primaryDark,
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(AppSpacing.radiusButton),
                                  ),
                                  elevation: 0,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      AppStrings.makePayment,
                                      style: AppTypography.buttonDark.copyWith(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    const Icon(Icons.arrow_forward_rounded, size: 18),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
