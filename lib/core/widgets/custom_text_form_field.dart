import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:whatsapp/core/utils/app_constants.dart';
import 'package:whatsapp/core/utils/app_text_styles.dart';

class CustomTextFormFieldWidget extends StatelessWidget {
  const CustomTextFormFieldWidget({
    super.key,
    this.labelText,
    this.hintText,
    this.onChanged,
    this.onSaved,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.textStyle,
    this.hintStyle,
    this.labelStyle,
    this.inputFormatters,
    this.prefixIcon,
    this.suffixIcon,
    this.helperText,
    this.errorText,
    this.controller,
    this.focusNode,
    this.fillColor,
    this.borderColor,
    this.borderWidth = 0.5,
    this.enabledBorderColor,
    this.borderRadius = AppConstants.borderRadius,
    this.contentPadding = AppConstants.contentTextFieldPadding,
    this.maxLines = 1,
    this.isEnabled = true,
    this.onTap,
    this.autovalidateMode = AutovalidateMode.disabled,
    this.focusedBorderColor,
    this.focusedBorderWidth = 2,
    this.autofocus = false,
    this.textAlign = TextAlign.start,
    this.cursorColor,
    this.cursorHeight,
    this.scrollController,
  });

  final String? labelText;
  final String? hintText;
  final void Function(String)? onChanged;
  final void Function(String?)? onSaved;
  final FormFieldValidator<String>? validator;
  final TextInputType keyboardType;
  final TextStyle? textStyle;
  final TextStyle? hintStyle;
  final TextStyle? labelStyle;
  final List<TextInputFormatter>? inputFormatters;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? helperText;
  final String? errorText;
  final TextEditingController? controller;
  final ScrollController? scrollController;
  final FocusNode? focusNode;
  final Color? fillColor;
  final Color? borderColor;
  final double borderWidth;
  final Color? enabledBorderColor;
  final double borderRadius;
  final double contentPadding;
  final int? maxLines;
  final bool isEnabled;
  final void Function()? onTap;
  final AutovalidateMode autovalidateMode;
  final Color? focusedBorderColor;
  final double focusedBorderWidth;
  final bool autofocus;
  final TextAlign textAlign;
  final double? cursorHeight;
  final Color? cursorColor;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      onChanged: onChanged,
      onSaved: onSaved,
      scrollController: scrollController,
      validator: validator,
      cursorHeight: 90,
      keyboardType: keyboardType,
      style: textStyle ?? AppTextStyles.poppinsBold(context, 16),
      inputFormatters: inputFormatters,
      maxLines: maxLines,
      enabled: isEnabled,
      onTap: onTap,
      autofocus: autofocus,
      textAlign: textAlign,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: labelStyle ?? AppTextStyles.poppinsBold(context, 16),
        hintText: hintText,
        hintStyle: hintStyle ?? AppTextStyles.poppinsBold(context, 16),
        helperText: helperText,
        errorText: errorText,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        contentPadding: EdgeInsets.all(contentPadding),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(
            color: borderColor ??
                Theme.of(context).inputDecorationTheme.border!.borderSide.color,
            width: borderWidth,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(
            color: focusedBorderColor ??
                Theme.of(context)
                    .inputDecorationTheme
                    .focusedBorder!
                    .borderSide
                    .color,
            width: focusedBorderWidth,
          ), // Focused border color
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(
            color: enabledBorderColor ??
                Theme.of(context)
                    .inputDecorationTheme
                    .enabledBorder!
                    .borderSide
                    .color,
            width: borderWidth,
          ),
        ),
        filled: true,
        fillColor: fillColor,
      ),
    );
  }
}
