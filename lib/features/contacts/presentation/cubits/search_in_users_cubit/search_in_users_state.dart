part of 'search_in_users_cubit.dart';

abstract class SearchInUsersState {}

final class SearchInUsersInitial extends SearchInUsersState {}

final class SearchInUsersLoadingState extends SearchInUsersState {}

final class SearchInUsersLoadedState extends SearchInUsersState {
  final List<UserWithContactStatusEntity> users;

  SearchInUsersLoadedState({required this.users});
}

final class SearchInUsersFailureState extends SearchInUsersState {
  final String message;
  SearchInUsersFailureState({required this.message});
}
