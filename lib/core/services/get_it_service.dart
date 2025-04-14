import 'package:get_it/get_it.dart';
import 'package:whatsapp/features/auth/data/repo_impl/auth_repo_impl.dart';
import 'package:whatsapp/features/auth/domain/repo_interface/auth_repo.dart';

final getIt = GetIt.instance;

void setupGetIt() {
  getIt.registerSingleton<AuthRepo>(AuthRepoImpl());
}
