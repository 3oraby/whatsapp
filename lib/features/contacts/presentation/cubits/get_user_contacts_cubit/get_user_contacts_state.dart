part of 'get_user_contacts_cubit.dart';

abstract class GetUserContactsState {}

final class GetUserContactsInitial extends GetUserContactsState {}

final class GetUserContactsLoadingState extends GetUserContactsState {}

final class GetUserContactsEmptyState extends GetUserContactsState {}

final class GetUserContactsLoadedState extends GetUserContactsState {
  final List<UserWithContactStatusEntity> users;

  GetUserContactsLoadedState({required this.users});
}

final class GetUserContactsFailureState extends GetUserContactsState {
  final String message;
  GetUserContactsFailureState({required this.message});
}
