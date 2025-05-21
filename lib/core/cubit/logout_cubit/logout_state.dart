part of 'logout_cubit.dart';

abstract class LogoutState {}

final class LogoutInitial extends LogoutState {}

final class LogoutLoadingState extends LogoutState {}

final class LogoutLoadedState extends LogoutState {}

final class LogOutFailureState extends LogoutState {
  final String message;
  LogOutFailureState({required this.message});
}
