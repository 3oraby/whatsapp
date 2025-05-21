import 'package:flutter/material.dart';
import 'package:whatsapp/core/utils/app_colors.dart';
import 'package:whatsapp/core/utils/app_text_styles.dart';
import 'package:whatsapp/core/widgets/custom_text_form_field.dart';

class CustomScrollableTextField extends StatelessWidget {
  const CustomScrollableTextField({
    super.key,
    required this.textFieldScrollController,
    required this.textController,
    this.borderWidth = 1,
    this.fillColor = Colors.black54,
    this.hintText,
    this.borderRadius = 40,
  });

  final ScrollController textFieldScrollController;
  final TextEditingController textController;
  final String? hintText;
  final Color? fillColor;
  final double borderWidth;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        maxHeight: 120,
      ),
      child: SingleChildScrollView(
        controller: textFieldScrollController,
        scrollDirection: Axis.vertical,
        reverse: true,
        child: CustomTextFormFieldWidget(
          controller: textController,
          maxLines: null,
          textStyle: AppTextStyles.poppinsMedium(context, 18).copyWith(
            color: Colors.white,
          ),
          fillColor: fillColor,
          contentPadding: 16,
          hintText: hintText,
          hintStyle: AppTextStyles.poppinsMedium(context, 18).copyWith(
            color: AppColors.textSecondaryDark,
          ),
          borderColor: borderWidth == 0 ? Colors.transparent : Colors.grey,
          borderRadius: borderRadius,
          borderWidth: borderWidth,
        ),
      ),
    );
  }
}
