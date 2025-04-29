import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:whatsapp/core/utils/app_svgs.dart';

class ChatView extends StatelessWidget {
  const ChatView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppBar(
          actions: [
            IconButton(
              icon: Icon(Icons.person_add_alt_1_rounded),
              onPressed: () {},
            ),
          ],
        ),
        SvgPicture.asset(
          AppSvgs.svgsChatsIcon,
          height: 200,
          colorFilter: ColorFilter.mode(
            // Theme.of(context).iconTheme.color!,
            Colors.red,
            BlendMode.srcIn,
          ),
        )
      ],
    );
  }
}
