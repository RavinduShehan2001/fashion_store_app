import 'package:cloud_firestore/cloud_firestore.dart';
import 'cart_model.dart';

class OrderModel {
  final String id;
  final String fullName;
  final String phone;
  final String address;
  final String city;
  final List<CartModel> items;
  final double total;
  final String status;
  final DateTime? createdAt;

  const OrderModel({
    required this.id,
    required this.fullName,
    required this.phone,
    required this.address,
    required this.city,
    required this.items,
    required this.total,
    required this.status,
    this.createdAt,
  });

  factory OrderModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};

    final rawItems = data['items'] as List<dynamic>? ?? [];
    final itemsList = rawItems.map((item) {
      return CartModel.fromMap(Map<String, dynamic>.from(item as Map));
    }).toList();

    DateTime? createdDateTime;
    if (data['createdAt'] != null) {
      if (data['createdAt'] is Timestamp) {
        createdDateTime = (data['createdAt'] as Timestamp).toDate();
      } else if (data['createdAt'] is String) {
        createdDateTime = DateTime.tryParse(data['createdAt'] as String);
      }
    }

    var parsedTotal = 0.0;
    if (data['total'] != null) {
      if (data['total'] is num) {
        parsedTotal = (data['total'] as num).toDouble();
      } else {
        parsedTotal = double.tryParse(data['total'].toString()) ?? 0.0;
      }
    }

    return OrderModel(
      id: doc.id,
      fullName: data['fullName'] as String? ?? '',
      phone: data['phone'] as String? ?? '',
      address: data['address'] as String? ?? '',
      city: data['city'] as String? ?? '',
      items: itemsList,
      total: parsedTotal,
      status: data['status'] as String? ?? 'Pending',
      createdAt: createdDateTime,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'fullName': fullName,
      'phone': phone,
      'address': address,
      'city': city,
      'items': items.map((item) => item.toMap()).toList(),
      'total': total,
      'status': status,
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : null,
    };
  }
}
