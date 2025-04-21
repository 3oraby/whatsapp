part of 'resend_otp_cubit.dart';

abstract class ResendOtpState {}

final class ResendOtpInitial extends ResendOtpState {}

final class ResendOtpLoadingState extends ResendOtpState {}

final class ResendOtpLoadedState extends ResendOtpState {}

final class ResendOtpFailureState extends ResendOtpState {
  final String message;
  ResendOtpFailureState({required this.message});
}
