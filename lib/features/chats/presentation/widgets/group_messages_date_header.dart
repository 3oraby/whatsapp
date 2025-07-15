import 'package:flutter/material.dart';
import 'package:whatsapp/core/utils/app_text_styles.dart';

class GroupMessagesDateHeader extends StatelessWidget {
  const GroupMessagesDateHeader({
    super.key,
    required this.label,
  });
  final String label;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            label,
            style: AppTextStyles.poppinsBold(context, 16),
          ),
        ),
      ),
    );
  }
}
