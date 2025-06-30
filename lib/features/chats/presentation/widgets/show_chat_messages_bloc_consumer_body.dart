import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whatsapp/core/widgets/custom_error_body_widget.dart';
import 'package:whatsapp/core/widgets/custom_loading_body_widget.dart';
import 'package:whatsapp/features/chats/domain/entities/chat_entity.dart';
import 'package:whatsapp/features/chats/presentation/cubits/get_chat_messages_cubit/get_chat_messages_cubit.dart';
import 'package:whatsapp/features/chats/presentation/cubits/message_stream_cubit/message_stream_cubit.dart';
import 'package:whatsapp/features/chats/presentation/widgets/show_chat_messages_body.dart';

class ShowChatMessagesBlocConsumerBody extends StatefulWidget {
  const ShowChatMessagesBlocConsumerBody({
    super.key,
    required this.chat,
  });

  final ChatEntity chat;

  @override
  State<ShowChatMessagesBlocConsumerBody> createState() =>
      _ShowChatMessagesBlocConsumerBodyState();
}

class _ShowChatMessagesBlocConsumerBodyState
    extends State<ShowChatMessagesBlocConsumerBody> {
  @override
  void initState() {
    super.initState();
    _loadInitialChatMessages();

    context.read<MessageStreamCubit>().markChatAsRead();
  }

  _loadInitialChatMessages() {
    context.read<GetChatMessagesCubit>().getChatMessages(
          chatId: widget.chat.id,
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetChatMessagesCubit, GetChatMessagesState>(
      builder: (context, state) {
        if (state is GetChatMessagesLoadingState) {
          return const CustomLoadingBodyWidget();
        } else if (state is GetChatMessagesFailureState) {
          return CustomErrorBodyWidget(
            errorMessage: state.message,
            onRetry: _loadInitialChatMessages,
          );
        } else if (state is GetChatMessagesLoadedState) {
          return ShowChatMessagesBody(
            messages: state.messages,
            chat: widget.chat,
          );
        }
    
        return const SizedBox();
      },
    );
  }
}
