import 'package:cloud_firestore/cloud_firestore.dart';

class Warehouse {
  Warehouse(
      {required this.id,
      required this.name,
      required this.description,
      required this.address,
      required this.membersId,
      });

  final String id;
  final String name;
  final String description;
  final String address;
  final List<String> membersId;


  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'address': address,
      'membersId': membersId,

    };
  }

  factory Warehouse.fromMap(Map<String, dynamic> data) {
    // final data = snapshot.data()!;
    return Warehouse(
        membersId: (data['membersId'] as List<dynamic>)
            .map((e) => e as String)
            .toList(),
        id: data['id'],
        name: data['name'],
        description: data['name'],
        address: data['address'],
       );
  }
}

class WarehouseFromMap {
  WarehouseFromMap(
      {required this.id,
      required this.name,
      required this.description,
      required this.address,
      required this.membersId,

      required this.docId});

  final String id;
  final String name;
  final String description;
  final String address;
  final List<String> membersId;

  final String docId;

  factory WarehouseFromMap.fromMap(Map<String, dynamic> data, String docId) {
    // final data = snapshot.data()!;
    return WarehouseFromMap(
        membersId: (data['membersId'] as List<dynamic>)
            .map((e) => e as String)
            .toList(),
        id: data['id'],
        name: data['name'],
        description: data['name'],
        address: data['address'],
        docId: docId,
       );
  }
}
