import 'package:flutter/material.dart';
import 'package:whatsapp/core/utils/app_colors.dart';
import 'package:whatsapp/core/utils/app_routes.dart';
import 'package:whatsapp/core/utils/app_text_styles.dart';
import 'package:whatsapp/core/widgets/custom_app_padding.dart';

class ChatsView extends StatelessWidget {
  const ChatsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
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
        Expanded(
          child: ShowUserChatsBody(),
        )
      ],
    );
  }
}

class ShowUserChatsBody extends StatelessWidget {
  const ShowUserChatsBody({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: CustomAppPadding(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Chats",
              style: AppTextStyles.poppinsBold(context, 48),
            ),
            Container(
              height: 100,
              color: Colors.red,
            ),
            Container(
              height: 100,
              color: Colors.amber,
            ),
            Container(
              height: 100,
              color: Colors.red,
            ),
            Container(
              height: 100,
              color: Colors.amber,
            ),
            Container(
              height: 100,
              color: Colors.red,
            ),
            Container(
              height: 100,
              color: Colors.amber,
            ),
            Container(
              height: 100,
              color: Colors.red,
            ),
            Container(
              height: 100,
              color: Colors.amber,
            ),
            Container(
              height: 100,
              color: Colors.red,
            ),
            Container(
              height: 100,
              color: Colors.amber,
            ),
            Container(
              height: 100,
              color: Colors.red,
            ),
            Container(
              height: 100,
              color: Colors.amber,
            ),
          ],
        ),
      ),
    );
  }
}
