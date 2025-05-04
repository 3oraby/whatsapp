import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whatsapp/core/services/get_it_service.dart';
import 'package:whatsapp/core/utils/app_text_styles.dart';
import 'package:whatsapp/core/widgets/build_user_profile_image.dart';
import 'package:whatsapp/core/widgets/custom_add_new_contact_button.dart';
import 'package:whatsapp/core/widgets/custom_chat_button.dart';
import 'package:whatsapp/features/contacts/domain/repos/contacts_repo.dart';
import 'package:whatsapp/features/contacts/presentation/cubits/create_new_contact_cubit.dart/create_new_contact_cubit.dart';
import 'package:whatsapp/features/user/domain/user_entity.dart';

class CustomUserInfoCard extends StatelessWidget {
  const CustomUserInfoCard({
    super.key,
    required this.user,
    required this.currentUserId,
    this.isActiveButton = false,
  });

  final UserEntity user;
  final int currentUserId;
  final bool isActiveButton;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigator.pushNamed(
        //   context,
        //   UserProfileScreen.routeId,
        //   arguments: user,
        // );
      },
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        isThreeLine: user.description != null,
        leading: BuildUserProfileImage(
          profilePicUrl: user.profileImage,
        ),
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.name,
                    style: AppTextStyles.poppinsExtraBold(context, 18),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    user.email,
                    style: AppTextStyles.poppinsBold(context, 14).copyWith(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Visibility(
              visible: user.id != currentUserId,
              child: isActiveButton
                  ? CustomChatButton()
                  : CustomAddNewContactButton(
                      userId: user.id,
                    ),
            ),
          ],
        ),
        subtitle: user.description != null
            ? Text(
                user.description!,
                style: AppTextStyles.poppinsMedium(context, 14).copyWith(
                  color: Theme.of(context).colorScheme.secondary,
                ),
              )
            : null,
      ),
    );
  }
}

class UserInteractionButton extends StatefulWidget {
  const UserInteractionButton({
    super.key,
    required this.userId,
    required this.isActiveButton,
  });

  final int userId;
  final bool isActiveButton;

  @override
  State<UserInteractionButton> createState() => _UserInteractionButtonState();
}

class _UserInteractionButtonState extends State<UserInteractionButton> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CreateNewContactCubit(
        contactsRepo: getIt<ContactsRepo>(),
      ),
      child: widget.isActiveButton 
          ? CustomChatButton()
          : CustomAddNewContactButton(
              userId: widget.userId,
            ),
    );
  }
}
