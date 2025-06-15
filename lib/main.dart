import 'dart:convert';
import 'dart:io';

import 'package:dynamic_color/dynamic_color.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:how_to_cook/IoC/composition_root.dart';
import 'package:how_to_cook/common/constants.dart';
import 'package:how_to_cook/common/fonts.dart';
import 'package:how_to_cook/common/rest/environment_constants.dart';
import 'package:how_to_cook/services/local_db/local_db_service.dart';
import 'package:how_to_cook/widgets/pages/main_page.dart';
import 'package:injector/injector.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  CompositionRoot.initialize();

  final injector = Injector.appInstance;
  await injector.get<LocalDbService>().init();

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('de'), Locale('uk')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    Constants.currentLocale = context.locale.languageCode;

    return DynamicColorBuilder(
      builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
        if (Platform.isIOS) {
          lightDynamic = ColorScheme.fromSeed(seedColor: const Color(0xFF914949));
          darkDynamic = ColorScheme.fromSeed(seedColor: const Color(0xFF914949));
        }

        return MaterialApp(
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          theme:
              ThemeData(useMaterial3: true, colorScheme: lightDynamic, fontFamily: Fonts.Comfortaa),
          darkTheme:
              ThemeData(useMaterial3: true, colorScheme: darkDynamic, fontFamily: Fonts.Comfortaa),
          home: const MainPage(),
        );
      },
    );
  }
}

Future<void> loadConfig() async {
  final jsonString = await rootBundle.loadString(Constants.configPath);
  final json = jsonDecode(jsonString);
  EnvironmentConstants.DeepLKey = json['DeepLKey'] ?? '';
}
