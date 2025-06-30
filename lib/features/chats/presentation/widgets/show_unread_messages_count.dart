import 'package:flutter/material.dart';
import 'package:whatsapp/core/utils/app_colors.dart';
import 'package:whatsapp/core/utils/app_text_styles.dart';

class ShowUnreadMessagesCounts extends StatelessWidget {
  const ShowUnreadMessagesCounts({
    super.key,
    required this.unreadCount,
  });

  final int unreadCount;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        unreadCount.toString(),
        style: AppTextStyles.poppinsBold(context, 12).copyWith(
          color: Colors.white,
        ),
      ),
    );
  }
}
