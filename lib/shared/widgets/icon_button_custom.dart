import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

enum CustomIconVariant {
  whiteSurface,
  darkNavy,
  mint,
  translucent,
}

class IconButtonCustom extends StatefulWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final CustomIconVariant variant;
  final double size;
  final double iconSize;
  final Color? iconColor;
  final String? badge;

  const IconButtonCustom({
    super.key,
    required this.icon,
    required this.onPressed,
    this.variant = CustomIconVariant.whiteSurface,
    this.size = 48.0,
    this.iconSize = 22.0,
    this.iconColor,
    this.badge,
  });

  @override
  State<IconButtonCustom> createState() => _IconButtonCustomState();
}

class _IconButtonCustomState extends State<IconButtonCustom> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.92).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color get _bgColor {
    switch (widget.variant) {
      case CustomIconVariant.whiteSurface:
        return AppColors.surface;
      case CustomIconVariant.darkNavy:
        return AppColors.primaryDark;
      case CustomIconVariant.mint:
        return AppColors.accentMint;
      case CustomIconVariant.translucent:
        return AppColors.primaryDark.withValues(alpha: 0.08);
    }
  }

  Color get _iconColor {
    if (widget.iconColor != null) return widget.iconColor!;
    switch (widget.variant) {
      case CustomIconVariant.whiteSurface:
      case CustomIconVariant.mint:
      case CustomIconVariant.translucent:
        return AppColors.primaryDark;
      case CustomIconVariant.darkNavy:
        return AppColors.textLight;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: widget.onPressed == null ? null : (_) => _controller.forward(),
      onTapUp: widget.onPressed == null ? null : (_) => _controller.reverse(),
      onTapCancel: () => _controller.reverse(),
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: widget.size,
              height: widget.size,
              decoration: BoxDecoration(
                color: _bgColor,
                shape: BoxShape.circle,
                boxShadow: widget.variant == CustomIconVariant.whiteSurface
                    ? [
                        BoxShadow(
                          color: AppColors.primaryDark.withValues(alpha: 0.06),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : null,
              ),
              child: IconButton(
                padding: EdgeInsets.zero,
                icon: Icon(
                  widget.icon,
                  size: widget.iconSize,
                  color: _iconColor,
                ),
                onPressed: widget.onPressed,
              ),
            ),
            if (widget.badge != null && widget.badge!.isNotEmpty)
              Positioned(
                top: -2,
                right: -2,
                child: Container(
                  padding: const EdgeInsets.all(5),
                  decoration: const BoxDecoration(
                    color: AppColors.accentCoral,
                    shape: BoxShape.circle,
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 18,
                    minHeight: 18,
                  ),
                  child: Center(
                    child: Text(
                      widget.badge!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        height: 1,
                      ),
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
