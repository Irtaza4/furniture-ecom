import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/constants/app_strings.dart';
import '../../../shared/models/order.dart';
import '../../../shared/widgets/app_button.dart';
import '../../home/screens/main_navigation_shell.dart';

class OrderConfirmationScreen extends StatelessWidget {
  final Order order;

  const OrderConfirmationScreen({
    super.key,
    required this.order,
  });

  void _backToHome(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => const MainNavigationShell(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),

              // Celebration Icon Badge
              Container(
                width: 100,
                height: 100,
                decoration: const BoxDecoration(
                  color: AppColors.accentMint,
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Icon(
                    Icons.check_circle_rounded,
                    size: 54,
                    color: AppColors.accentMintDark,
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Heading
              Text(
                AppStrings.orderConfirmed,
                style: AppTypography.heroHeading.copyWith(fontSize: 28),
              ),

              const SizedBox(height: 8),

              Text(
                'Thank you for your purchase! We are preparing your crafted furniture with utmost care.',
                textAlign: TextAlign.center,
                style: AppTypography.body,
              ),

              const SizedBox(height: 28),

              // Order Summary Info Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryDark.withValues(alpha: 0.05),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Order Number', style: AppTypography.label),
                        Text(order.id, style: AppTypography.labelBold.copyWith(color: AppColors.accentPurple)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Estimated Delivery', style: AppTypography.label),
                        Text(order.estimatedDelivery, style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Shipping Method', style: AppTypography.label),
                        Text(order.deliveryMethod.name, style: AppTypography.bodyMedium),
                      ],
                    ),
                    const Divider(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Total Paid', style: AppTypography.sectionTitle.copyWith(fontSize: 16)),
                        Text(
                          '\$${order.total.toStringAsFixed(0)}',
                          style: AppTypography.sectionTitle.copyWith(
                            fontSize: 18,
                            color: AppColors.primaryDark,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Tracking Step Progress
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.primaryDark,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Delivery Progress',
                      style: AppTypography.screenHeadingLight.copyWith(fontSize: 16),
                    ),
                    const SizedBox(height: 16),
                    _buildTrackingRow(
                      icon: Icons.check_circle_rounded,
                      title: 'Order Placed',
                      subtitle: 'We have received your order',
                      isActive: true,
                      isCompleted: true,
                    ),
                    _buildTrackingRow(
                      icon: Icons.precision_manufacturing_rounded,
                      title: 'Crafting & Quality Check',
                      subtitle: 'Assembling materials at studio',
                      isActive: true,
                      isCompleted: false,
                    ),
                    _buildTrackingRow(
                      icon: Icons.local_shipping_outlined,
                      title: 'Dispatched to Courier',
                      subtitle: 'Expected in 2 days',
                      isActive: false,
                      isCompleted: false,
                      isLast: true,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Actions
              AppButton(
                text: AppStrings.continueShopping,
                variant: AppButtonVariant.primaryDark,
                onPressed: () => _backToHome(context),
              ),

              const SizedBox(height: 14),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTrackingRow({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isActive,
    required bool isCompleted,
    bool isLast = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Icon(
              icon,
              size: 20,
              color: isCompleted
                  ? AppColors.accentMintDark
                  : (isActive ? AppColors.accentPurple : Colors.white24),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 28,
                color: isCompleted ? AppColors.accentMintDark : Colors.white12,
              ),
          ],
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTypography.bodyMedium.copyWith(
                  color: isActive ? Colors.white : Colors.white38,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                subtitle,
                style: AppTypography.label.copyWith(
                  color: Colors.white38,
                  fontSize: 11,
                ),
              ),
              if (!isLast) const SizedBox(height: 12),
            ],
          ),
        ),
      ],
    );
  }
}
