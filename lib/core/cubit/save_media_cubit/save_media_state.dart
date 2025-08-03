part of 'save_media_cubit.dart';

abstract class SaveMediaState {}

class SaveMediaInitial extends SaveMediaState {}

class SaveMediaSuccess extends SaveMediaState {}

class SaveMediaFailure extends SaveMediaState {
  final String message;
  SaveMediaFailure(this.message);
}
