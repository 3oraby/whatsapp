import 'package:flutter/material.dart';
import 'package:whatsapp/core/utils/app_text_styles.dart';
import 'package:whatsapp/features/contacts/presentation/widgets/get_user_contacts_body.dart';

class UserContactsView extends StatelessWidget {
  const UserContactsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "My Friends",
          style: AppTextStyles.poppinsBold(context, 22),
        ),
      ),
      body: GetUserContactsBody(),
    );
  }
}
