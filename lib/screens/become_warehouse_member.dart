import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:warehouse_accounting_systems/model/participants.dart';
import 'package:warehouse_accounting_systems/model/warehouse.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BecomeWarehouseMember extends StatefulWidget {
  const BecomeWarehouseMember({super.key, required this.warehouseId});

  final String warehouseId;

  @override
  State<BecomeWarehouseMember> createState() => _BecomeWarehouseMemberState();
}

class _BecomeWarehouseMemberState extends State<BecomeWarehouseMember> {
  Stream<List<WarehouseFromMap>> warehouseFetchStream() async* {
    yield* FirebaseFirestore.instance
        .collection('warehouse')
        .where('id', isEqualTo: widget.warehouseId)
        .snapshots()
        .asyncMap((event) => event.docs
            .map((e) => WarehouseFromMap.fromMap(e.data(), e.id))
            .toList());
  }

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.selectARole),
      ),
      body: SafeArea(
        child: Center(
          child: StreamBuilder<List<WarehouseFromMap>>(
              stream: warehouseFetchStream(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final data = snapshot.data!.first;
                  return Stack(
                    children: [
                      ListTile(
                          title: Text(data.name), trailing: Text(data.address)),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              ElevatedButton.icon(
                                  onPressed: isLoading
                                      ? null
                                      : () => addManager(data.docId),
                                  icon: Icon(Icons.manage_accounts_rounded),
                                  label: isLoading
                                      ? CircularProgressIndicator()
                                      : Text(AppLocalizations.of(context)!
                                          .manager)),
                              ElevatedButton.icon(
                                  onPressed: isLoading
                                      ? null
                                      : () async =>
                                          await addManager(data.docId),
                                  icon: Icon(Icons.money_off_csred_rounded),
                                  label: isLoading
                                      ? CircularProgressIndicator()
                                      : Text(AppLocalizations.of(context)!
                                          .accountant)),
                            ],
                          ),
                        ),
                      )
                    ],
                  );
                }
                return CircularProgressIndicator();
              }),
        ),
      ),
    );
  }

  // Row(
  // children: [
  // ElevatedButton.icon(
  // onPressed: isLoading
  // ? null
  //     : () => addManager(data.docId),
  // icon: Icon(Icons.manage_accounts_rounded),
  // label: isLoading
  // ? CircularProgressIndicator()
  //     : Text(
  // AppLocalizations.of(context)!.manager)),
  // ElevatedButton.icon(
  // onPressed: isLoading
  // ? null
  //     : () async => await addManager(data.docId),
  // icon: Icon(Icons.money_off_csred_rounded),
  // label: isLoading
  // ? CircularProgressIndicator()
  //     : Text(AppLocalizations.of(context)!
  //     .accountant)),
  // ],
  // )

  Future<void> showMemberRole(String docId) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(AppLocalizations.of(context)!.selectARole),
            icon: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.exit_to_app_outlined)),
            actions: [
              ElevatedButton.icon(
                  onPressed: isLoading ? null : () => addManager(docId),
                  icon: Icon(Icons.manage_accounts_rounded),
                  label: isLoading
                      ? CircularProgressIndicator()
                      : Text(AppLocalizations.of(context)!.manager)),
              ElevatedButton.icon(
                  onPressed:
                      isLoading ? null : () async => await addManager(docId),
                  icon: Icon(Icons.money_off_csred_rounded),
                  label: isLoading
                      ? CircularProgressIndicator()
                      : Text(AppLocalizations.of(context)!.accountant)),
            ],
          );
        });
  }

  Future<void> addManager(String docId) async {
    final user = FirebaseAuth.instance.currentUser!;
    setState(() {
      isLoading = true;
    });
    try {
      await FirebaseFirestore.instance
          .collection('warehouse')
          .doc(docId)
          .collection('participants')
          .add(Participants(
                  id: user.uid,
                  name: user.displayName.toString(),
                  role: 'manager',
                  isActive: false)
              .toMap())
          .then((value) {
        setState(() {
          isLoading = false;
        });
        showRequestComplete();
      });
    } catch (e) {
      debugPrint(e.toString());
      showRequestFailure();
    } finally {
      setState(() {
        isLoading = false;
      });


    }
  }

  Future<void> addAccountant(String docId) async {
    final user = FirebaseAuth.instance.currentUser!;
    setState(() {
      isLoading = true;
    });

    try {
      await FirebaseFirestore.instance
          .collection('warehouse')
          .doc(docId)
          .collection('participants')
          .add(Participants(
                  id: user.uid,
                  name: user.displayName.toString(),
                  role: 'accountant',
                  isActive: false)
              .toMap())
          .then((value) {
        setState(() {
          isLoading = false;
        });
        showRequestComplete();
      });
    } catch (e) {
      debugPrint(e.toString());
      showRequestFailure();
    } finally {
      setState(() {
        isLoading = false;
      });

    }
  }

  void showRequestComplete() {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.requestComplete)));
  }

  void showRequestFailure() {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.requestFailure)));
  }
}
