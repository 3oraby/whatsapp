import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp/core/utils/app_colors.dart';
import 'package:whatsapp/core/utils/app_text_styles.dart';
import 'package:whatsapp/core/widgets/custom_action_box.dart';

class StartChatButton extends StatelessWidget {
  const StartChatButton({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomActionBox(
      width: 95,
      height: 40,
      internalVerticalPadding: 0,
      internalHorizontalPadding: 0,
      backgroundColor: AppColors.primary,
      onPressed: () {
        // navigate to chat screen and make new chat
      },
      child: Center(
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Row(
            spacing: 8,
            children: [
              Icon(
                Icons.chat_bubble,
                color: Colors.white,
                size: 22,
              ),
              Text(
                context.tr("Chat"),
                style: AppTextStyles.poppinsBold(context, 14).copyWith(
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
