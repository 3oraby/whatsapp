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
import 'package:whatsapp/features/auth/presentation/cubits/verify_otp_cubit/verify_otp_cubit.dart';

class VerifyOtpBody extends StatefulWidget {
  const VerifyOtpBody({super.key});

  @override
  State<VerifyOtpBody> createState() => _VerifyOtpBodyState();
}

class _VerifyOtpBodyState extends State<VerifyOtpBody> {
  Timer? _timer;
  int _secondsRemaining = 90;
  bool _canResend = false;

  String currentOtp = "";

  @override
  void initState() {
    super.initState();
    _startTimer();
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
    log("Verifying OTP: $otp");
    String? email =
        AppStorageHelper.getString(StorageKeys.userEmail.toString());
    if (email != null) {
      BlocProvider.of<VerifyOtpCubit>(context).verifyOtp(
        email: email,
        otp: otp,
      );
    } else {
      log("there is no email in storage");
    }
  }

  void _resendOtp() {
    if (_canResend) {
      setState(() {
        currentOtp = "";
      });
      _startTimer();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Verify OTP",
          style: AppTextStyles.poppinsBold(context, 20).copyWith(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.horizontalPadding,
        ),
        child: Column(
          children: [
            const VerticalGap(60),
            Text(
              "Enter the 6-digit code sent to your phone",
              style: AppTextStyles.poppinsBold(context, 18),
            ),
            const VerticalGap(40),
            PinCodeTextField(
              appContext: context,
              length: 6,
              onChanged: (value) => currentOtp = value,
              onCompleted: _verifyOtp,
              keyboardType: TextInputType.number,
              animationType: AnimationType.fade,
              pinTheme: PinTheme(
                shape: PinCodeFieldShape.box,
                borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                fieldHeight: 65,
                fieldWidth: 50,
                activeColor: AppColors.actionColor,
                selectedColor: AppColors.primary,
                inactiveColor: Colors.grey,
              ),
              backgroundColor: theme.scaffoldBackgroundColor,
            ),
            const VerticalGap(30),
            Text(
              _canResend
                  ? "Didn't receive the code?"
                  : "Resend code in $_secondsRemaining sec",
              style: AppTextStyles.poppinsRegular(context, 16),
            ),
            TextButton(
              onPressed: _canResend ? _resendOtp : null,
              child: const Text("Resend Code"),
            ),
          ],
        ),
      ),
    );
  }
}
