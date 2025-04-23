import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:whatsapp/core/api/api_consumer.dart';
import 'package:whatsapp/core/api/dio_consumer.dart';
import 'package:whatsapp/core/repos/web_socket_repo/web_socket_repo.dart';
import 'package:whatsapp/core/repos/web_socket_repo/web_socket_repo_impl.dart';
import 'package:whatsapp/core/services/web_socket_service.dart';
import 'package:whatsapp/features/auth/data/repo_impl/auth_repo_impl.dart';
import 'package:whatsapp/features/auth/domain/repo_interface/auth_repo.dart';

final getIt = GetIt.instance;

void setupGetIt() {
  getIt.registerSingleton<Connectivity>(Connectivity());
  getIt.registerSingleton<Dio>(Dio());

  getIt.registerSingleton<ApiConsumer>(DioConsumer(
    dio: getIt<Dio>(),
  ));
  getIt.registerSingleton<AuthRepo>(AuthRepoImpl(
    apiConsumer: getIt<ApiConsumer>(),
  ));

  getIt.registerSingleton<WebSocketService>(WebSocketService()..initSocketConnection());

  getIt.registerSingleton<WebSocketRepo>(WebSocketRepoImpl(
    webSocketService: getIt<WebSocketService>(),
  ));
}
