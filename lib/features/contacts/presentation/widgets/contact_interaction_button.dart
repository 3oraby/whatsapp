import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whatsapp/core/services/get_it_service.dart';
import 'package:whatsapp/features/contacts/domain/repos/contacts_repo.dart';
import 'package:whatsapp/features/contacts/presentation/cubits/create_new_contact_cubit.dart/create_new_contact_cubit.dart';
import 'package:whatsapp/features/contacts/presentation/widgets/add_to_contacts_button.dart';
import 'package:whatsapp/features/contacts/presentation/widgets/start_chat_button.dart';

class ContactInteractionButton extends StatelessWidget {
  const ContactInteractionButton({
    super.key,
    required this.userId,
    required this.isActiveButton,
  });

  final int userId;
  final bool isActiveButton;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CreateNewContactCubit(
        contactsRepo: getIt<ContactsRepo>(),
      ),
      child: ContactInteractionButtonContent(
        userId: userId,
        isActiveButton: isActiveButton,
      ),
    );
  }
}

class ContactInteractionButtonContent extends StatelessWidget {
  const ContactInteractionButtonContent({
    super.key,
    required this.userId,
    required this.isActiveButton,
  });
  final int userId;
  final bool isActiveButton;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateNewContactCubit, CreateNewContactState>(
      builder: (context, state) {
        if (state is CreateNewContactLoadedState) {
          return StartChatButton();
        }
        return isActiveButton
            ? StartChatButton()
            : AddToContactsButton(
                userId: userId,
              );
      },
    );
  }
}
