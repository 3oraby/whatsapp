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
import 'package:whatsapp/features/auth/data/models/sign_up_request_model.dart';
import 'package:whatsapp/features/auth/domain/entities/sign_up_request_entity.dart';
import 'package:whatsapp/features/auth/presentation/cubits/signup_cubits/sign_up_cubit.dart';
import 'package:whatsapp/features/auth/presentation/widgets/auth_switch_widget.dart';

class SignUpBody extends StatefulWidget {
  const SignUpBody({super.key});

  @override
  State<SignUpBody> createState() => _SignUpBodyState();
}

class _SignUpBodyState extends State<SignUpBody> {
  AutovalidateMode autovalidateMode = AutovalidateMode.onUserInteraction;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  late String name, phoneNumber, email, password, confirmPassword;

  void submitSignUpForm() {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();

      final SignUpRequestEntity signUpRequestEntity = SignUpRequestEntity(
        name: name,
        email: email,
        password: password,
        phone: phoneNumber,
      );

      final model = SignUpRequestModel.fromEntity(signUpRequestEntity);

      BlocProvider.of<SignUpCubit>(context).signUp(data: model.toJson());
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
          horizontal: AppConstants.horizontalPadding,
        ),
        child: Form(
          key: formKey,
          autovalidateMode: autovalidateMode,
          child: SingleChildScrollView(
            child: Column(
              children: [
                const VerticalGap(40),
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Theme.of(context).primaryColor,
                  child: Icon(
                    Icons.person_add_alt_1,
                    size: 40,
                    color: Colors.white,
                  ),
                ),
                const VerticalGap(24),
                Text(
                  context.tr("Create Account"),
                  style: AppTextStyles.poppinsBold(context, 28),
                ),
                const VerticalGap(8),
                Text(
                  context.tr("Sign up with your email and password"),
                  textAlign: TextAlign.center,
                  style: AppTextStyles.poppinsRegular(context, 16)
                      .copyWith(color: Colors.grey[600]),
                ),
                const VerticalGap(32),
                CustomTextFormFieldWidget(
                  hintText: context.tr("Full Name"),
                  autovalidateMode: autovalidateMode,
                  keyboardType: TextInputType.name,
                  validator: (value) =>
                      Validators.validateNormalText(context, value),
                  onSaved: (value) {
                    name = value!.trim();
                  },
                ),
                const VerticalGap(16),
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
                const VerticalGap(16),
                CustomTextFormFieldWidget(
                  hintText: context.tr("Phone Number"),
                  autovalidateMode: autovalidateMode,
                  keyboardType: TextInputType.phone,
                  validator: (value) =>
                      Validators.validatePhoneNumber(context, value),
                  onSaved: (value) {
                    phoneNumber = value!.trim();
                  },
                ),
                const VerticalGap(24),
                CustomTriggerButton(
                  buttonDescription: Text(
                    context.tr("Sign Up"),
                    style: AppTextStyles.poppinsBold(context, 18)
                        .copyWith(color: Colors.white),
                  ),
                  onPressed: submitSignUpForm,
                ),
                const VerticalGap(16),
                AuthSwitchWidget(
                  promptText: context.tr("Already have an account?"),
                  actionText: context.tr("SignIn"),
                  onActionPressed: () {
                    Navigator.pop(context);
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
