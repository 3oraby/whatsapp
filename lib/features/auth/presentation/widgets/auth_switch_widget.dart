import 'package:flutter/material.dart';
import 'package:whatsapp/core/utils/app_colors.dart';
import 'package:whatsapp/core/utils/app_text_styles.dart';

class AuthSwitchWidget extends StatelessWidget {
  final String promptText;
  final String actionText;
  final VoidCallback onActionPressed;
  final Color? promptTextColor;
  final Color? actionTextColor;
  final double? promptTextSize;
  final double? actionTextSize;
  const AuthSwitchWidget({
    super.key,
    required this.promptText,
    required this.actionText,
    required this.onActionPressed,
    this.promptTextColor = AppColors.primaryColor,
    this.actionTextColor = AppColors.primaryColor,
    this.promptTextSize = 18,
    this.actionTextSize = 24,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          promptText,
          style: AppTextStyles.poppinsRegular(context, 18).copyWith(
            color: promptTextColor,
          ),
        ),
        TextButton(
          onPressed: onActionPressed,
          child: Text(
            actionText,
            style: AppTextStyles.poppinsBold(context, 24).copyWith(
              color: actionTextColor,
              decoration: TextDecoration.underline,
              decorationColor: actionTextColor,
            ),
          ),
        ),
      ],
    );
  }
}
