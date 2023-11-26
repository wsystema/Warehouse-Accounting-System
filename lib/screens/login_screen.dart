import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:warehouse_accounting_systems/screens/registration_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _key = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _key,
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.loginScreen),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Center(
                child: Column(
                  children: [
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          labelText: AppLocalizations.of(context)!.email),
                      validator: (value) => _validation(value,
                          AppLocalizations.of(context)!.pleaseEnterEmail),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          labelText: AppLocalizations.of(context)!.password),
                      validator: (value) => _validation(value,
                          AppLocalizations.of(context)!.pleaseEnterPassword),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                            onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => RegistrationScreen()),
                               ),
                            child: Text(
                                AppLocalizations.of(context)!.createAnAccount)),
                        ElevatedButton(
                            onPressed: isLoading
                                ? null
                                : () {
                                    if (_key.currentState!.validate()) {
                                      signInWithEmail(
                                          _emailController.text.trim(),
                                          _passwordController.text.trim());
                                    }
                                  },
                            child: isLoading
                                ? const Center(
                                    child: CircularProgressIndicator(),
                                  )
                                : Text(AppLocalizations.of(context)!.login)),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> signInWithEmail(String email, String password) async {
    try {
      setState(() {
        isLoading = true;
      });
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password)
          .then((value) => showCompleted(context));
    } on FirebaseAuthException catch (e) {
      debugPrint(e.toString());
      showError();
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void showError() {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.signInError)));
  }

  void showCompleted(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.completed)));
  }

  String? _validation(String? value, String errorText) {
    if (value == null || value.isEmpty) {
      return errorText;
    }
    return null;
  }
}
