import 'package:flutter/material.dart';
import 'package:whatsapp/core/utils/app_colors.dart';
import 'package:whatsapp/core/utils/app_routes.dart';
import 'package:whatsapp/core/utils/app_text_styles.dart';
import 'package:whatsapp/core/widgets/build_user_profile_image.dart';
import 'package:whatsapp/features/chats/domain/entities/chat_entity.dart';
import 'package:whatsapp/features/chats/domain/entities/last_message_entity.dart';
import 'package:whatsapp/core/services/time_ago_service.dart';

class CustomChatItem extends StatelessWidget {
  final ChatEntity chat;

  const CustomChatItem({
    super.key,
    required this.chat,
  });

  @override
  Widget build(BuildContext context) {
    final anotherUser = chat.anotherUser;
    final LastMessageEntity lastMessage = chat.lastMessage;

    return ListTile(
      contentPadding: EdgeInsets.zero,
      onTap: () {
        Navigator.pushNamed(
          context,
          Routes.chatScreenRoute,
          arguments: chat,
        );
      },
      leading: BuildUserProfileImage(
        circleAvatarRadius: 25,
        profilePicUrl: anotherUser.profileImage,
      ),
      title: Text(
        anotherUser.name,
        style: AppTextStyles.poppinsBold(context, 16),
      ),
      subtitle: Text(
        lastMessage.content,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: AppTextStyles.poppinsMedium(context, 14).copyWith(
          color: Theme.of(context).colorScheme.secondary,
        ),
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            TimeAgoService.getSmartChatTimestamp(lastMessage.createdAt),
            style: AppTextStyles.poppinsMedium(context, 12).copyWith(
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
          if (chat.unreadCount > 0)
            Container(
              margin: const EdgeInsets.only(top: 6),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${chat.unreadCount}',
                style: AppTextStyles.poppinsMedium(context, 12).copyWith(
                  color: Colors.white,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
