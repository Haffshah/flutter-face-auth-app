import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:face_match/framework/dependency_injection/inject.dart';
import 'package:face_match/framework/provider/network/network.dart';
import 'package:face_match/ui/routing/delegate.dart';
import 'package:face_match/ui/routing/parser.dart';
import 'package:face_match/ui/routing/stack.dart';
import 'package:face_match/ui/utils/const/app_constants.dart';
import 'package:face_match/ui/utils/const/global_context_manager.dart';
import 'package:face_match/ui/utils/no_thumb_scroll_indicator.dart';
import 'package:face_match/ui/utils/theme/app_colors.dart';
import 'package:face_match/ui/utils/theme/theme_style.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:url_strategy/url_strategy.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await configureMainDependencies(environment: Env.prod);
  await hiveInitialization();

  setPathUrlStrategy();

  /// Theme For Status Bar & Navigation Bar
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.dark,
      systemNavigationBarColor: AppColors.black,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  runApp(
    ProviderScope(
      child: EasyLocalization(
        supportedLocales: const <Locale>[
          Locale('en'),
          // Locale('ar'),
        ],
        useOnlyLangCode: true,
        path: 'assets/lang',
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  /// dispose method
  @override
  void dispose() {
    Hive.box(hiveSessionBox).compact();
    Hive.close();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    globalRef = ref;
    setGlobalContext(context);
    return MaterialApp.router(
      title: appName,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      debugShowCheckedModeBanner: false,
      scrollBehavior: NoThumbScrollBehavior().copyWith(scrollbars: false),
      theme: ThemeStyle.themeData(AppColors.isDarkMode, context),
      darkTheme: ThemeStyle.themeData(AppColors.isDarkMode, context),
      themeMode: ThemeMode.system,
      routerDelegate: getIt<MainRouterDelegate>(param1: ref.read(navigationStackController)),
      routeInformationParser: getIt<MainRouterInformationParser>(param1: ref, param2: context),
    );
  }
}

/// Hive
Future<void> hiveInitialization() async {
  await Hive.initFlutter();
  await Hive.openBox(hiveSessionBox);
}
