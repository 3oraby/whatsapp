import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whatsapp/core/helpers/is_light_theme.dart';
import 'package:whatsapp/core/utils/app_colors.dart';
import 'package:whatsapp/core/utils/app_text_styles.dart';
import 'package:whatsapp/core/widgets/custom_action_box.dart';
import 'package:whatsapp/core/widgets/custom_loading_indicator.dart';
import 'package:whatsapp/features/contacts/presentation/cubits/create_new_contact_cubit.dart/create_new_contact_cubit.dart';

class AddToContactsButton extends StatelessWidget {
  const AddToContactsButton({
    super.key,
    required this.userId,
  });
  final int userId;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateNewContactCubit, CreateNewContactState>(
      builder: (context, state) {
        final isLoading = state is CreateNewContactLoadingState;

        return CustomActionBox(
          width: 95,
          height: 40,
          internalVerticalPadding: 0,
          internalHorizontalPadding: 0,
          borderWidth: 0,
          backgroundColor: isLightTheme(context)
              ? AppColors.highlightBackgroundColor
              : AppColors.highlightBackgroundColorDark,
          onPressed: isLoading
              ? null
              : () => context
                  .read<CreateNewContactCubit>()
                  .createNewContact(userId: userId),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (isLoading)
                  SizedBox(
                    height: 22,
                    width: 22,
                    child: CustomLoadingIndicator(),
                  )
                else
                  Icon(Icons.person_add, size: 22),
                const SizedBox(width: 8),
                Text(
                  context.tr("Add"),
                  style: AppTextStyles.poppinsBold(context, 14),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
