import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:warehouse_accounting_systems/screens/home_screen.dart';
import 'package:warehouse_accounting_systems/screens/login_screen.dart';
import 'package:warehouse_accounting_systems/screens/main.dart';
import 'package:warehouse_accounting_systems/screens/product_list_screen.dart';
import 'package:warehouse_accounting_systems/screens/registration_screen.dart';
import 'package:warehouse_accounting_systems/screens/setting_screen.dart';

class UserSessionListener extends StatefulWidget {
  const UserSessionListener({super.key});

  @override
  State<UserSessionListener> createState() => _UserSessionListenerState();
}

class _UserSessionListenerState extends State<UserSessionListener> {
  Stream<User?> _userListener() async* {
    yield* FirebaseAuth.instance.authStateChanges().map((event) => event);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
        stream: _userListener(),
        builder: (context, snapshot) {
          if (snapshot.data != null) {
            return Main();
          }
          return LoginScreen();
        });
  }
}

