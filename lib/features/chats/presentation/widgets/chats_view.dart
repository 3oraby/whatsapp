import 'package:flutter/material.dart';
import 'package:whatsapp/core/utils/app_colors.dart';
import 'package:whatsapp/core/utils/app_routes.dart';
import 'package:whatsapp/core/utils/app_text_styles.dart';
import 'package:whatsapp/core/widgets/build_user_profile_image.dart';
import 'package:whatsapp/core/widgets/custom_app_padding.dart';
import 'package:whatsapp/features/chats/data/models/chat_model.dart';

class ChatsView extends StatelessWidget {
  const ChatsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppBar(
          actions: [
            IconButton(
              icon: Icon(
                Icons.person_add_alt_1_rounded,
                color: Theme.of(context).iconTheme.color,
                size: 30,
              ),
              onPressed: () {
                Navigator.pushNamed(context, Routes.addNewContactsRoute);
              },
            ),
            IconButton(
              icon: Icon(
                Icons.add_circle,
                color: AppColors.primary,
                size: 36,
              ),
              onPressed: () {},
            ),
          ],
        ),
        const Expanded(
          child: ShowUserChatsBody(),
        )
      ],
    );
  }
}

class ShowUserChatsBody extends StatelessWidget {
  const ShowUserChatsBody({super.key});

  @override
  Widget build(BuildContext context) {
    // مثال داتا مؤقتة من ChatModel الحقيقي
    final List<ChatModel> chats = [
      ChatModel(
        id: 1,
        type: 'chat',
        anotherUser: ChatUser(
          id: 101,
          name: 'Messi',
          profileImage: null,
          chatMetadata: UserChatMetadata(
            isPinned: false,
            isFavorite: false,
            pinnedAt: null,
          ),
        ),
        isPinned: false,
        pinnedAt: null,
        lastMessageCreatedAt:
            DateTime.now().subtract(const Duration(minutes: 5)),
      ),
      ChatModel(
        id: 2,
        type: 'chat',
        anotherUser: ChatUser(
          id: 102,
          name: 'Cristiano',
          profileImage: null,
          chatMetadata: UserChatMetadata(
            isPinned: false,
            isFavorite: false,
            pinnedAt: null,
          ),
        ),
        isPinned: false,
        pinnedAt: null,
        lastMessageCreatedAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
    ];

    return CustomAppPadding(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Chats",
            style: AppTextStyles.poppinsBold(context, 48),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: chats.length,
              itemBuilder: (context, index) {
                final chat = chats[index];
                return ChatItem(chat: chat);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ChatItem extends StatelessWidget {
  final ChatModel chat;

  const ChatItem({super.key, required this.chat});

  @override
  Widget build(BuildContext context) {
    final anotherUser = chat.anotherUser;
    final lastTime = chat.lastMessageCreatedAt;

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
