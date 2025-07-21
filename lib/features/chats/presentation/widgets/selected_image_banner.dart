import 'dart:io';
import 'package:flutter/material.dart';
import 'package:whatsapp/core/utils/app_colors.dart';
import 'package:whatsapp/core/utils/app_constants.dart';
import 'package:whatsapp/core/widgets/horizontal_gap.dart';

class SelectedImageBanner extends StatelessWidget {
  final File imageFile;
  final VoidCallback onCancel;

  const SelectedImageBanner({
    super.key,
    required this.imageFile,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      color: AppColors.lightChatAppBarColor,
      padding: EdgeInsets.only(right: AppConstants.horizontalPadding),
      child: Row(
        children: [
          Container(width: 7, color: AppColors.primary),
          const HorizontalGap(14),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: Image.file(
              imageFile,
              width: 50,
              height: 50,
              fit: BoxFit.cover,
            ),
          ),
          const HorizontalGap(12),
          const Text(
            'Image selected',
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.clear),
            onPressed: onCancel,
          ),
        ],
      ),
    );
  }
}
