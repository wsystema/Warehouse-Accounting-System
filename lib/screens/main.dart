import 'package:flutter/material.dart';
import 'package:warehouse_accounting_systems/screens/home_screen.dart';
import 'package:warehouse_accounting_systems/screens/setting_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Main extends StatefulWidget {
  const Main({super.key});

  @override
  State<Main> createState() => _MainState();
}

class _MainState extends State<Main> {
  int _selectIndex = 0;
  static const List<Widget> bodyList = <Widget>[HomeScreen(), SettingScreen()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: bodyList[_selectIndex],
      bottomNavigationBar: NavigationBar(
          selectedIndex: _selectIndex,
          onDestinationSelected: onTapChange,
          destinations: [
        NavigationDestination(
            icon: const Icon(Icons.home),
            label: AppLocalizations.of(context)!.home),
        NavigationDestination(
            icon: const Icon(Icons.settings),
            label: AppLocalizations.of(context)!.settings),
      ]),
    );
  }

  // onTap: onTapChange,
  //
  // currentIndex: _selectIndex,

  void onTapChange(int page) {
    setState(() {
      _selectIndex = page;
    });
  }
}
