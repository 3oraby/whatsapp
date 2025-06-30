import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whatsapp/core/services/get_it_service.dart';
import 'package:whatsapp/features/chats/domain/repos/chats_repo.dart';
import 'package:whatsapp/features/chats/presentation/cubits/create_new_chat_cubit/create_new_chat_cubit.dart';
import 'package:whatsapp/features/contacts/domain/repos/contacts_repo.dart';
import 'package:whatsapp/features/contacts/presentation/cubits/create_new_contact_cubit.dart/create_new_contact_cubit.dart';
import 'package:whatsapp/features/contacts/presentation/widgets/add_to_contacts_button.dart';
import 'package:whatsapp/features/contacts/presentation/widgets/start_chat_button.dart';
import 'package:whatsapp/features/user/domain/entities/user_entity.dart';

class ContactInteractionButton extends StatelessWidget {
  const ContactInteractionButton({
    super.key,
    required this.anotherUser,
    required this.isActiveButton,
  });

  final UserEntity anotherUser;

  final bool isActiveButton;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => CreateNewContactCubit(
            contactsRepo: getIt<ContactsRepo>(),
          ),
        ),
        BlocProvider(
          create: (context) => CreateNewChatCubit(
            chatsRepo: getIt<ChatsRepo>(),
          ),
        ),
      ],
      child: ContactInteractionButtonContent(
        anotherUser: anotherUser,
        isActiveButton: isActiveButton,
      ),
    );
  }
}

class ContactInteractionButtonContent extends StatelessWidget {
  const ContactInteractionButtonContent({
    super.key,
    required this.anotherUser,
    required this.isActiveButton,
  });
  final UserEntity anotherUser;
  final bool isActiveButton;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateNewContactCubit, CreateNewContactState>(
      builder: (context, state) {
        if (state is CreateNewContactLoadedState) {
          return StartChatButton(
            anotherUser: anotherUser,
          );
        }
        return isActiveButton
            ? StartChatButton(
                anotherUser: anotherUser,
              )
            : AddToContactsButton(
                userId: anotherUser.id,
              );
      },
    );
  }
}
