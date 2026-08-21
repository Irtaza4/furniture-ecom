import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/services/cart_provider.dart';
import '../../../shared/services/favorites_provider.dart';
import '../../../shared/services/furniture_data_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _pushNotifications = true;

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    final favCount = Provider.of<FavoritesProvider>(context).favoriteProductIds.length;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 110),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Text(
                'Account',
                style: AppTypography.screenHeading.copyWith(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                ),
              ),

              const SizedBox(height: 16),

              // Profile Card (Dark container)
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.primaryDark,
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryDark.withValues(alpha: 0.15),
                      blurRadius: 18,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // Avatar
                    Container(
                      width: 60,
                      height: 60,
                      decoration: const BoxDecoration(
                        color: AppColors.accentMint,
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Text(
                          'AM',
                          style: TextStyle(
                            color: AppColors.primaryDark,
                            fontWeight: FontWeight.w800,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Alex Morgan',
                            style: AppTypography.screenHeadingLight.copyWith(
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'alex.morgan@designstudio.com',
                            style: AppTypography.labelLight.copyWith(
                              color: Colors.white70,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                            decoration: BoxDecoration(
                              color: AppColors.accentPurple,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Text(
                              'VIP MEMBER',
                              style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Stats Row
              Row(
                children: [
                  _buildStatCard('Orders', '${cart.orders.length}', AppColors.cardMint),
                  const SizedBox(width: 12),
                  _buildStatCard('Wishlist', '$favCount', AppColors.cardLavender),
                  const SizedBox(width: 12),
                  _buildStatCard('Addresses', '${FurnitureDataService.savedAddresses.length}', AppColors.cardWarmGray),
                ],
              ),

              const SizedBox(height: 26),

              // Recent Orders
              Text(
                'Recent Orders',
                style: AppTypography.sectionTitle.copyWith(fontSize: 18),
              ),
              const SizedBox(height: 12),

              if (cart.orders.isEmpty)
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.inventory_2_outlined, color: AppColors.textSecondary),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'No orders placed yet. Start shopping!',
                          style: AppTypography.body,
                        ),
                      ),
                    ],
                  ),
                )
              else
                ...cart.orders.map((order) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(order.id, style: AppTypography.productName.copyWith(fontSize: 15)),
                            const SizedBox(height: 2),
                            Text('${order.items.length} items • \$${order.total.toStringAsFixed(0)}',
                                style: AppTypography.label),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.accentMint,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'CONFIRMED',
                            style: AppTypography.labelBold.copyWith(
                              fontSize: 10,
                              color: AppColors.primaryDark,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),

              const SizedBox(height: 26),

              // Settings & Options
              Text(
                'Preferences',
                style: AppTypography.sectionTitle.copyWith(fontSize: 18),
              ),
              const SizedBox(height: 12),

              Container(
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Column(
                  children: [
                    SwitchListTile(
                      value: _pushNotifications,
                      onChanged: (val) => setState(() => _pushNotifications = val),
                      title: Text('Order Status Notifications', style: AppTypography.bodyMedium),
                      activeTrackColor: AppColors.accentPurple,
                    ),
                    const Divider(height: 1, indent: 16, endIndent: 16),
                    ListTile(
                      leading: const Icon(Icons.language_rounded, size: 20, color: AppColors.primaryDark),
                      title: Text('Language & Currency', style: AppTypography.bodyMedium),
                      trailing: Text('USD (\$)', style: AppTypography.labelBold),
                    ),
                    const Divider(height: 1, indent: 16, endIndent: 16),
                    ListTile(
                      leading: const Icon(Icons.help_outline_rounded, size: 20, color: AppColors.primaryDark),
                      title: Text('Customer Concierge', style: AppTypography.bodyMedium),
                      trailing: const Icon(Icons.chevron_right_rounded, color: AppColors.textSecondary),
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Support Concierge available 24/7 at support@furniture.luxury')),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String count, Color bgColor) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            Text(
              count,
              style: AppTypography.heroHeading.copyWith(
                fontSize: 22,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              title,
              style: AppTypography.label.copyWith(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppColors.primaryDark.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
