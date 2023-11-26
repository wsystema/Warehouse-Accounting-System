import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:warehouse_accounting_systems/model/warehouse.dart';
import 'package:warehouse_accounting_systems/screens/become_warehouse_member.dart';
import 'package:warehouse_accounting_systems/screens/checking_role_screen.dart';
import 'package:warehouse_accounting_systems/screens/create_warehouse.dart';
import 'package:warehouse_accounting_systems/screens/product_list_screen.dart';
import 'package:clipboard/clipboard.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _warehouseIdController = TextEditingController();

  final _key = GlobalKey<FormState>();

  @override
  void dispose() {
    _warehouseIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.warehouseAccountingSystem),
      ),
      body: SafeArea(
        child: Center(
          child: StreamBuilder<List<WarehouseFromMap>>(
              stream: warehouseStream(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        final warehouse = snapshot.data![index];
                        // if (snapshot.data!.isNotEmpty) {
                        //   return Text(
                        //       AppLocalizations.of(context)!.warehouseEmpty);
                        // }
                        if (snapshot.hasData) {
                          return InkWell(
                              // onTap: () => Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //         builder: (context) => ProductListScreen(
                              //             docId: warehouse.docId, membersId: warehouse.membersId,))),
                              onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => CheckingRoleScreen(
                                          docId: warehouse.docId))),
                              child: Container(
                                  margin: EdgeInsets.all(10),
                                  padding: EdgeInsets.all(10),
                                  width: 200.0,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    color: Theme.of(context).backgroundColor,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        spreadRadius: 0,
                                        blurRadius: 2,
                                        offset: Offset(3, 3),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                              '${AppLocalizations.of(context)!.na} ${warehouse.name}'),
                                          Text(
                                              '${AppLocalizations.of(context)!.address} : ${warehouse.address}')
                                        ],
                                      ),
                                      SizedBox(
                                        height: 40,
                                        width: 50,
                                        child: IconButton(
                                            onPressed: () {
                                              FlutterClipboard.copy(
                                                      warehouse.id)
                                                  .then((value) =>
                                                      showCopyCompleted());
                                            },
                                            icon: Icon(Icons.copy)),
                                      )
                                    ],
                                  )));
                        }
                      });
                }
                if (snapshot.hasError) {
                  return Text(snapshot.error.toString());
                }
                return CircularProgressIndicator();
              }),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => warehouseSelect(),
        child: const Icon(Icons.add),
      ),
    );
  }

  // FlutterClipboard.copy(warehouse.id).then((value) => showCopyCompleted());   icon: Icon(Icons.copy)),

  void showCopyCompleted() {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.idCopied)));
  }

  Stream<List<WarehouseFromMap>> warehouseStream() async* {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    yield* FirebaseFirestore.instance
        .collection('warehouse')
        .where('membersId', arrayContainsAny: [uid])
        .snapshots()
        .asyncMap((event) => event.docs
            .map((e) => WarehouseFromMap.fromMap(e.data(), e.id))
            .toList());
  }

  void warehouseSelect() {
    showModalBottomSheet(
        // isScrollControlled: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
        context: context,
        builder: (context) {
          return Container(
            padding: const EdgeInsets.all(30),
            height: 200,
            child: Column(
              children: [
                SizedBox(
                  height: 52,
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CreateWarehouseScreen())),
                      child:
                          Text(AppLocalizations.of(context)!.createAWarehouse)),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 52,
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: () => showBecomeMemberDialog(),
                      child: Text(AppLocalizations.of(context)!
                          .becomeAWarehouseMember)),
                ),
              ],
            ),
          );
        });
  }

  Future<void> showBecomeMemberDialog() {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              icon: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(Icons.exit_to_app_outlined)),
              title: Text(AppLocalizations.of(context)!.pleaseEnterWarehouseId),
              actions: <Widget>[
                Form(
                  key: _key,
                  child: TextFormField(
                    controller: _warehouseIdController,
                    decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        labelText: AppLocalizations.of(context)!
                            .pleaseEnterWarehouseId),
                    validator: (value) => _validation(value,
                        AppLocalizations.of(context)!.pleaseEnterWarehouseId),
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                    onPressed: () {
                      if (_key.currentState!.validate()) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => BecomeWarehouseMember(
                                    warehouseId: _warehouseIdController.text)));
                      }
                    },
                    child: Text(
                        AppLocalizations.of(context)!.becomeAWarehouseMember))
              ],
            ));
  }

  String? _validation(String? value, String errorText) {
    if (value == null || value.isEmpty) {
      return errorText;
    }
    return null;
  }
}
