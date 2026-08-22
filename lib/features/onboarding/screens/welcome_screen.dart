import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_strings.dart';
import '../../../shared/widgets/app_button.dart';
import '../../home/screens/main_navigation_shell.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with TickerProviderStateMixin {
  late AnimationController _introController;
  late AnimationController _exitController;

  late Animation<double> _bgScale;
  late Animation<double> _bgFade;

  late Animation<Offset> _headlineSlide;
  late Animation<double> _headlineFade;

  late Animation<Offset> _buttonSlide;
  late Animation<double> _buttonScale;
  late Animation<double> _buttonFade;

  late Animation<double> _exitFade;
  late Animation<Offset> _exitHeadlineSlide;
  late Animation<Offset> _exitButtonSlide;

  bool _isExiting = false;

  @override
  void initState() {
    super.initState();

    // Intro Animation Controller (1000ms)
    _introController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    // Exit Animation Controller (400ms)
    _exitController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    // 1. Background Image Slow Zoom & Fade In
    _bgScale = Tween<double>(begin: 1.12, end: 1.0).animate(
      CurvedAnimation(parent: _introController, curve: Curves.easeOutCubic),
    );
    _bgFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _introController,
        curve: const Interval(0.0, 0.4, curve: Curves.easeOut),
      ),
    );

    // 2. Headline & Dots Slide Up & Fade In
    _headlineSlide = Tween<Offset>(begin: const Offset(0, 0.35), end: Offset.zero).animate(
      CurvedAnimation(
        parent: _introController,
        curve: const Interval(0.2, 0.8, curve: Curves.easeOutCubic),
      ),
    );
    _headlineFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _introController,
        curve: const Interval(0.2, 0.7, curve: Curves.easeOut),
      ),
    );

    // 3. Button Pop & Slide In
    _buttonSlide = Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero).animate(
      CurvedAnimation(
        parent: _introController,
        curve: const Interval(0.4, 1.0, curve: Curves.easeOutBack),
      ),
    );
    _buttonScale = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(
        parent: _introController,
        curve: const Interval(0.4, 1.0, curve: Curves.easeOutBack),
      ),
    );
    _buttonFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _introController,
        curve: const Interval(0.4, 0.8, curve: Curves.easeOut),
      ),
    );

    // Exit Tweens: Headline slides up, Button slides down, Overall fades
    _exitFade = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _exitController, curve: Curves.easeInCubic),
    );
    _exitHeadlineSlide = Tween<Offset>(begin: Offset.zero, end: const Offset(0, -0.3)).animate(
      CurvedAnimation(parent: _exitController, curve: Curves.easeInCubic),
    );
    _exitButtonSlide = Tween<Offset>(begin: Offset.zero, end: const Offset(0, 0.4)).animate(
      CurvedAnimation(parent: _exitController, curve: Curves.easeInCubic),
    );

    // Start intro on mount
    _introController.forward();
  }

  @override
  void dispose() {
    _introController.dispose();
    _exitController.dispose();
    super.dispose();
  }

  void _onGetStarted() async {
    if (_isExiting) return;
    setState(() {
      _isExiting = true;
    });

    // Play exit motion
    await _exitController.forward();

    if (!mounted) return;

    // Navigate to Home with a fluid sliding fade transition
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => const MainNavigationShell(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final slideIn = Tween<Offset>(
            begin: const Offset(0, 0.04),
            end: Offset.zero,
          ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic));

          final fadeIn = Tween<double>(begin: 0.0, end: 1.0).animate(
            CurvedAnimation(parent: animation, curve: Curves.easeOut),
          );

          return SlideTransition(
            position: slideIn,
            child: FadeTransition(
              opacity: fadeIn,
              child: child,
            ),
          );
        },
        transitionDuration: const Duration(milliseconds: 350),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      body: AnimatedBuilder(
        animation: Listenable.merge([_introController, _exitController]),
        builder: (context, child) {
          return Opacity(
            opacity: _exitFade.value,
            child: Stack(
              fit: StackFit.expand,
              children: [
                // 1. Background Image with Zoom & Fade
                Transform.scale(
                  scale: _bgScale.value * (1.0 + 0.05 * _exitController.value),
                  child: Opacity(
                    opacity: _bgFade.value,
                    child: Image.asset(
                      'assets/images/welcome_sofa.jpg',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: const Color(0xFF2C3240),
                        child: const Center(
                          child: Icon(Icons.weekend_rounded, size: 80, color: Colors.white24),
                        ),
                      ),
                    ),
                  ),
                ),

                // 2. Gradient Overlay for readability
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withValues(alpha: 0.25),
                        Colors.black.withValues(alpha: 0.1),
                        Colors.black.withValues(alpha: 0.65),
                        Colors.black.withValues(alpha: 0.85),
                      ],
                      stops: const [0.0, 0.4, 0.75, 1.0],
                    ),
                  ),
                ),

                // 3. Content Layer (Headline + Indicators + Button)
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Spacer(flex: 2),

                        // Animated Headline & Dots
                        Transform.translate(
                          offset: _isExiting
                              ? Offset(0, _exitHeadlineSlide.value.dy * 100)
                              : Offset(0, _headlineSlide.value.dy * 100),
                          child: Opacity(
                            opacity: _headlineFade.value,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  AppStrings.welcomeHeadline,
                                  style: AppTypography.heroHeadingLight.copyWith(
                                    fontSize: 36,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: -1.0,
                                    height: 1.15,
                                  ),
                                ),
                                const SizedBox(height: AppSpacing.md),

                                // Slide indicators (● ─ ─)
                                Row(
                                  children: [
                                    Container(
                                      width: 8,
                                      height: 8,
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Container(
                                      width: 22,
                                      height: 4,
                                      decoration: BoxDecoration(
                                        color: Colors.white.withValues(alpha: 0.4),
                                        borderRadius: BorderRadius.circular(2),
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Container(
                                      width: 22,
                                      height: 4,
                                      decoration: BoxDecoration(
                                        color: Colors.white.withValues(alpha: 0.4),
                                        borderRadius: BorderRadius.circular(2),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),

                        const Spacer(flex: 3),

                        // Animated Get Started Action Button
                        Transform.translate(
                          offset: _isExiting
                              ? Offset(0, _exitButtonSlide.value.dy * 100)
                              : Offset(0, _buttonSlide.value.dy * 100),
                          child: Transform.scale(
                            scale: _buttonScale.value,
                            child: Opacity(
                              opacity: _buttonFade.value,
                              child: AppButton(
                                text: AppStrings.getStarted,
                                variant: AppButtonVariant.primaryDark,
                                height: 60,
                                borderRadius: AppSpacing.radiusNav,
                                onPressed: _onGetStarted,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
