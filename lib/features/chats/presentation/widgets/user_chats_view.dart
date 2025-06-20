import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whatsapp/core/services/get_it_service.dart';
import 'package:whatsapp/core/utils/app_colors.dart';
import 'package:whatsapp/core/utils/app_routes.dart';
import 'package:whatsapp/core/utils/app_text_styles.dart';
import 'package:whatsapp/core/widgets/custom_app_padding.dart';
import 'package:whatsapp/core/widgets/custom_empty_state_body.dart';
import 'package:whatsapp/core/widgets/custom_error_body_widget.dart';
import 'package:whatsapp/core/widgets/custom_loading_body_widget.dart';
import 'package:whatsapp/core/widgets/vertical_gap.dart';
import 'package:whatsapp/features/chats/domain/repos/chats_repo.dart';
import 'package:whatsapp/features/chats/domain/repos/socket_repo.dart';
import 'package:whatsapp/features/chats/presentation/cubits/get_user_chats_cubit/get_user_chats_cubit.dart';
import 'package:whatsapp/features/chats/presentation/widgets/custom_chat_item.dart';

class UserChatsView extends StatelessWidget {
  const UserChatsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetUserChatsCubit(
        chatsRepo: getIt<ChatsRepo>(),
        socketRepo: getIt<SocketRepo>(),
      ),
      child: Column(
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
      ),
    );
  }
}

class ShowUserChatsBody extends StatefulWidget {
  const ShowUserChatsBody({super.key});

  @override
  State<ShowUserChatsBody> createState() => _ShowUserChatsBodyState();
}

class _ShowUserChatsBodyState extends State<ShowUserChatsBody> {
  @override
  void initState() {
    super.initState();
    getUserChats();
  }

  getUserChats() {
    context.read<GetUserChatsCubit>().getUserChats();
  }

  @override
  Widget build(BuildContext context) {
    return CustomAppPadding(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Chats",
            style: AppTextStyles.poppinsBold(context, 48),
          ),
          const VerticalGap(8),
          Expanded(
            child: BlocBuilder<GetUserChatsCubit, GetUserChatsState>(
              builder: (context, state) {
                if (state is GetUserChatsLoadingState) {
                  return const CustomLoadingBodyWidget();
                } else if (state is GetUserChatsFailureState) {
                  return CustomErrorBodyWidget(
                    errorMessage: state.message,
                    onRetry: getUserChats,
                  );
                } else if (state is GetUserChatsEmptyState) {
                  return const CustomEmptyStateBody(title: "No chats yet.");
                } else if (state is GetUserChatsLoadedState) {
                  final chats = state.chats;
                  return ListView.builder(
                    padding: EdgeInsets.all(0),
                    itemCount: chats.length,
                    itemBuilder: (context, index) {
                      return CustomChatItem(chat: chats[index]);
                    },
                  );
                }

                return const SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }
}
