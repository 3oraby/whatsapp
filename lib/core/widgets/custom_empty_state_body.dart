import 'package:flutter/material.dart';
import 'package:whatsapp/core/utils/app_text_styles.dart';
import 'package:whatsapp/core/widgets/vertical_gap.dart';

class CustomEmptyStateBody extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData? icon;
  final double iconSize;
  final Color? iconColor;

  const CustomEmptyStateBody({
    super.key,
    required this.title,
    this.subtitle = "Try a different name or check your spelling.",
    this.icon = Icons.inbox,
    this.iconSize = 130,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: iconSize,
              color: iconColor ?? Colors.grey[400],
            ),
            const VerticalGap(16),
            Text(
              title,
              textAlign: TextAlign.center,
              style: AppTextStyles.poppinsBold(context, 24).copyWith(
                color: Colors.grey[700],
              ),
            ),
            if (subtitle != null) ...[
              const VerticalGap(8),
              Text(
                subtitle!,
                textAlign: TextAlign.center,
                style: AppTextStyles.poppinsMedium(context, 16).copyWith(
                  color: Colors.grey[500],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
