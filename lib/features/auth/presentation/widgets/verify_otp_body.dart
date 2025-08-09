import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:whatsapp/core/constants/storage_keys.dart';
import 'package:whatsapp/core/storage/app_storage_helper.dart';
import 'package:whatsapp/core/utils/app_colors.dart';
import 'package:whatsapp/core/utils/app_constants.dart';
import 'package:whatsapp/core/utils/app_text_styles.dart';
import 'package:whatsapp/core/widgets/vertical_gap.dart';
import 'package:whatsapp/features/auth/presentation/cubits/resend_otp_cubit/resend_otp_cubit.dart';
import 'package:whatsapp/features/auth/presentation/cubits/verify_otp_cubit/verify_otp_cubit.dart';
import 'package:whatsapp/features/auth/presentation/widgets/resend_otp_bloc_consumer_button.dart';

class VerifyOtpBody extends StatefulWidget {
  const VerifyOtpBody({super.key});

  @override
  State<VerifyOtpBody> createState() => _VerifyOtpBodyState();
}

class _VerifyOtpBodyState extends State<VerifyOtpBody> {
  Timer? _timer;
  int _secondsRemaining = 90;
  bool _canResend = false;

  String? email;
  late TextEditingController _otpController;

  @override
  void initState() {
    super.initState();
    _otpController = TextEditingController();
    _startTimer();
    email = AppStorageHelper.getString(StorageKeys.userEmail.toString());
  }

  void _startTimer() {
    setState(() {
      _secondsRemaining = 90;
      _canResend = false;
    });

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining == 0) {
        setState(() {
          _canResend = true;
        });
        timer.cancel();
      } else {
        setState(() {
          _secondsRemaining--;
        });
      }
    });
  }

  Future<void> _verifyOtp(String otp) async {
    if (!mounted) return;
    log("Verifying OTP: $otp");

    if (email != null) {
      BlocProvider.of<VerifyOtpCubit>(context).verifyOtp(
        email: email!,
        otp: otp,
      );
    } else {
      log("there is no email in storage");
    }
  }

  void _resendOtp() {
    if (_canResend) {
      _otpController.clear();

      _startTimer();
      BlocProvider.of<ResendOtpCubit>(context).resendOtp(
        email: email!,
      );
      _startTimer();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocListener<VerifyOtpCubit, VerifyOtpState>(
      listener: (context, state) {
        if (state is VerifyOtpFailureState) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              _otpController.clear();
            }
          });
        }
      },
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.horizontalPadding,
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const VerticalGap(40),
                Icon(
                  Icons.lock_outline,
                  size: 60,
                  color: AppColors.primary,
                ),
                const VerticalGap(16),
                Text(
                  "Verify Your Email",
                  style: AppTextStyles.poppinsBlack(context, 26),
                  textAlign: TextAlign.center,
                ),
                const VerticalGap(8),
                Text(
                  "Enter the 6-digit code we sent to",
                  style: AppTextStyles.poppinsRegular(context, 15)
                      .copyWith(color: theme.colorScheme.secondary),
                  textAlign: TextAlign.center,
                ),
                const VerticalGap(4),
                Text(
                  email ?? '',
                  style: AppTextStyles.poppinsRegular(context, 15)
                      .copyWith(fontWeight: FontWeight.w500),
                  textAlign: TextAlign.center,
                ),
                const VerticalGap(32),
                PinCodeTextField(
                  controller: _otpController,
                  appContext: context,
                  length: 6,
                  onCompleted: _verifyOtp,
                  keyboardType: TextInputType.number,
                  animationType: AnimationType.scale,
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.box,
                    borderRadius:
                        BorderRadius.circular(AppConstants.borderRadius),
                    fieldHeight: 60,
                    fieldWidth: 48,
                    activeColor: AppColors.primary,
                    selectedColor: AppColors.actionColor,
                    inactiveColor: Colors.grey.shade400,
                    activeFillColor: Colors.grey.shade100,
                    selectedFillColor: Colors.white,
                    inactiveFillColor: Colors.grey.shade50,
                  ),
                  animationDuration: const Duration(milliseconds: 250),
                  enableActiveFill: true,
                  backgroundColor: theme.scaffoldBackgroundColor,
                ),
                const VerticalGap(24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _canResend
                          ? "Didn't receive the code?"
                          : "Resend code in $_secondsRemaining sec",
                      style: AppTextStyles.poppinsRegular(context, 14)
                          .copyWith(color: Colors.grey.shade700),
                    ),
                    const SizedBox(width: 6),
                    ResendOtpBlocConsumerButton(
                      onPressed: _canResend ? _resendOtp : null,
                    ),
                  ],
                ),
                const VerticalGap(24),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(AppConstants.borderRadius),
                    ),
                  ),
                  onPressed: () {
                    if (_otpController.text.length == 6) {
                      _verifyOtp(_otpController.text);
                    }
                  },
                  child: Text(
                    "Verify",
                    style: AppTextStyles.poppinsBlack(context, 16)
                        .copyWith(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
