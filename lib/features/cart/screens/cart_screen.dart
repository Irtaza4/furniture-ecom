import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_strings.dart';
import '../../../shared/services/cart_provider.dart';
import '../../../shared/widgets/icon_button_custom.dart';
import '../../../shared/widgets/quantity_selector.dart';
import '../../../shared/widgets/app_button.dart';
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

class _CartScreenState extends State<CartScreen> {
  final TextEditingController _promoController = TextEditingController();

  @override
  void dispose() {
    _promoController.dispose();
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

                  // Header
                  Padding(
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

                  const SizedBox(height: 16),

                  // Items List
                  Expanded(
                    child: ListView.separated(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: cart.items.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final item = cart.items[index];

                        return Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(22),
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
                                width: 76,
                                height: 76,
                                decoration: BoxDecoration(
                                  color: item.product.cardBackgroundColor,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
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

                              // Details
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                    const SizedBox(height: 2),
                                    Row(
                                      children: [
                                        Container(
                                          width: 10,
                                          height: 10,
                                          decoration: BoxDecoration(
                                            color: item.selectedColor.color,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                        const SizedBox(width: 6),
                                        Text(
                                          '${item.selectedMaterial.name} • ${item.selectedColor.name}',
                                          style: AppTypography.label.copyWith(
                                            fontSize: 11,
                                            color: AppColors.textSecondary,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      '\$${item.unitPrice.toStringAsFixed(0)}',
                                      style: AppTypography.price.copyWith(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // Quantity Control & Remove
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  // Coral delete pill button
                                  GestureDetector(
                                    onTap: () => cart.removeItem(item.id),
                                    child: Container(
                                      width: 32,
                                      height: 32,
                                      decoration: BoxDecoration(
                                        color: AppColors.accentCoral.withValues(alpha: 0.15),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: const Icon(
                                        Icons.delete_outline_rounded,
                                        size: 17,
                                        color: AppColors.accentCoral,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  // Stepper
                                  QuantitySelector(
                                    quantity: item.quantity,
                                    onQuantityChanged: (qty) {
                                      final delta = qty - item.quantity;
                                      cart.updateQuantity(item.id, delta);
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),

                  // Bottom Summary Card (Dark container)
                  Container(
                    margin: const EdgeInsets.fromLTRB(16, 8, 16, 90),
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      color: AppColors.primaryDark,
                      borderRadius: BorderRadius.circular(AppSpacing.radiusSheet),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primaryDark.withValues(alpha: 0.25),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Subtotal
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Subtotal', style: AppTypography.labelLight),
                            Text('\$${cart.subtotal.toStringAsFixed(0)}', style: AppTypography.bodyLight),
                          ],
                        ),
                        const SizedBox(height: 6),
                        // Delivery
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Delivery', style: AppTypography.labelLight),
                            Text(
                              cart.deliveryFee == 0 ? 'FREE' : '\$${cart.deliveryFee.toStringAsFixed(0)}',
                              style: AppTypography.bodyLight.copyWith(
                                color: cart.deliveryFee == 0 ? AppColors.accentMintDark : Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        if (cart.discountAmount > 0) ...[
                          const SizedBox(height: 6),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Promo Discount', style: AppTypography.labelLight),
                              Text(
                                '- \$${cart.discountAmount.toStringAsFixed(0)}',
                                style: AppTypography.bodyLight.copyWith(
                                  color: AppColors.accentCoral,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                        const SizedBox(height: 12),
                        const Divider(color: Colors.white12, height: 1),
                        const SizedBox(height: 14),
                        // Grand Total
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              AppStrings.grandTotal,
                              style: AppTypography.screenHeadingLight.copyWith(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              '\$${cart.grandTotal.toStringAsFixed(0)}',
                              style: AppTypography.screenHeadingLight.copyWith(
                                fontSize: 24,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 18),
                        // Proceed to Checkout CTA
                        AppButton(
                          text: AppStrings.makePayment,
                          variant: AppButtonVariant.primaryLight,
                          height: 56,
                          trailingIcon: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: AppColors.accentMint,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.arrow_forward_rounded,
                              size: 16,
                              color: AppColors.primaryDark,
                            ),
                          ),
                          onPressed: _proceedToCheckout,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
