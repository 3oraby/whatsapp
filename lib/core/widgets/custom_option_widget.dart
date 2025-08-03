import 'package:flutter/material.dart';
import 'package:whatsapp/core/utils/app_text_styles.dart';

class CustomOptionWidget extends StatelessWidget {
  const CustomOptionWidget({
    super.key,
    required this.onTap,
    required this.icon,
    this.themeColor = Colors.black,
    required this.label,
  });

  final IconData icon;
  final Color themeColor;
  final String label;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).maybePop();
        onTap();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: AppTextStyles.poppinsMedium(
                context,
                14,
              ).copyWith(
                color: themeColor,
              ),
            ),
            Icon(
              icon,
              color: themeColor,
            ),
          ],
        ),
      ),
    );
  }
}
