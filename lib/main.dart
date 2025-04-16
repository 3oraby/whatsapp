import 'package:device_preview/device_preview.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whatsapp/core/helpers/on_generate_routes.dart';
import 'package:whatsapp/core/services/custom_bloc_observer.dart';
import 'package:whatsapp/core/services/get_it_service.dart';
import 'package:whatsapp/core/storage/app_storage_helper.dart';
import 'package:whatsapp/core/utils/app_routes.dart';
import 'package:whatsapp/core/utils/app_strings.dart';
import 'package:whatsapp/core/utils/app_themes.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await AppStorageHelper.init();

  setupGetIt();
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

class Whatsapp extends StatelessWidget {
  const Whatsapp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
      initialRoute: Routes.signInRoute,
    );
  }
}
