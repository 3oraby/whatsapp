import 'package:flutter/material.dart';
import 'package:whatsapp/core/helpers/is_light_theme.dart';
import 'package:whatsapp/core/utils/app_colors.dart';
import 'package:whatsapp/core/utils/app_routes.dart';
import 'package:whatsapp/core/utils/app_text_styles.dart';
import 'package:whatsapp/core/widgets/build_user_profile_image.dart';
import 'package:whatsapp/core/widgets/horizontal_gap.dart';
import 'package:whatsapp/features/chats/domain/entities/chat_entity.dart';
import 'package:whatsapp/features/chats/domain/entities/last_message_entity.dart';
import 'package:whatsapp/core/services/time_ago_service.dart';
import 'package:whatsapp/features/chats/presentation/widgets/build_message_status_icon.dart';
import 'package:whatsapp/features/chats/presentation/widgets/show_unread_messages_count.dart';

class CustomChatItem extends StatelessWidget {
  final ChatEntity chat;

  const CustomChatItem({
    super.key,
    required this.chat,
  });

  @override
  Widget build(BuildContext context) {
    final anotherUser = chat.anotherUser;
    final LastMessageEntity? lastMessage = chat.lastMessage;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        Navigator.pushNamed(
          context,
          Routes.chatScreenRoute,
          arguments: chat,
        );
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: BuildUserProfileImage(
              circleAvatarRadius: 25,
              profilePicUrl: anotherUser.profileImage,
            ),
          ),
          const HorizontalGap(12),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Divider(
                  height: 16,
                  color: isLightTheme(context)
                      ? AppColors.dividerLight
                      : AppColors.dividerDark,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      anotherUser.name,
                      style: AppTextStyles.poppinsBold(context, 18),
                    ),
                    if (lastMessage != null)
                      Text(
                        TimeAgoService.getSmartChatTimestamp(
                            lastMessage.createdAt),
                        style:
                            AppTextStyles.poppinsMedium(context, 12).copyWith(
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (chat.lastMessage != null && chat.lastMessage!.isMine)
                      Row(
                        children: [
                          BuildMessageStatusIcon(
                            messageStatus: chat.lastMessage!.messageStatus,
                          ),
                          const HorizontalGap(6),
                        ],
                      ),
                    Expanded(
                      child: SizedBox(
                        height: 38,
                        child: Text(
                          chat.lastMessage?.content ??
                              "tap here to start the conservation..",
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style:
                              AppTextStyles.poppinsMedium(context, 14).copyWith(
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                      ),
                    ),
                    if (chat.unreadCount > 0)
                      Padding(
                        padding: const EdgeInsets.only(left: 6, top: 4),
                        child: ShowUnreadMessagesCounts(
                          unreadCount: chat.unreadCount,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
