import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:warehouse_accounting_systems/model/participants.dart';
import 'package:warehouse_accounting_systems/screens/accountatn_screen.dart';
import 'package:warehouse_accounting_systems/screens/product_list_screen.dart';

class CheckingRoleScreen extends StatefulWidget {
  const CheckingRoleScreen({super.key, required this.docId});

  final String docId;

  @override
  State<CheckingRoleScreen> createState() => _CheckingRoleScreenState();
}

class _CheckingRoleScreenState extends State<CheckingRoleScreen> {
  final String userId = FirebaseAuth.instance.currentUser!.uid;

  Stream<List<Participants>> getParticipants() async* {
    yield* FirebaseFirestore.instance
        .collection('warehouse')
        .doc(widget.docId)
        .collection('participants')
        .where('id', isEqualTo: userId)
        .snapshots()
        .asyncMap((event) =>
            event.docs.map((e) => Participants.fromMap(e.data())).toList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: StreamBuilder<List<Participants>>(
              stream: getParticipants(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final data = snapshot.data!.first;

                  if (data.role == 'admin') {
                    return ProductListScreen(docId: widget.docId, admin: true);
                  }
                  if(data.role == 'manager'){
                    return ProductListScreen(docId: widget.docId, admin: false);
                  }
                  if(data.role == 'aacountant'){
                    return AccountantScreen();
                  }
                }
                if (snapshot.hasError) {
                  return Text(snapshot.error.toString());
                }
                return CircularProgressIndicator();
              }),
        ),
      ),
    );
  }

// Stream<Participants> participants() async*{
//   FirebaseFirestore.instance.collection('warehouse').doc(widget.docId).collection('participants').where('field')
// }
}
