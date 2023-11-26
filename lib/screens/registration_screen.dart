import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:warehouse_accounting_systems/wrappers/internationalizing_wrapper.dart';
import 'package:warehouse_accounting_systems/wrappers/theme_wrapper.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _key = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();

  bool isLoading = false;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
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
          title: Text(AppLocalizations.of(context)!.registrationScreen),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          labelText: AppLocalizations.of(context)!.name),
                      validator: (value) => _validation(
                          value, AppLocalizations.of(context)!.pleaseEnterName),
                    ),
                    const SizedBox(height: 20),
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
                    ElevatedButton(
                        onPressed: isLoading
                            ? null
                            : () {
                                if (_key.currentState!.validate()) {
                                  registerWithEmail(
                                      _emailController.text.trim(),
                                      _passwordController.text.trim(),
                                      _nameController.text.trim());
                                }
                              },
                        child: Text(AppLocalizations.of(context)!.registration))
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
void who(){
    final  uid = FirebaseAuth.instance.currentUser!.uid;
    
}
  Future<void> registerWithEmail(
      String email, String password, String name) async {
    try {
      setState(() {
        isLoading = true;
      });
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) async {
        showCompleted(context);
      });
      await addName(_nameController.text.trim());
    } on FirebaseAuthException catch (e) {
      debugPrint(e.toString());
      showError();
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> addName(String name) async {
    await FirebaseAuth.instance.currentUser!.updateDisplayName(name);
  }

  void showError() {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(AppLocalizations.of(context)!.registrationError)));
  }

  void showCompleted(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.completed)));
    Navigator.of(context).pop();
  }

  String? _validation(String? value, String errorText) {
    if (value == null || value.isEmpty) {
      return errorText;
    }
    return null;
  }
}
