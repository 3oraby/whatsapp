import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:path_provider/path_provider.dart';
import 'package:whatsapp/core/api/api_consumer.dart';
import 'package:whatsapp/core/api/dio_consumer.dart';
import 'package:whatsapp/core/services/web_socket_service.dart';
import 'package:whatsapp/features/auth/data/repo_impl/auth_repo_impl.dart';
import 'package:whatsapp/features/auth/domain/repo_interface/auth_repo.dart';
import 'package:whatsapp/features/chats/data/repo_impl/chats_repo_impl.dart';
import 'package:whatsapp/features/chats/data/repo_impl/socket_repo_impl.dart';
import 'package:whatsapp/features/chats/domain/repos/chats_repo.dart';
import 'package:whatsapp/features/chats/domain/repos/socket_repo.dart';
import 'package:whatsapp/features/contacts/data/repos_impl/contacts_repo_impl.dart';
import 'package:whatsapp/features/contacts/domain/repos/contacts_repo.dart';
import 'package:whatsapp/features/stories/data/repos_impl/stories_repo_impl.dart';
import 'package:whatsapp/features/stories/domain/repos/stories_repo.dart';

final getIt = GetIt.instance;

Future<void> setupGetIt() async {
  getIt.registerSingleton<Connectivity>(Connectivity());

  // cookies
  Directory appDocDir = await getApplicationDocumentsDirectory();

  final tempPath = appDocDir.path;
  final cookieJar = PersistCookieJar(
    ignoreExpires: true,
    storage: FileStorage(tempPath),
  );

  getIt.registerSingleton<CookieJar>(cookieJar);

  // dio
  getIt.registerSingleton<Dio>(Dio());
  getIt.registerSingleton<ApiConsumer>(DioConsumer(
    dio: getIt<Dio>(),
  ));

  getIt.registerSingleton<AuthRepo>(AuthRepoImpl(
    apiConsumer: getIt<ApiConsumer>(),
  ));

  getIt.registerSingleton<WebSocketService>(
      WebSocketService());

  getIt.registerSingleton<SocketRepo>(SocketRepoImpl(
    webSocketService: getIt<WebSocketService>(),
  ));

  getIt.registerSingleton<ContactsRepo>(ContactsRepoImpl(
    apiConsumer: getIt<ApiConsumer>(),
  ));

  getIt.registerSingleton<StoriesRepo>(StoriesRepoImpl(
    apiConsumer: getIt<ApiConsumer>(),
  ));

  getIt.registerSingleton<ChatsRepo>(ChatsRepoImpl(
    apiConsumer: getIt<ApiConsumer>(),
  ));
}
