import 'package:flutter/material.dart';
import 'package:whatsapp/core/helpers/is_light_theme.dart';
import 'package:whatsapp/core/utils/app_colors.dart';
import 'package:whatsapp/core/utils/app_text_styles.dart';
import 'package:whatsapp/core/widgets/vertical_gap.dart';

class CustomErrorBodyWidget extends StatelessWidget {
  final String errorMessage;
  final VoidCallback? onRetry;
  final IconData icon;

  const CustomErrorBodyWidget({
    super.key,
    required this.errorMessage,
    this.onRetry,
    this.icon = Icons.error_outline,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 130, color: Colors.redAccent),
          const VerticalGap(16),
          Text(
            "Oops!",
            style: AppTextStyles.poppinsBold(context, 22),
          ),
          const VerticalGap(8),
          Text(
            errorMessage,
            textAlign: TextAlign.center,
            style: AppTextStyles.poppinsMedium(context, 16).copyWith(
              color: Colors.grey[600],
            ),
          ),
          if (onRetry != null) ...[
            const VerticalGap(24),
            Container(
              color: isLightTheme(context)
                  ? AppColors.highlightBackgroundColor
                  : AppColors.highlightBackgroundColorDark,
              child: TextButton.icon(
                onPressed: onRetry,
                icon: const Icon(
                  Icons.refresh,
                  size: 20,
                  color: AppColors.primary,
                ),
                label: Text(
                  "Try Again",
                  style: AppTextStyles.poppinsBold(context, 16)
                      .copyWith(color: AppColors.primary),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
