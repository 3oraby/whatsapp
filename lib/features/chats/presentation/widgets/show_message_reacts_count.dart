import 'package:flutter/material.dart';
import 'package:whatsapp/core/utils/app_constants.dart';
import 'package:whatsapp/core/utils/app_text_styles.dart';
import 'package:whatsapp/features/chats/domain/entities/message_entity.dart';
import 'package:whatsapp/features/chats/domain/enums/message_react.dart';
import 'package:whatsapp/features/chats/presentation/widgets/message_reacts_bottom_sheet.dart';

class ShowMessageReactsCount extends StatelessWidget {
  const ShowMessageReactsCount({
    super.key,
    required this.msg,
  });

  final MessageEntity msg;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
                top: Radius.circular(
              AppConstants.bottomSheetBorderRadius,
            )),
          ),
          builder: (_) => MessageReactsBottomSheet(reacts: msg.reacts),
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(right: 8, left: 8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 2,
                offset: Offset(0, 1),
              ),
            ],
          ),
          child: Text(
            MessageReactExtension.getEmojiFromReactWithCount(
              reacts: msg.reacts,
            ),
            style: AppTextStyles.poppinsMedium(context, 14).copyWith(
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
        ),
      ),
    );
  }
}
