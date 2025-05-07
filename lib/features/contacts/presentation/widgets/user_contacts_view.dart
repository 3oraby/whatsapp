import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whatsapp/core/services/get_it_service.dart';
import 'package:whatsapp/core/utils/app_text_styles.dart';
import 'package:whatsapp/features/contacts/domain/repos/contacts_repo.dart';
import 'package:whatsapp/features/contacts/presentation/cubits/get_user_contacts_cubit/get_user_contacts_cubit.dart';
import 'package:whatsapp/features/contacts/presentation/widgets/get_user_contacts_body.dart';

class UserContactsView extends StatelessWidget {
  const UserContactsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetUserContactsCubit(
        contactsRepo: getIt<ContactsRepo>(),
      ),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            "My Friends",
            style: AppTextStyles.poppinsBold(context, 22),
          ),
        ),
        body: GetUserContactsBody(),
      ),
    );
  }
}
