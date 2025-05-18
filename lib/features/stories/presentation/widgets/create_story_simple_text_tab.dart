import 'package:flutter/material.dart';
import 'package:whatsapp/core/utils/app_constants.dart';
import 'package:whatsapp/core/utils/app_text_styles.dart';
import 'package:whatsapp/core/widgets/custom_text_form_field.dart';

class CreateStorySimpleTextTab extends StatelessWidget {
  const CreateStorySimpleTextTab({
    super.key,
    required this.scrollController,
    required this.textEditingController,
  });

  final ScrollController scrollController;
  final TextEditingController textEditingController;

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      controller: scrollController,
      thumbVisibility: true,
      trackVisibility: true,
      interactive: true,
      child: Center(
        child: CustomTextFormFieldWidget(
          contentPadding: AppConstants.horizontalPadding,
          controller: textEditingController,
          scrollController: scrollController,
          fillColor: Colors.transparent,
          borderWidth: 0,
          borderColor: Colors.transparent,
          focusedBorderColor: Colors.transparent,
          enabledBorderColor: Colors.transparent,
          maxLines: null,
          hintText: "Type a status",
          hintStyle: AppTextStyles.poppinsMedium(context, 32)
              .copyWith(color: Colors.grey[300]),
          textAlign: TextAlign.center,
          cursorHeight: 90,
          cursorColor: Colors.white,
          textStyle: AppTextStyles.poppinsMedium(context, 30)
              .copyWith(color: Colors.white),
        ),
      ),
    );
  }
}
