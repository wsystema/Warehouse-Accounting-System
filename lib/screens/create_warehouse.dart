import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:warehouse_accounting_systems/model/participants.dart';
import 'package:warehouse_accounting_systems/model/warehouse.dart';

class CreateWarehouseScreen extends StatefulWidget {
  const CreateWarehouseScreen({super.key});

  @override
  State<CreateWarehouseScreen> createState() => _CreateWarehouseScreenState();
}

class _CreateWarehouseScreenState extends State<CreateWarehouseScreen> {
  final _warehouseNameController = TextEditingController();
  final _warehouseDescriptionController = TextEditingController();
  final _addressController = TextEditingController();
  final _priceController = TextEditingController();
  final CollectionReference warehouseCollection =
      FirebaseFirestore.instance.collection('warehouse');

  // final CollectionReference participantsCollection =
  //     FirebaseFirestore.instance.collection('participants');

  bool isLoading = false;
  final _key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _key,
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.warehouseCreationPage),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    TextFormField(
                      controller: _warehouseNameController,
                      decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          labelText:
                              AppLocalizations.of(context)!.warehouseName),
                      validator: (value) => _validation(
                          value,
                          AppLocalizations.of(context)!
                              .pleaseEnterWarehouseName),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _warehouseDescriptionController,
                      decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          labelText: AppLocalizations.of(context)!
                              .warehouseDescription),
                      validator: (value) => _validation(
                          value,
                          AppLocalizations.of(context)!
                              .pleaseEnterWarehouseDescription),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _addressController,
                      decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          labelText: AppLocalizations.of(context)!.address),
                      validator: (value) => _validation(
                          value,
                          AppLocalizations.of(context)!
                              .pleaseEnterWarehouseAddress),
                    ),


                    ElevatedButton(
                        onPressed: isLoading
                            ? null
                            : () {
                                if (_key.currentState!.validate()) {
                                  addWarehouse();
                                }
                              },
                        child: isLoading
                            ? CircularProgressIndicator()
                            : Text(
                                AppLocalizations.of(context)!.createAWarehouse))
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> addWarehouse() async {
    setState(() {
      isLoading = true;
    });
    final user = FirebaseAuth.instance.currentUser!;
    final model = Warehouse(
      id: generateUniqueId(),
      name: _warehouseNameController.text.trim(),
      description: _warehouseDescriptionController.text.trim(),
      address: _addressController.text.trim(),
      membersId: [user.uid],
      );

    try {
      DocumentReference documentReference =
          await warehouseCollection.add(model.toMap());

      await warehouseCollection
          .doc(documentReference.id)
          .collection('participants')
          .add(Participants(
          id: user.uid.toString(),
                  name: user.displayName.toString(),
                  role: 'admin',
                  isActive: true)
              .toMap());
      _showWarehouseAddComplete();
    } catch (e) {
      _showError();
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _showWarehouseAddComplete() {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(AppLocalizations.of(context)!.warehouseCreated)));
  }

  void _showError() {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.warehouseError)));
  }

  String generateUniqueId() {
    int timestamp = DateTime.now().millisecondsSinceEpoch;
    int random = Random().nextInt(999999);
    String uniqueId = '$timestamp$random';

    return uniqueId;
  }

  String? _validation(String? value, String errorText) {
    if (value == null || value.isEmpty) {
      return errorText;
    }
    return null;
  }

  Future<void> _addWarehouse() async {}
}
