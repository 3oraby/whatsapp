import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whatsapp/core/utils/app_routes.dart';
import 'package:whatsapp/core/utils/app_text_styles.dart';
import 'package:whatsapp/core/widgets/custom_app_padding.dart';
import 'package:whatsapp/core/widgets/custom_empty_state_body.dart';
import 'package:whatsapp/core/widgets/custom_error_body_widget.dart';
import 'package:whatsapp/core/widgets/custom_loading_body_widget.dart';
import 'package:whatsapp/core/widgets/vertical_gap.dart';
import 'package:whatsapp/features/chats/presentation/cubits/get_user_chats_cubit/get_user_chats_cubit.dart';
import 'package:whatsapp/features/chats/presentation/cubits/message_stream_cubit/message_stream_cubit.dart';
import 'package:whatsapp/features/chats/presentation/widgets/show_user_chats_list.dart';

class ShowUserChatsBody extends StatefulWidget {
  const ShowUserChatsBody({super.key});

  @override
  State<ShowUserChatsBody> createState() => _ShowUserChatsBodyState();
}

class _ShowUserChatsBodyState extends State<ShowUserChatsBody> {
  late GetUserChatsCubit getUserChatsCubit;

  @override
  void initState() {
    super.initState();
    getUserChatsCubit = context.read<GetUserChatsCubit>();
    getUserChats();
  }

  getUserChats() {
    context.read<GetUserChatsCubit>().getUserChats();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<MessageStreamCubit, MessageStreamState>(
      listener: (context, state) {
        if (state is NewIncomingMessageState) {
          getUserChatsCubit.updateChatListOnNewMessage(state.message);
        } else if (state is NewOutgoingMessageState) {
          getUserChatsCubit.updateChatListOnNewMessage(state.message);
        } else if (state is UpdateMessageStatusState) {
          getUserChatsCubit.updateLastMessageStatus(
            chatId: state.chatId,
            messageId: state.newId,
            newStatus: state.newStatus,
          );
        } else if (state is AllMessagesReadState) {
          getUserChatsCubit.updateLastMessageAsSeen(chatId: state.chatId);
        } else if (state is EditMessageState) {
          getUserChatsCubit.updateLastMessageOnEditMessage(
            messageId: state.messageId,
            newContent: state.newContent,
          );
        } else if (state is MessageEditedSuccessfullyState) {
          getUserChatsCubit.updateLastMessageOnEditMessage(
            messageId: state.messageId,
            newContent: state.newContent,
          );
        } else if (state is DeleteMessageState ||
            state is MessageDeletedSuccessfullyState) {
          getUserChatsCubit.updateLastMessageOnDeleteMessage(
            messageId: state is DeleteMessageState
                ? state.messageId
                : (state as MessageDeletedSuccessfullyState).messageId,
          );
        }
      },
      child: CustomAppPadding(
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
                    return CustomEmptyStateBody(
                      title: "No chats yet.",
                      subtitle:
                          "You haven't started any conversations yet. Start chatting now!",
                      actionButtonTitle: "Add new friends",
                      onActionPressed: () async {
                        Navigator.pushNamed(
                          context,
                          Routes.addNewContactsRoute,
                        ).then(
                          (value) {
                            getUserChats();
                          },
                        );
                      },
                    );
                  } else if (state is GetUserChatsLoadedState) {
                    final chats = state.chats;
                    return ShowUserChatsList(chats: chats);
                  }

                  return const SizedBox();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
