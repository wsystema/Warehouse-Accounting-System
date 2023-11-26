import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../model/participants.dart';

class ParticipantsListScreen extends StatefulWidget {
  const ParticipantsListScreen({super.key, required this.docId});

  final String docId;

  @override
  State<ParticipantsListScreen> createState() => _ParticipantsListScreenState();
}

class _ParticipantsListScreenState extends State<ParticipantsListScreen> {
  Stream<List<ParticipantsFromMap>> listStream() async* {
    yield* FirebaseFirestore.instance
        .collection('warehouse')
        .doc(widget.docId)
        .collection('participants')
        .snapshots()
        .asyncMap((event) => event.docs
            .map((e) => ParticipantsFromMap.fromMap(e.data(), e.id))
            .toList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.accessToAccounting),
      ),
      body: SafeArea(
        child: Center(
          child: StreamBuilder<List<ParticipantsFromMap>>(
              stream: listStream(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        final data = snapshot.data![index];
                        return ListTile(
                          title: Text(data.name),
                          subtitle: Text(data.role),
                          trailing: data.isActive
                              ? IconButton(
                                  onPressed: () {
                                    print(data.isActive.toString());
                                  },
                                  icon: Icon(Icons.delete))
                              : IconButton(
                                  onPressed: () =>
                                      addMember(data.docId, data.id),
                                  icon: Icon(Icons.add)),
                        );
                      });
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

  Future<void> addMember(String participantsDocID, String userId) async {
    await FirebaseFirestore.instance
        .collection('warehouse')
        .doc(widget.docId)
        .collection('participants')
        .doc(participantsDocID)
        .update({'isActive': true}).then((value) async {
      await addUserWarehouse(userId);
      showUserAdded();
    });
  }

  Future<void> addUserWarehouse(String userId) async {
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection('warehouse').doc(widget.docId);

    await documentReference.update({
      'membersId': FieldValue.arrayUnion([userId.toString()])
    });
  }

  void showUserAdded() {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.userAdded)));
  }
}
