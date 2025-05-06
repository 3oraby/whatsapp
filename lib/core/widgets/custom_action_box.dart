import 'package:flutter/material.dart';
import 'package:whatsapp/core/utils/app_colors.dart';

class CustomActionBox extends StatelessWidget {
  const CustomActionBox({
    super.key,
    required this.child,
    this.backgroundColor = AppColors.primary,
    this.internalHorizontalPadding = 16,
    this.internalVerticalPadding = 16,
    this.borderRadius = 30,
    this.onPressed,
    this.height,
    this.width,
    this.borderColor = Colors.white,
    this.borderWidth = 0,
  });

  final Widget child;
  final Color backgroundColor;
  final double internalHorizontalPadding;
  final double internalVerticalPadding;
  final double borderRadius;
  final VoidCallback? onPressed;
  final double? width;
  final double? height;
  final double borderWidth;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: height,
        width: width,
        padding: EdgeInsets.symmetric(
          horizontal: internalHorizontalPadding,
          vertical: internalVerticalPadding,
        ),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(borderRadius),
          border: borderWidth != 0
              ? Border.all(
                  color: borderColor,
                  width: borderWidth,
                )
              : null,
        ),
        child: child,
      ),
    );
  }
}
