import 'package:flutter/material.dart';
import 'package:whatsapp/core/utils/app_constants.dart';

class CustomAppPadding extends StatelessWidget {
  const CustomAppPadding({
    super.key,
    required this.child,
    this.horizontal = AppConstants.horizontalPadding,
    this.vertical = 8,
  });

  final double horizontal;
  final double vertical;
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: horizontal,
        vertical: vertical,
      ),
      child: child,
    );
  }
}
