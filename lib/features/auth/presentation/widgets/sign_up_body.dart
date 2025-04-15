import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whatsapp/core/utils/app_constants.dart';
import 'package:whatsapp/core/utils/app_text_styles.dart';
import 'package:whatsapp/core/utils/validators.dart';
import 'package:whatsapp/core/widgets/custom_text_form_field.dart';
import 'package:whatsapp/core/widgets/custom_trigger_button.dart';
import 'package:whatsapp/core/widgets/password_text_form_field.dart';
import 'package:whatsapp/core/widgets/vertical_gap.dart';
import 'package:whatsapp/features/auth/presentation/cubits/signup_cubits/sign_up_cubit.dart';
import 'package:whatsapp/features/auth/presentation/widgets/auth_switch_widget.dart';

class SignUpBody extends StatefulWidget {
  const SignUpBody({
    super.key,
  });

  @override
  State<SignUpBody> createState() => _SignUpBodyState();
}

class _SignUpBodyState extends State<SignUpBody> {
  AutovalidateMode autovalidateMode = AutovalidateMode.onUserInteraction;
  final formKey = GlobalKey<FormState>();
  late String email, password;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.horizontalPadding,
      ),
      child: Form(
        key: formKey,
        autovalidateMode: autovalidateMode,
        child: SingleChildScrollView(
          child: Column(
            children: [
              const VerticalGap(16),
              CustomTextFormFieldWidget(
                autovalidateMode: autovalidateMode,
                hintText: context.tr("Email"),
                keyboardType: TextInputType.emailAddress,
                validator: (value) => Validators.validateEmail(context, value),
                onSaved: (value) {
                  email = value!;
                },
              ),
              const VerticalGap(16),
              PasswordTextFieldWidget(
                autovalidateMode: autovalidateMode,
                validator: (value) =>
                    Validators.validatePassword(context, value),
                onSaved: (value) {
                  password = value!;
                },
              ),
              const VerticalGap(16),
              CustomTriggerButton(
                buttonDescription: Text(
                  context.tr("SignUp"),
                  style: AppTextStyles.poppinsBold(context, 22)
                      .copyWith(color: Colors.white),
                ),
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    formKey.currentState!.save();
                    SignUpCubit signUpCubit =
                        BlocProvider.of<SignUpCubit>(context);
                    signUpCubit.createUserWithEmailAndPassword(
                        email: email, password: password);
                  } else {
                    setState(() {
                      autovalidateMode = AutovalidateMode.always;
                    });
                  }
                },
              ),
              const VerticalGap(10),
              AuthSwitchWidget(
                promptText: context.tr("Already have an account?"),
                actionText: context.tr("SignIn"),
                onActionPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
