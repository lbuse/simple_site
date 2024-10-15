import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get_it/get_it.dart';

import 'core/theme/theme.dart';
import 'core/theme/util.dart';
import 'features/home/presentation/pages/home.dart';
import 'features/settings/settings_controller.dart';

class App extends StatefulWidget {
  const App({
    super.key,
    required this.settingsController,
  });

  final SettingsController settingsController;

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final getIt = GetIt.I;
  late final MaterialTheme theme;

  @override
  void initState() {
    super.initState();
    getIt.registerSingleton<SettingsController>(widget.settingsController);

    final textTheme = createTextTheme(context, "Poppins", "Poppins");
    theme = MaterialTheme(textTheme);
  }

  @override
  void dispose() {
    getIt.unregister<SettingsController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.settingsController,
      builder: (BuildContext context, Widget? child) {
        return MaterialApp(
          restorationScopeId: 'app',
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('pt', 'BR'),
            Locale('en', ''), // English, no country code
          ],
          onGenerateTitle: (BuildContext context) =>
              AppLocalizations.of(context)!.appTitle,
          theme: theme.light(),
          darkTheme: theme.dark(),
          themeMode: widget.settingsController.themeMode,
          home: const Home(),
        );
      },
    );
  }
}
