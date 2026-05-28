import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {
  final String id;
  final String name;
  final String price;
  final String image;
  final String description;
  final String category;

  const ProductModel({
    required this.id,
    required this.name,
    required this.price,
    required this.image,
    required this.description,
    required this.category,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      price: json['price']?.toString() ?? '',
      image: json['image'] as String? ?? '',
      description: json['description'] as String? ?? '',
      category: json['category'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'image': image,
      'description': description,
      'category': category,
    };
  }

  factory ProductModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    
    // Parse price safely. If price is a number like 25, we format it as "$25".
    // If it already has "$", we use it as is.
    var parsedPrice = data['price']?.toString() ?? '0';
    if (!parsedPrice.startsWith('\$') && parsedPrice.isNotEmpty) {
      parsedPrice = '\$$parsedPrice';
    }

    return ProductModel(
      id: doc.id,
      name: data['name'] as String? ?? '',
      price: parsedPrice,
      image: data['image'] as String? ?? '',
      description: data['description'] as String? ?? '',
      category: data['category'] as String? ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'price': price,
      'image': image,
      'description': description,
      'category': category,
    };
  }
}
