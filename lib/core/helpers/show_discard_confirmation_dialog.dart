import 'package:flutter/material.dart';
import 'package:whatsapp/core/utils/app_text_styles.dart';

Future<void> showDiscardConfirmationDialog({
  required BuildContext context,
  String title = "Discard Changes?",
  String content = "Are you sure you want to discard your changes?",
  String confirmText = "Discard",
  String cancelText = "Cancel",
  required VoidCallback onConfirm,
}) async {
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(
        title,
        style: AppTextStyles.poppinsBold(context, 20),
      ),
      content: Text(content),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(cancelText),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            onConfirm();
          },
          style: TextButton.styleFrom(foregroundColor: Colors.red),
          child: Text(confirmText),
        ),
      ],
    ),
  );
}
