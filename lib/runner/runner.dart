import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:warehouse_accounting_systems/extension/firebase_options.dart';
import 'package:warehouse_accounting_systems/runner/app.dart';
import 'package:warehouse_accounting_systems/runner/dependencies.dart';

class Runner {
  static Future<void> startApplication() async {
    WidgetsFlutterBinding.ensureInitialized();
 /// Resolving dependencies from Firebase
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);

  const  App().launch();
  }
}
