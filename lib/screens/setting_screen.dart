import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../wrappers/internationalizing_wrapper.dart';
import '../wrappers/theme_wrapper.dart';
import 'package:warehouse_accounting_systems/wrappers/internationalizing_wrapper.dart';
import 'package:warehouse_accounting_systems/wrappers/theme_wrapper.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
  }

  bool isSwitched = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.settings),
          actions: [
            IconButton(
                onPressed: () {
                  setState(() {
                    isSwitched = !isSwitched;
                  });
                  if (isSwitched == false) {
                    ThemeWrapper.of(context).selectDarkTheme();
                  } else {
                    ThemeWrapper.of(context).selectLightTheme();
                  }
                },
                icon: isSwitched
                    ? Icon(Icons.light_mode)
                    : Icon(Icons.dark_mode)),
          ],
        ),
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  SizedBox(
                    height: 52,
                    width: double.infinity,
                    child: ElevatedButton.icon(
                        onPressed: () => showSelectLangDialog(),
                        icon: Icon(Icons.language),
                        label:
                            Text(AppLocalizations.of(context)!.selectLanguage)),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                      height: 52,
                      width: double.infinity,
                      child: ElevatedButton.icon(
                          onPressed: () async {
                         await   FirebaseAuth.instance.signOut();
                          },
                          icon: Icon(Icons.exit_to_app_rounded),
                          label: Text(AppLocalizations.of(context)!.signOut))),
                ],
              ),
            ),
          ),
        ));
  }

  void showSelectLangDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            icon: Icon(Icons.sign_language_rounded),
            title: Text(AppLocalizations.of(context)!.selectLanguage),
            actions: [
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                    onPressed: () {
                      InternationalizingWrapper.of(context).selectEn();
                    },
                    child: Text(AppLocalizations.of(context)!.englishLanguage)),
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                    onPressed: () {
                      InternationalizingWrapper.of(context).selectRu();
                    },
                    child: Text(AppLocalizations.of(context)!.russianLanguage)),
              ),
              Center(
                child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(AppLocalizations.of(context)!.ok)),
              )
            ],
          );
        });
  }

  Widget buildProfile() {
    if (user == null) {
      return const CircularProgressIndicator();
    } else {
      return Column(
        children: [
          Text(user!.email.toString()),
          Text(user!.displayName.toString()),
        ],
      );
    }
  }
}

// Center(
// child: buildProfile(),
// ),
// ElevatedButton(
// onPressed: () =>
// ThemeWrapper.of(context).selectLightTheme(),
// child: Text(AppLocalizations.of(context)!.lightTheme)),
// ElevatedButton(
// onPressed: () => ThemeWrapper.of(context).selectDarkTheme(),
// child: Text(AppLocalizations.of(context)!.darkTheme)),
// ElevatedButton(
// onPressed: () =>
// InternationalizingWrapper.of(context).selectEn(),
// child: Text(AppLocalizations.of(context)!.englishLanguage)),
// ElevatedButton(
// onPressed: () =>
// InternationalizingWrapper.of(context).selectRu(),
// child: Text(AppLocalizations.of(context)!.russianLanguage)),
// ElevatedButton(
// onPressed: () {
// FirebaseAuth.instance.signOut();
// },
// child: Text(AppLocalizations.of(context)!.signOut))
