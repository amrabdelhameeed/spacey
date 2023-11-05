import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as path;
import '/core/constants/app_routes.dart';
import 'app_router.dart';
import 'core/constants/app_theme.dart';
import 'core/constants/observer.dart';
import 'core/localaization/app_localization.dart';
import 'core/localaization/app_services_database_provider.dart';
import 'core/utils/app_database_keys.dart';
import 'core/utils/shared_pref_helper.dart';
import 'di.dart';

String _initialRoute = AppRoutes.home;
void main() async {
  Bloc.observer = MyBlocObserver();
  WidgetsFlutterBinding.ensureInitialized();
  setup();
  await SharedPrefHelper.init();
  await _initHiveBoxes();
  runApp(MyApp(
    appRouter: AppRouter(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key, required this.appRouter}) : super(key: key);
  final AppRouter appRouter;
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box<String>>(
      valueListenable: AppServicesDBprovider.listenable(),
      builder: (context, box, _) {
        return MaterialApp(
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: AppServicesDBprovider.isDark() ? ThemeMode.dark : ThemeMode.light,
          locale: Locale(AppServicesDBprovider.currentLocale() ?? "en"),
          initialRoute: _initialRoute,
          supportedLocales: const [Locale('en'), Locale('ar')],
          localizationsDelegates: const [AppLocalizations.delegate, GlobalMaterialLocalizations.delegate, GlobalWidgetsLocalizations.delegate, GlobalCupertinoLocalizations.delegate],
          onGenerateRoute: appRouter.onGenerateRoute,
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}

/*



*/

// _initHiveBox in void main
Future<void> _initHiveBoxes() async {
  final dbPath = await path.getApplicationDocumentsDirectory();
  Hive.init(dbPath.path);
  await Hive.openBox<String>(AppDatabaseKeys.appServicesKey).then((box) {
    if (box.get(AppDatabaseKeys.tokenKey) != null) {
      _initialRoute = AppRoutes.home;
    }
    if (!box.containsKey(AppDatabaseKeys.localeKey)) {
      //if there is not any saved locale => save device locale
      box.put(AppDatabaseKeys.localeKey, Platform.localeName.substring(0, 2));
      print(Platform.localeName.substring(0, 2));
    }
    if (!box.containsKey(AppDatabaseKeys.themeKey)) {
      //if there is not any saved theme => save device theme
      final isDark = SchedulerBinding.instance.window.platformBrightness == Brightness.dark ? '1' : '0';
      box.put(AppDatabaseKeys.themeKey, isDark);
    }
  });
}
// Locale? _localeResolutionCallback(Locale? deviceLocale, Iterable<Locale> supportedLocales) {
//   for (var locale in supportedLocales) {
//     if (deviceLocale != null && deviceLocale.languageCode == locale.languageCode) {
//       return deviceLocale;
//     }
//   }
//   return supportedLocales.first;
// }
