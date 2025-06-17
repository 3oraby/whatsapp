import 'package:flutter/material.dart';
import 'package:flutter_lazy_indexed_stack/flutter_lazy_indexed_stack.dart';
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
    return LazyIndexedStack(
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
