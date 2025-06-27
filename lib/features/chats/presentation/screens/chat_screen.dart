import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whatsapp/core/services/get_it_service.dart';
import 'package:whatsapp/core/services/time_ago_service.dart';
import 'package:whatsapp/core/utils/app_colors.dart';
import 'package:whatsapp/core/utils/app_images.dart';
import 'package:whatsapp/core/utils/app_text_styles.dart';
import 'package:whatsapp/core/widgets/build_user_profile_image.dart';
import 'package:whatsapp/core/widgets/horizontal_gap.dart';
import 'package:whatsapp/core/widgets/vertical_gap.dart';
import 'package:whatsapp/features/chats/domain/entities/chat_entity.dart';
import 'package:whatsapp/features/chats/domain/repos/chats_repo.dart';
import 'package:whatsapp/features/chats/domain/repos/socket_repo.dart';
import 'package:whatsapp/features/chats/presentation/cubits/chat_friend_status_cubit/chat_friend_status_cubit.dart';
import 'package:whatsapp/features/chats/presentation/cubits/get_chat_messages_cubit/get_chat_messages_cubit.dart';
import 'package:whatsapp/features/chats/presentation/cubits/message_stream_cubit/message_stream_cubit.dart';
import 'package:whatsapp/features/chats/presentation/widgets/show_chat_messages_bloc_consumer_body.dart';
import 'package:whatsapp/features/user/domain/repos/user_repo.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({
    super.key,
    required this.chat,
  });

  final ChatEntity chat;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late ChatFriendStatusCubit chatFriendStatusCubit;

  @override
  void initState() {
    super.initState();
    chatFriendStatusCubit = ChatFriendStatusCubit(
      currentChatUserId: widget.chat.anotherUser.id,
      socketRepo: getIt<SocketRepo>(),
      userRepo: getIt<UserRepo>(),
    );
  }

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
              chatId: widget.chat.id,
            ),
          ),
          BlocProvider(
            create: (context) => chatFriendStatusCubit,
          )
        ],
        child: BlocBuilder<ChatFriendStatusCubit, ChatFriendStatusState>(
          builder: (context, state) => Scaffold(
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              backgroundColor: AppColors.lightChatAppBarColor,
              leading: const BackButton(),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      BuildUserProfileImage(
                        profilePicUrl: widget.chat.anotherUser.profileImage,
                        circleAvatarRadius: 16,
                      ),
                      const HorizontalGap(10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.chat.anotherUser.name,
                            style: AppTextStyles.poppinsMedium(context, 18),
                          ),
                          const VerticalGap(2),
                          if (state is ChatFriendStatusUpdated)
                            Text(
                              state.isOnline
                                  ? 'Online'
                                  : 'Last seen ${TimeAgoService.getTimeAgo(state.lastSeen)}',
                              style: AppTextStyles.poppinsRegular(context, 12)
                                  .copyWith(
                                color: Theme.of(context).colorScheme.secondary,
                                fontSize: 13,
                              ),
                            ),
                        ],
                      ),
                    ],
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
                  child: ShowChatMessagesBlocConsumerBody(chat: widget.chat),
                ),
              ],
            ),
          ),
        ));
  }
}
