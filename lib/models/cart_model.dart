import 'package:cloud_firestore/cloud_firestore.dart';

class CartModel {
  final String productId;
  final String name;
  final double price;
  final String image;
  final int quantity;

  const CartModel({
    required this.productId,
    required this.name,
    required this.price,
    required this.image,
    required this.quantity,
  });

  factory CartModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    
    // Parse price safely as double
    var parsedPrice = 0.0;
    if (data['price'] != null) {
      if (data['price'] is num) {
        parsedPrice = (data['price'] as num).toDouble();
      } else {
        // String handling (e.g. remove "$" if present)
        var priceStr = data['price'].toString().replaceAll('\$', '');
        parsedPrice = double.tryParse(priceStr) ?? 0.0;
      }
    }

    return CartModel(
      productId: doc.id,
      name: data['name'] as String? ?? '',
      price: parsedPrice,
      image: data['image'] as String? ?? '',
      quantity: data['quantity'] as int? ?? 1,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'name': name,
      'price': price,
      'image': image,
      'quantity': quantity,
    };
  }

  factory CartModel.fromMap(Map<String, dynamic> map) {
    var parsedPrice = 0.0;
    if (map['price'] != null) {
      if (map['price'] is num) {
        parsedPrice = (map['price'] as num).toDouble();
      } else {
        var priceStr = map['price'].toString().replaceAll('\$', '');
        parsedPrice = double.tryParse(priceStr) ?? 0.0;
      }
    }

    return CartModel(
      productId: map['productId'] as String? ?? '',
      name: map['name'] as String? ?? '',
      price: parsedPrice,
      image: map['image'] as String? ?? '',
      quantity: map['quantity'] as int? ?? 1,
    );
  }
}
