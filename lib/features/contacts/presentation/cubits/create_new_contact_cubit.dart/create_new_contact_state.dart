part of 'create_new_contact_cubit.dart';

abstract class CreateNewContactState {}

final class CreateNewContactInitial extends CreateNewContactState {}

final class CreateNewContactLoadingState extends CreateNewContactState {}

final class CreateNewContactLoadedState extends CreateNewContactState {

}

final class CreateNewContactFailureState extends CreateNewContactState {
  final String message;
  CreateNewContactFailureState({required this.message});
}
