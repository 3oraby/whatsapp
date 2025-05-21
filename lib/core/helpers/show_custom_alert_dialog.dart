import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp/core/utils/app_colors.dart';
import 'package:whatsapp/core/utils/app_text_styles.dart';

void showCustomAlertDialog({
  required BuildContext context,
  required String title,
  required String content,
  required String okButtonDescription,
  String? cancelButtonDescription,
  VoidCallback? onCancelButtonPressed,
  VoidCallback? onOkButtonPressed,
}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          Row(
            children: [
              TextButton(
                onPressed: onCancelButtonPressed,
                child: Text(
                  cancelButtonDescription ?? context.tr("Cancel"),
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: onOkButtonPressed,
                child: Text(
                  okButtonDescription,
                  style: AppTextStyles.poppinsMedium(context,18).copyWith(
                    color: AppColors.error,
                  ),
                ),
              ),
            ],
          ),
        ],
      );
    },
  );
}
