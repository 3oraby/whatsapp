part of 'verify_otp_cubit.dart';

abstract class VerifyOtpState {}

final class VerifyOtpInitial extends VerifyOtpState {}

final class VerifyOtpLoadingState extends VerifyOtpState {}

final class VerifyOtpLoadedState extends VerifyOtpState {}

final class VerifyOtpFailureState extends VerifyOtpState {
  final String message;
  VerifyOtpFailureState({required this.message});
}
