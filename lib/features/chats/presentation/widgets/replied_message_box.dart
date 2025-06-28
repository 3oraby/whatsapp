import 'package:flutter/material.dart';
import 'package:whatsapp/core/utils/app_colors.dart';
import 'package:whatsapp/core/utils/app_constants.dart';
import 'package:whatsapp/core/utils/app_text_styles.dart';
import 'package:whatsapp/core/widgets/horizontal_gap.dart';
import 'package:whatsapp/core/widgets/vertical_gap.dart';
import 'package:whatsapp/features/chats/domain/entities/message_entity.dart';

class RepliedMessageBox extends StatelessWidget {
  const RepliedMessageBox({
    super.key,
    required this.msg,
  });

  final MessageEntity msg;

  @override
  Widget build(BuildContext context) {
    final Color sectionColor =
        msg.isFromMe ? AppColors.primary : Colors.deepOrange;
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade400,
        borderRadius: BorderRadius.circular(
          AppConstants.messageBorderRadius,
        ),
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Container(
              width: 6,
              decoration: BoxDecoration(
                color: sectionColor,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(
                    AppConstants.messageBorderRadius,
                  ),
                  topLeft: Radius.circular(
                    AppConstants.messageBorderRadius,
                  ),
                ),
              ),
            ),
            const HorizontalGap(8),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 12,
                  bottom: 12,
                  right: 8,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      msg.isFromMe ? "You" : msg.sender!.name,
                      style: AppTextStyles.poppinsBold(context, 15).copyWith(
                        color: sectionColor,
                      ),
                    ),
                    const VerticalGap(4),
                    Text(
                      msg.content ?? "",
                      style: AppTextStyles.poppinsMedium(context, 14).copyWith(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
