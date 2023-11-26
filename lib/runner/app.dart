import 'package:flutter/material.dart';

import 'package:warehouse_accounting_systems/screens/registration_screen.dart';
import 'package:warehouse_accounting_systems/screens/user_session_listener.dart';
import 'package:warehouse_accounting_systems/theme/theme.dart';
import 'package:warehouse_accounting_systems/wrappers/internationalizing_wrapper.dart';
import 'package:warehouse_accounting_systems/wrappers/theme_wrapper.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../screens/create_warehouse.dart';

class App extends StatefulWidget {
  const App({
    super.key,
  });

  void launch() => runApp(this);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {




  @override
  Widget build(BuildContext context) {
    return ThemeWrapper(
        child: InternationalizingWrapper(
      child: MaterialCtx(),
    ));
  }
}

class MaterialCtx extends StatelessWidget {
  const MaterialCtx({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: ThemeScope.of(context).data.themeMode,
      locale: InternationalizingScope.of(context).data.locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      home: UserSessionListener(),
    );
  }
}
