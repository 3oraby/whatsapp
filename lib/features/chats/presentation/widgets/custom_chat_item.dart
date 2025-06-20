
import 'package:flutter/material.dart';
import 'package:whatsapp/core/utils/app_routes.dart';
import 'package:whatsapp/core/utils/app_text_styles.dart';
import 'package:whatsapp/core/widgets/build_user_profile_image.dart';
import 'package:whatsapp/features/chats/domain/entities/chat_entity.dart';

class CustomChatItem extends StatelessWidget {
  final ChatEntity chat;

  const CustomChatItem({super.key, required this.chat});

  @override
  Widget build(BuildContext context) {
    final anotherUser = chat.anotherUser;
    final lastTime = chat.lastMessage.createdAt;

    return ListTile(
      contentPadding: EdgeInsets.zero,
      onTap: () {
        Navigator.pushNamed(
          context,
          Routes.chatScreenRoute,
          arguments: chat, // أو ابعت الموديل كله حسب ما تحب
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
      subtitle: const Text(
        'No messages yet', // تقدر تجيب آخر رسالة من الرسائل لو هتجيلك
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            _formatTime(lastTime),
            style: const TextStyle(color: Colors.grey, fontSize: 12),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime? time) {
    if (time == null) return '';
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inDays >= 1) {
      return '${time.day}/${time.month}';
    } else {
      return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
    }
  }
}
