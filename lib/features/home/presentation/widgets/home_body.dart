import 'package:flutter/material.dart';
import 'package:whatsapp/features/chats/presentation/widgets/chats_view.dart';

class HomeBody extends StatelessWidget {
  const HomeBody({
    super.key,
    required this.currentViewIndex,
  });

  final int currentViewIndex;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: IndexedStack(
        index: currentViewIndex,
        children: const [
          MyWidget(
            color: Colors.red,
          ),
          ChatsView(),
          MyWidget(
            color: Colors.black,
          ),
          MyWidget(
            color: Colors.amber,
          ),
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
