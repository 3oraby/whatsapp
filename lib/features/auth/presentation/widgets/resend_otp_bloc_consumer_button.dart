import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whatsapp/core/helpers/show_custom_snack_bar.dart';
import 'package:whatsapp/features/auth/presentation/cubits/resend_otp_cubit/resend_otp_cubit.dart';

class ResendOtpBlocConsumerButton extends StatelessWidget {
  const ResendOtpBlocConsumerButton({
    super.key,
    required this.onPressed,
  });

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ResendOtpCubit, ResendOtpState>(
      listener: (context, state) {
        if (state is ResendOtpFailureState) {
          showCustomSnackBar(context, state.message);
        } else if (state is ResendOtpLoadedState) {
          showCustomSnackBar(
              context, "A new verification code has been sent to your email.");
        }
      },
      builder: (context, state) => TextButton(
        onPressed: onPressed,
        child: state is ResendOtpLoadingState
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(),
              )
            : Text("Resend Code"),
      ),
    );
  }
}
