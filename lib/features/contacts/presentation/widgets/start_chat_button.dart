import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whatsapp/core/helpers/show_custom_snack_bar.dart';
import 'package:whatsapp/core/utils/app_colors.dart';
import 'package:whatsapp/core/utils/app_routes.dart';
import 'package:whatsapp/core/utils/app_text_styles.dart';
import 'package:whatsapp/core/widgets/custom_action_box.dart';
import 'package:whatsapp/core/widgets/custom_loading_indicator.dart';
import 'package:whatsapp/features/chats/presentation/cubits/create_new_chat_cubit/create_new_chat_cubit.dart';
import 'package:whatsapp/features/chats/presentation/cubits/message_stream_cubit/message_stream_cubit.dart';
import 'package:whatsapp/features/chats/presentation/routes/chat_screen_args.dart';
import 'package:whatsapp/features/user/domain/entities/user_entity.dart';

class StartChatButton extends StatelessWidget {
  const StartChatButton({
    super.key,
    required this.anotherUser,
  });

  final UserEntity anotherUser;
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CreateNewChatCubit, CreateNewChatState>(
      listener: (context, state) {
        if (state is CreateNewChatFailureState) {
          showCustomSnackBar(context, state.message);
        } else if (state is CreateNewChatLoadedState) {
          Navigator.pushNamed(
            context,
            Routes.chatScreenRoute,
            arguments: ChatScreenArgs(
              chat: state.chat,
              messageStreamCubit: BlocProvider.of<MessageStreamCubit>(context),
            ),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is CreateNewChatLoadingState;

        return CustomActionBox(
          width: 95,
          height: 40,
          internalVerticalPadding: 0,
          internalHorizontalPadding: 0,
          backgroundColor: AppColors.primary,
          onPressed: isLoading
              ? null
              : () =>
                  BlocProvider.of<CreateNewChatCubit>(context).createNewChat(
                    anotherUser: anotherUser,
                  ),
          child: Center(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Row(
                spacing: 8,
                children: [
                  if (isLoading)
                    SizedBox(
                      height: 22,
                      width: 22,
                      child: CustomLoadingIndicator(),
                    )
                  else
                    Icon(
                      Icons.chat_bubble,
                      color: Colors.white,
                      size: 22,
                    ),
                  Text(
                    context.tr("Chat"),
                    style: AppTextStyles.poppinsBold(context, 14).copyWith(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
