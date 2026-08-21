import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/constants/app_spacing.dart';

enum AppButtonVariant {
  primaryDark,
  primaryLight,
  mint,
  coral,
  outline,
}

class AppButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final Widget? leadingIcon;
  final Widget? trailingIcon;
  final double? width;
  final double height;
  final double borderRadius;
  final bool isLoading;

  const AppButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.variant = AppButtonVariant.primaryDark,
    this.leadingIcon,
    this.trailingIcon,
    this.width,
    this.height = 56.0,
    this.borderRadius = AppSpacing.radiusButton,
    this.isLoading = false,
  });

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.97).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color get _backgroundColor {
    switch (widget.variant) {
      case AppButtonVariant.primaryDark:
        return AppColors.primaryDark;
      case AppButtonVariant.primaryLight:
        return AppColors.surface;
      case AppButtonVariant.mint:
        return AppColors.accentMint;
      case AppButtonVariant.coral:
        return AppColors.accentCoral;
      case AppButtonVariant.outline:
        return Colors.transparent;
    }
  }

  Color get _foregroundColor {
    switch (widget.variant) {
      case AppButtonVariant.primaryDark:
      case AppButtonVariant.coral:
        return AppColors.textLight;
      case AppButtonVariant.primaryLight:
      case AppButtonVariant.mint:
      case AppButtonVariant.outline:
        return AppColors.primaryDark;
    }
  }

  Border? get _border {
    if (widget.variant == AppButtonVariant.outline) {
      return Border.all(color: AppColors.primaryDark, width: 1.5);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: widget.onPressed == null ? null : (_) => _controller.forward(),
      onTapUp: widget.onPressed == null ? null : (_) => _controller.reverse(),
      onTapCancel: () => _controller.reverse(),
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: SizedBox(
          width: widget.width ?? double.infinity,
          height: widget.height,
          child: ElevatedButton(
            onPressed: widget.isLoading ? null : widget.onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: _backgroundColor,
              foregroundColor: _foregroundColor,
              disabledBackgroundColor: _backgroundColor.withValues(alpha: 0.5),
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(widget.borderRadius),
                side: _border != null ? _border!.top : BorderSide.none,
              ),
            ),
            child: widget.isLoading
                ? SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      valueColor: AlwaysStoppedAnimation<Color>(_foregroundColor),
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (widget.leadingIcon != null) ...[
                        widget.leadingIcon!,
                        const SizedBox(width: AppSpacing.sm),
                      ],
                      Text(
                        widget.text,
                        style: AppTypography.button.copyWith(
                          color: _foregroundColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      if (widget.trailingIcon != null) ...[
                        const SizedBox(width: AppSpacing.sm),
                        widget.trailingIcon!,
                      ],
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
