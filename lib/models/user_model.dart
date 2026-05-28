import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String name;
  final String email;
  final String phone;
  final String address;
  final DateTime? createdAt;

  const UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
    this.createdAt,
  });

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};

    DateTime? createdDateTime;
    if (data['createdAt'] != null) {
      if (data['createdAt'] is Timestamp) {
        createdDateTime = (data['createdAt'] as Timestamp).toDate();
      } else if (data['createdAt'] is String) {
        createdDateTime = DateTime.tryParse(data['createdAt'] as String);
      }
    }

    return UserModel(
      uid: doc.id,
      name: data['name'] as String? ?? '',
      email: data['email'] as String? ?? '',
      phone: data['phone'] as String? ?? '',
      address: data['address'] as String? ?? '',
      createdAt: createdDateTime,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'address': address,
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : FieldValue.serverTimestamp(),
    };
  }
}
