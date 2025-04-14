part of 'sign_in_cubit.dart';

abstract class SignInState {}

final class SignInInitial extends SignInState {}

final class SignInLoadingState extends SignInState {}

final class SignInLoadedState extends SignInState {}

final class SignInFailureState extends SignInState {
  final String message;
  SignInFailureState({required this.message});
}
