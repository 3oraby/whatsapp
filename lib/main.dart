import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:device_preview/device_preview.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whatsapp/core/cubit/internet/internet_connection_cubit.dart';
import 'package:whatsapp/core/helpers/get_initial_route.dart';
import 'package:whatsapp/core/helpers/on_generate_routes.dart';
import 'package:whatsapp/core/services/custom_bloc_observer.dart';
import 'package:whatsapp/core/services/get_it_service.dart';
import 'package:whatsapp/core/storage/app_storage_helper.dart';
import 'package:whatsapp/core/utils/app_routes.dart';
import 'package:whatsapp/core/utils/app_strings.dart';
import 'package:whatsapp/core/utils/app_themes.dart';
import 'package:whatsapp/features/auth/presentation/screens/signin_screen.dart';
import 'package:whatsapp/features/chats/domain/repos/socket_repo.dart';
import 'package:whatsapp/features/chats/presentation/cubits/socket_connection_cubit/socket_connection_cubit.dart';
import 'package:whatsapp/features/home/presentation/screens/home_screen.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await AppStorageHelper.init();
  await setupGetIt();
  Bloc.observer = CustomBlocObserver();

  runApp(
    EasyLocalization(
      supportedLocales: const [
        Locale('en'),
        Locale('ar'),
      ],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      startLocale: const Locale('en'),
      child: DevicePreview(
        builder: (context) => const Whatsapp(),
      ),
    ),
  );
}

class Whatsapp extends StatefulWidget {
  const Whatsapp({super.key});

  @override
  State<Whatsapp> createState() => _WhatsappState();
}

class _WhatsappState extends State<Whatsapp> with WidgetsBindingObserver {
  late SocketConnectionCubit socketCubit;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    socketCubit = SocketConnectionCubit(
      socketRepo: getIt<SocketRepo>(),
    );
    socketCubit.connect();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    socketCubit.disconnect();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      debugPrint("✅ App resumed (foreground) – user is online");
      socketCubit.connect();
    } else if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      debugPrint("⏸️ App not active – user is offline");
      socketCubit.disconnect();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => socketCubit,
        ),
        BlocProvider(
          create: (context) => InternetConnectionCubit(
            connectivity: getIt<Connectivity>(),
            socketConnectionCubit: socketCubit,
          ),
        ),
      ],
      child: MaterialApp(
        title: AppStrings.appTitle,
        debugShowCheckedModeBanner: false,
        navigatorKey: navigatorKey,
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        theme: AppThemes.getLightTheme(context),
        darkTheme: AppThemes.getDarkTheme(context),
        themeMode: ThemeMode.system,
        onGenerateRoute: onGenerateRoutes,
        home: getInitialRoute() == Routes.homeRoute
            ? const HomeScreen()
            : const SignInScreen(),
      ),
    );
  }
}
