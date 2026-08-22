import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/bottom_nav_bar.dart';
import 'home_screen.dart';
import '../../search/screens/search_screen.dart';
import '../../cart/screens/cart_screen.dart';
import '../../favorites/screens/favorites_screen.dart';
import '../../profile/screens/profile_screen.dart';

class MainNavigationShell extends StatefulWidget {
  final int initialIndex;

  const MainNavigationShell({
    super.key,
    this.initialIndex = 0,
  });

  @override
  State<MainNavigationShell> createState() => _MainNavigationShellState();
}

class _MainNavigationShellState extends State<MainNavigationShell> with SingleTickerProviderStateMixin {
  late int _currentIndex;
  late AnimationController _navAnimationController;
  late Animation<Offset> _navSlideAnimation;
  late Animation<double> _navFadeAnimation;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;

    _navAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    // Floating Nav slides up from below (0.55 -> 1.0)
    _navSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 1.6),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _navAnimationController,
        curve: const Interval(0.55, 1.0, curve: Curves.easeOutBack),
      ),
    );

    _navFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _navAnimationController,
        curve: const Interval(0.55, 0.90, curve: Curves.easeOut),
      ),
    );

    _navAnimationController.forward();
  }

  @override
  void dispose() {
    _navAnimationController.dispose();
    super.dispose();
  }

  void _onTabSelected(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      HomeScreen(onNavigateTab: _onTabSelected),
      const SearchScreen(),
      CartScreen(onExploreTap: () => _onTabSelected(0)),
      FavoritesScreen(onExploreTap: () => _onTabSelected(0)),
      const ProfileScreen(),
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Current Tab Screen
          IndexedStack(
            index: _currentIndex,
            children: screens,
          ),

          // Animated Floating Bottom Navigation Bar
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: SlideTransition(
              position: _navSlideAnimation,
              child: FadeTransition(
                opacity: _navFadeAnimation,
                child: BottomNavBar(
                  currentIndex: _currentIndex,
                  onTabSelected: _onTabSelected,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
