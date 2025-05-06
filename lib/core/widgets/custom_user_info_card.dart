import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whatsapp/core/helpers/is_light_theme.dart';
import 'package:whatsapp/core/services/get_it_service.dart';
import 'package:whatsapp/core/utils/app_colors.dart';
import 'package:whatsapp/core/utils/app_text_styles.dart';
import 'package:whatsapp/core/widgets/build_user_profile_image.dart';
import 'package:whatsapp/core/widgets/custom_action_box.dart';
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
              child: UserInteractionButton(
                userId: user.id,
                isActiveButton: isActiveButton,
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

class UserInteractionButton extends StatelessWidget {
  const UserInteractionButton({
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
      child: UserInteractionButtonBlocConsumerBody(
        userId: userId,
        isActiveButton: isActiveButton,
      ),
    );
  }
}

class UserInteractionButtonBlocConsumerBody extends StatefulWidget {
  const UserInteractionButtonBlocConsumerBody({
    super.key,
    required this.userId,
    required this.isActiveButton,
  });
  final int userId;
  final bool isActiveButton;

  @override
  State<UserInteractionButtonBlocConsumerBody> createState() =>
      _UserInteractionButtonBlocConsumerBodyState();
}

class _UserInteractionButtonBlocConsumerBodyState
    extends State<UserInteractionButtonBlocConsumerBody> {
  late bool isActiveButton;
  @override
  void initState() {
    super.initState();
    isActiveButton = widget.isActiveButton;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CreateNewContactCubit, CreateNewContactState>(
      listener: (context, state) {},
      builder: (context, state) {
        if (state is CreateNewContactLoadedState) {
          return CustomChatButton();
        }
        return isActiveButton
            ? CustomChatButton()
            : CustomAddNewContactButton(
                userId: widget.userId,
              );
      },
    );
  }
}

class CustomAddNewContactButton extends StatelessWidget {
  const CustomAddNewContactButton({
    super.key,
    required this.userId,
  });

  final int userId;
  @override
  Widget build(BuildContext context) {
    return CustomActionBox(
      width: 95,
      height: 40,
      internalVerticalPadding: 0,
      internalHorizontalPadding: 0,
      borderWidth: 0,
      backgroundColor: isLightTheme(context)
          ? AppColors.highlightBackgroundColor
          : AppColors.highlightBackgroundColorDark,
      onPressed: () {
        BlocProvider.of<CreateNewContactCubit>(context)
            .createNewContact(userId: userId);
      },
      child: Center(
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Row(
            spacing: 8,
            children: [
              Icon(Icons.person_add),
              Text(
                context.tr("Add"),
                style: AppTextStyles.poppinsBold(context, 14),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomChatButton extends StatelessWidget {
  const CustomChatButton({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomActionBox(
      width: 95,
      height: 40,
      internalVerticalPadding: 0,
      internalHorizontalPadding: 0,
      backgroundColor: AppColors.primary,
      onPressed: () {
        // navigate to chat screen and make new chat
      },
      child: Center(
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Row(
            spacing: 8,
            children: [
              Icon(
                Icons.chat_bubble,
                color: Colors.white,
              ),
              Text(
                context.tr("Chat"),
                style: AppTextStyles.poppinsBold(context, 14).copyWith(
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
