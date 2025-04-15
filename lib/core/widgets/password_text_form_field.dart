import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp/core/utils/app_colors.dart';
import 'package:whatsapp/core/utils/app_constants.dart';
import 'package:whatsapp/core/utils/app_text_styles.dart';
class PasswordTextFieldWidget extends StatefulWidget {
  const PasswordTextFieldWidget({
    super.key,
    this.labelText,
    this.hintText,
    this.onChanged,
    this.onSaved,
    this.validator,
    this.controller,
    this.focusNode,
    this.fillColor = AppColors.lightBackgroundColor,
    this.borderColor = AppColors.lightBackgroundColor,
    this.borderWidth = 0.5,
    this.enabledBorderColor = AppColors.lightBackgroundColor,
    this.borderRadius = AppConstants.borderRadius,
    this.contentPadding = AppConstants.contentTextFieldPadding,
    this.autovalidateMode = AutovalidateMode.disabled,
    this.focusedBorderColor = AppColors.primaryColor,
    this.focusedBorderWidth = 2,
    this.textStyle,
    this.hintTextStyle,
    this.keyboardType = TextInputType.text,
  });

  final String? labelText;
  final String? hintText;
  final void Function(String)? onChanged;
  final void Function(String?)? onSaved;
  final FormFieldValidator<String>? validator;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final Color fillColor;
  final Color borderColor;
  final double borderWidth;
  final Color enabledBorderColor;
  final double borderRadius;
  final double contentPadding;
  final AutovalidateMode autovalidateMode;
  final Color focusedBorderColor;
  final double focusedBorderWidth;
  final TextStyle? textStyle;
  final TextStyle? hintTextStyle;
  final TextInputType? keyboardType;

  @override
  State<PasswordTextFieldWidget> createState() =>
      _PasswordTextFieldWidgetState();
}

class _PasswordTextFieldWidgetState extends State<PasswordTextFieldWidget> {
  bool isObscure = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      focusNode: widget.focusNode,
      obscureText: isObscure,
      style: widget.textStyle ?? AppTextStyles.poppinsBold(context, 16),
      onChanged: widget.onChanged,
      onSaved: widget.onSaved,
      validator: widget.validator,
      keyboardType: widget.keyboardType,
      decoration: InputDecoration(
        labelText: widget.labelText,
        hintText: widget.hintText ?? context.tr("Password"),
        hintStyle: widget.hintTextStyle ?? AppTextStyles.poppinsBold(context, 16),
        contentPadding: EdgeInsets.all(widget.contentPadding),
        suffixIcon: IconButton(
          icon: Icon(
            isObscure ? Icons.visibility : Icons.visibility_off,
            color: AppColors.primaryColor,
          ),
          onPressed: () {
            setState(() {
              isObscure = !isObscure;
            });
          },
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          borderSide: BorderSide(
            color: widget.borderColor,
            width: widget.borderWidth,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          borderSide: BorderSide(
            color: widget.focusedBorderColor,
            width: widget.focusedBorderWidth,
          ), // Focused border color
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          borderSide: BorderSide(
            color: widget.enabledBorderColor,
            width: widget.borderWidth,
          ),
        ),
        filled: true,
        fillColor: widget.fillColor,
      ),
    );
  }
}
