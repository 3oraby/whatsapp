import 'package:flutter/material.dart';
import 'package:whatsapp/core/utils/app_colors.dart';
import 'package:whatsapp/core/widgets/custom_background_icon.dart';

class CustomSendStoryButton extends StatelessWidget {
  const CustomSendStoryButton({
    super.key,
    this.onTap,
  });

  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) {
    return CustomBackgroundIcon(
      onTap: onTap,
      iconData: Icons.send,
      iconColor: Colors.white,
      backgroundColor: AppColors.primary,
    );
  }
}
