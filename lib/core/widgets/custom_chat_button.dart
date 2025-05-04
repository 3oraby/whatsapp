import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp/core/utils/app_colors.dart';
import 'package:whatsapp/core/utils/app_text_styles.dart';
import 'package:whatsapp/core/widgets/custom_action_box.dart';

class CustomChatButton extends StatelessWidget {
  const CustomChatButton({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomActionBox(
      width: 115,
      height: 40,
      internalVerticalPadding: 0,
      internalHorizontalPadding: 0,
      borderColor: AppColors.inputBorderLight,
      borderWidth: 1,
      backgroundColor: AppColors.actionColor,
      onPressed: () {
        // navigate to chat screen and make new chat
      },
      child: Center(
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Row(
            spacing: 6,
            children: [
              Text(
                context.tr("Chat"),
                style: AppTextStyles.poppinsBold(context, 14).copyWith(
                  color: Colors.white,
                ),
              ),
              Icon(
                Icons.chat,
                color: Colors.white,
              )
            ],
          ),
        ),
      ),
    );
  }
}
