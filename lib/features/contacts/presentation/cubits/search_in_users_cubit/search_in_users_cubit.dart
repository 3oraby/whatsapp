import 'package:whatsapp/core/cubit/base/base_cubit.dart';
import 'package:whatsapp/features/contacts/domain/entities/user_with_contact_status_entity.dart';
import 'package:whatsapp/features/contacts/domain/repos/contacts_repo.dart';

part 'search_in_users_state.dart';

class SearchInUsersCubit extends BaseCubit<SearchInUsersState> {
  SearchInUsersCubit({required this.contactsRepo})
      : super(SearchInUsersInitial());

  final ContactsRepo contactsRepo;

  Future<void> searchInUsers({String? query}) async {
    emit(SearchInUsersLoadingState());
    final result = await contactsRepo.searchInUsers(query: query);
    result.fold(
      (failure) {
        handleFailure(failure);
        emit(SearchInUsersFailureState(message: failure.message!));
      },
      (users) => emit(SearchInUsersLoadedState(users: users)),
    );
  }
}
