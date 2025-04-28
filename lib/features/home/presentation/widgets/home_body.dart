import 'package:flutter/material.dart';

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
          // HomeView(),
          // MainAppSearchView(),
          // NotificationView(),
          // SettingView(),
          MyWidget(
            color: Colors.red,
          ),
          MyWidget(
            color: Colors.black,
          ),
          MyWidget(
            color: Colors.amber,
          ),
          MyWidget(
            color: Colors.green,
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
    return Container(
      height: 100,
      width: 300,
      color: color,
    );
  }
}
