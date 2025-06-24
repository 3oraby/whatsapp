import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whatsapp/core/services/get_it_service.dart';
import 'package:whatsapp/core/utils/app_images.dart';
import 'package:whatsapp/core/utils/app_text_styles.dart';
import 'package:whatsapp/core/widgets/build_user_profile_image.dart';
import 'package:whatsapp/core/widgets/horizontal_gap.dart';
import 'package:whatsapp/features/chats/domain/entities/chat_entity.dart';
import 'package:whatsapp/features/chats/domain/repos/chats_repo.dart';
import 'package:whatsapp/features/chats/domain/repos/socket_repo.dart';
import 'package:whatsapp/features/chats/presentation/cubits/get_chat_messages_cubit/get_chat_messages_cubit.dart';
import 'package:whatsapp/features/chats/presentation/cubits/message_stream_cubit/message_stream_cubit.dart';
import 'package:whatsapp/features/chats/presentation/widgets/show_chat_messages_bloc_consumer_body.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({
    super.key,
    required this.chat,
  });

  final ChatEntity chat;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => GetChatMessagesCubit(
              chatsRepo: getIt<ChatsRepo>(),
            ),
          ),
          BlocProvider(
            create: (context) => MessageStreamCubit(
              socketRepo: getIt<SocketRepo>(),
              chatId: chat.id
            ),
          ),
        ],
        child: Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            leading: const BackButton(color: Colors.white),
            title: Row(
              children: [
                BuildUserProfileImage(
                  profilePicUrl: chat.anotherUser.profileImage,
                  circleAvatarRadius: 16,
                ),
                const HorizontalGap(10),
                Text(
                  chat.anotherUser.name,
                  style: AppTextStyles.poppinsMedium(context, 18).copyWith(
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          body: Stack(
            children: [
              Positioned.fill(
                child: Image.asset(
                  AppImages.imagesWhatsappWallpaper8,
                  fit: BoxFit.cover,
                  filterQuality: FilterQuality.low,
                ),
              ),
              SafeArea(
                top: true,
                bottom: false,
                child: ShowChatMessagesBlocConsumerBody(chat: chat),
              ),
            ],
          ),
        ));
  }
}
