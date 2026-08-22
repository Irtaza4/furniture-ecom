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

class _ProfileScreenState extends State<ProfileScreen> with SingleTickerProviderStateMixin {
  bool _pushNotifications = true;

  late AnimationController _animController;
  late Animation<double> _headerFade;
  late Animation<Offset> _headerSlide;
  late Animation<double> _profileCardScale;
  late Animation<double> _profileCardFade;
  late Animation<double> _statsFade;
  late Animation<Offset> _statsSlide;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    // 1. Header (0.0 -> 0.35)
    _headerFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animController, curve: const Interval(0.0, 0.35, curve: Curves.easeOut)),
    );
    _headerSlide = Tween<Offset>(begin: const Offset(0, -0.4), end: Offset.zero).animate(
      CurvedAnimation(parent: _animController, curve: const Interval(0.0, 0.35, curve: Curves.easeOutCubic)),
    );

    // 2. Profile Card (0.15 -> 0.55)
    _profileCardFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animController, curve: const Interval(0.15, 0.45, curve: Curves.easeOut)),
    );
    _profileCardScale = Tween<double>(begin: 0.90, end: 1.0).animate(
      CurvedAnimation(parent: _animController, curve: const Interval(0.15, 0.55, curve: Curves.easeOutBack)),
    );

    // 3. Stats Row (0.30 -> 0.65)
    _statsFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animController, curve: const Interval(0.30, 0.60, curve: Curves.easeOut)),
    );
    _statsSlide = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
      CurvedAnimation(parent: _animController, curve: const Interval(0.30, 0.65, curve: Curves.easeOutBack)),
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

  Widget _buildStatCard(String title, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: AppTypography.screenHeading.copyWith(
                fontSize: 22,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: AppTypography.label.copyWith(
                fontSize: 12,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuOption(IconData icon, String title, String subtitle, {VoidCallback? onTap, Widget? trailing, required int index}) {
    final start = (0.45 + (index * 0.06)).clamp(0.0, 0.85);
    final end = (start + 0.30).clamp(0.0, 1.0);

    final itemFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animController, curve: Interval(start, (start + 0.15).clamp(0.0, 1.0), curve: Curves.easeOut)),
    );
    final itemSlide = Tween<Offset>(begin: const Offset(0.15, 0), end: Offset.zero).animate(
      CurvedAnimation(parent: _animController, curve: Interval(start, end, curve: Curves.easeOutCubic)),
    );

    return SlideTransition(
      position: itemSlide,
      child: FadeTransition(
        opacity: itemFade,
        child: GestureDetector(
          onTap: onTap,
          behavior: HitTestBehavior.opaque,
          child: Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryDark.withValues(alpha: 0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(icon, color: AppColors.primaryDark, size: 20),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: AppTypography.productName.copyWith(fontSize: 15)),
                      Text(subtitle, style: AppTypography.label.copyWith(fontSize: 11, color: AppColors.textSecondary)),
                    ],
                  ),
                ),
                trailing ?? const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppColors.textSecondary),
              ],
            ),
          ),
        ),
      ),
    );
  }

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
              // Header: Slide & Fade
              SlideTransition(
                position: _headerSlide,
                child: FadeTransition(
                  opacity: _headerFade,
                  child: Text(
                    'Account',
                    style: AppTypography.screenHeading.copyWith(
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Profile Card: Pop & Scale
              ScaleTransition(
                scale: _profileCardScale,
                child: FadeTransition(
                  opacity: _profileCardFade,
                  child: Container(
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
                ),
              ),

              const SizedBox(height: 20),

              // Stats Row: Bounce & Fade
              SlideTransition(
                position: _statsSlide,
                child: FadeTransition(
                  opacity: _statsFade,
                  child: Row(
                    children: [
                      _buildStatCard('Orders', '${cart.orders.length}', AppColors.cardMint),
                      const SizedBox(width: 12),
                      _buildStatCard('Wishlist', '$favCount', AppColors.cardLavender),
                      const SizedBox(width: 12),
                      _buildStatCard('Addresses', '${FurnitureDataService.savedAddresses.length}', AppColors.cardWarmGray),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 26),

              // Account Options Menu: Staggered List Cascade
              Text(
                'Settings & Preferences',
                style: AppTypography.sectionTitle.copyWith(fontSize: 18),
              ),
              const SizedBox(height: 12),

              _buildMenuOption(Icons.location_on_outlined, 'Shipping Addresses', '${FurnitureDataService.savedAddresses.length} saved locations', index: 0),
              _buildMenuOption(Icons.payment_outlined, 'Payment Methods', 'Mastercard ending in 4242', index: 1),
              _buildMenuOption(
                Icons.notifications_none_rounded,
                'Push Notifications',
                _pushNotifications ? 'Active' : 'Disabled',
                index: 2,
                trailing: Switch.adaptive(
                  value: _pushNotifications,
                  activeTrackColor: AppColors.accentPurple,
                  onChanged: (val) => setState(() => _pushNotifications = val),
                ),
              ),
              _buildMenuOption(Icons.security_outlined, 'Privacy & Security', 'FaceID, 2FA enabled', index: 3),
              _buildMenuOption(Icons.headset_mic_outlined, 'Customer Support', '24/7 Concierge & chat', index: 4),
              _buildMenuOption(Icons.logout_rounded, 'Sign Out', 'Alex Morgan (VIP)', index: 5),
            ],
          ),
        ),
      ),
    );
  }
}
