import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_lazy_indexed_stack/flutter_lazy_indexed_stack.dart';
import 'package:whatsapp/core/helpers/pending_messages/pending_message_helper.dart';
import 'package:whatsapp/core/services/get_it_service.dart';
import 'package:whatsapp/features/chats/domain/repos/chats_repo.dart';
import 'package:whatsapp/features/chats/domain/repos/socket_repo.dart';
import 'package:whatsapp/features/chats/presentation/cubits/get_user_chats_cubit/get_user_chats_cubit.dart';
import 'package:whatsapp/features/chats/presentation/cubits/message_stream_cubit/message_stream_cubit.dart';
import 'package:whatsapp/features/chats/presentation/widgets/user_chats_view.dart';
import 'package:whatsapp/features/contacts/presentation/widgets/user_contacts_view.dart';
import 'package:whatsapp/features/settings/presentation/widgets/settings_view.dart';
import 'package:whatsapp/features/stories/presentation/widgets/stories_view.dart';

class HomeBody extends StatelessWidget {
  const HomeBody({
    super.key,
    required this.currentViewIndex,
  });

  final int currentViewIndex;
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => GetUserChatsCubit(
            chatsRepo: getIt<ChatsRepo>(),
          ),
        ),
        BlocProvider(
          create: (context) => MessageStreamCubit(
            socketRepo: getIt<SocketRepo>(),
            pendingMessagesHelper: getIt<PendingMessagesHelper>(),
          ),
        )
      ],
      child: LazyIndexedStack(
        index: currentViewIndex,
        children: const [
          StoriesView(),
          UserChatsView(),
          MyWidget(
            color: Colors.green,
          ),
          UserContactsView(),
          SettingsView(),
        ],
      ),
    );
  }
}

class MyWidget extends StatelessWidget {
  const MyWidget({super.key, required this.color});
  final Color color;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 100,
        width: 300,
        color: color,
        child: Center(
          child: Text(
            "data",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
