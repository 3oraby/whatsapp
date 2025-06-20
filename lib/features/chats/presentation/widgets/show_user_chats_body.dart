import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whatsapp/core/utils/app_text_styles.dart';
import 'package:whatsapp/core/widgets/custom_app_padding.dart';
import 'package:whatsapp/core/widgets/custom_empty_state_body.dart';
import 'package:whatsapp/core/widgets/custom_error_body_widget.dart';
import 'package:whatsapp/core/widgets/custom_loading_body_widget.dart';
import 'package:whatsapp/core/widgets/vertical_gap.dart';
import 'package:whatsapp/features/chats/presentation/cubits/get_user_chats_cubit/get_user_chats_cubit.dart';
import 'package:whatsapp/features/chats/presentation/widgets/custom_chat_item.dart';

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
