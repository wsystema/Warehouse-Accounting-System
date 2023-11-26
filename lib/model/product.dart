class Product {
  final String name;
  final String description;
  final String sender;
  final String id;
  final List<String> images;
  final int numberOfUnits;
  final int price;

  Product(
      {required this.name,
      required this.description,
      required this.sender,
      required this.id,
      required this.images,
      required this.numberOfUnits,
      required this.price});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'sender': sender,
      'id': id,
      'images': images,
      'numberOfUnits': numberOfUnits,
      'price': price
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
        name: map['name'] as String,
        description: map['description'] as String,
        sender: map['sender'] as String,
        id: map['id'] as String,
        images:
            (map['images'] as List<dynamic>).map((e) => e as String).toList(),
        numberOfUnits: map['numberOfUnits'] as int,
        price: map['price'] as int);
  }
}

class ProductFromMap {
  final String name;
  final String description;
  final String sender;
  final String id;
  final List<String> images;
  final int numberOfUnits;
  final String docId;
  final int price;

  ProductFromMap(
      {required this.name,
      required this.description,
      required this.sender,
      required this.id,
      required this.images,
      required this.numberOfUnits,
      required this.docId,
      required this.price});

  factory ProductFromMap.fromMap(Map<String, dynamic> map, String docId) {
    return ProductFromMap(
        name: map['name'] as String,
        description: map['description'] as String,
        sender: map['sender'] as String,
        id: map['id'] as String,
        images:
            (map['images'] as List<dynamic>).map((e) => e as String).toList(),
        numberOfUnits: map['numberOfUnits'] as int,
        docId: docId,
        price: map['price'] as int);
  }
}
