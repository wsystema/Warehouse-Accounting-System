class Participants {
  Participants(
      {required this.id,
      required this.name,
      required this.role,
      required this.isActive});

  bool isActive;
  String id;
  String name;
  String role;

  Map<String, dynamic> toMap() {
    return {'id': id, 'isActive': isActive, 'name': name, 'role': role};
  }

  factory Participants.fromMap(Map<String, dynamic> map) {
    return Participants(
        id: map['id'],
        name: map['name'],
        role: map['role'],
        isActive: map['isActive']);
  }
}

class ParticipantsFromMap {
  ParticipantsFromMap(
      {required this.id,
      required this.name,
      required this.role,
      required this.isActive,
      required this.docId});

  bool isActive;
  String id;
  String name;
  String role;
  String docId;

  factory ParticipantsFromMap.fromMap(Map<String, dynamic> map, String docId) {
    return ParticipantsFromMap(
        id: map['id'],
        name: map['name'],
        role: map['role'],
        isActive: map['isActive'],
        docId: docId);
  }
}
