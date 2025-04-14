part of 'sign_up_cubit.dart';

abstract class SignUpState {}

final class SignUpInitial extends SignUpState {}

final class SignUpLoadingState extends SignUpState {}

final class SignUpLoadedState extends SignUpState {}

final class SignUpFailureState extends SignUpState {
  final String message;
  SignUpFailureState({required this.message});
}
