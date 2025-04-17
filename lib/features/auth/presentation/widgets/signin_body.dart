import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whatsapp/core/utils/app_constants.dart';
import 'package:whatsapp/core/utils/app_routes.dart';
import 'package:whatsapp/core/utils/app_text_styles.dart';
import 'package:whatsapp/core/utils/validators.dart';
import 'package:whatsapp/core/widgets/custom_text_form_field.dart';
import 'package:whatsapp/core/widgets/custom_trigger_button.dart';
import 'package:whatsapp/core/widgets/password_text_form_field.dart';
import 'package:whatsapp/core/widgets/vertical_gap.dart';
import 'package:whatsapp/features/auth/presentation/cubits/signin_cubits/sign_in_cubit.dart';
import 'package:whatsapp/features/auth/presentation/widgets/auth_switch_widget.dart';

class SignInBody extends StatefulWidget {
  const SignInBody({super.key});

  @override
  State<SignInBody> createState() => _SignInBodyState();
}

class _SignInBodyState extends State<SignInBody> {
  AutovalidateMode autovalidateMode = AutovalidateMode.onUserInteraction;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late String email, password;

  void submitSignInForm() {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      BlocProvider.of<SignInCubit>(context).signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } else {
      setState(() {
        autovalidateMode = AutovalidateMode.always;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.horizontalPadding),
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                const VerticalGap(40),
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Theme.of(context).primaryColor,
                  child: Icon(
                    Icons.lock,
                    size: 40,
                    color: Colors.white,
                  ),
                ),
                const VerticalGap(24),
                Text(
                  context.tr("Welcome Back"),
                  style: AppTextStyles.poppinsBold(context, 28),
                ),
                const VerticalGap(8),
                Text(
                  context.tr("Sign in with your email and password"),
                  textAlign: TextAlign.center,
                  style: AppTextStyles.poppinsRegular(context, 16),
                ),
                const VerticalGap(32),
                CustomTextFormFieldWidget(
                  autovalidateMode: autovalidateMode,
                  hintText: context.tr("Email"),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) =>
                      Validators.validateEmail(context, value),
                  onSaved: (value) {
                    email = value!;
                  },
                ),
                const VerticalGap(16),
                PasswordTextFieldWidget(
                  autovalidateMode: autovalidateMode,
                  hintText: context.tr("Password"),
                  validator: (value) =>
                      Validators.validatePassword(context, value),
                  onSaved: (value) {
                    password = value!;
                  },
                ),
                const VerticalGap(24),
                CustomTriggerButton(
                  buttonDescription: Text(
                    context.tr("Sign In"),
                    style: AppTextStyles.poppinsBold(context, 18)
                        .copyWith(color: Colors.white),
                  ),
                  onPressed: submitSignInForm,
                ),
                const VerticalGap(16),
                AuthSwitchWidget(
                  promptText: context.tr("Don't have an account?"),
                  actionText: context.tr("SignUp"),
                  onActionPressed: () {
                    Navigator.pushNamed(context, Routes.signUpRoute);
                  },
                ),
                const VerticalGap(16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
