import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../models/order_model.dart';
import '../../cart/services/cart_service.dart';

class OrderService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? get userId => _auth.currentUser?.uid;

  CollectionReference<Map<String, dynamic>>? get _ordersRef {
    final uid = userId;
    if (uid == null) return null;
    return _db.collection('users').doc(uid).collection('orders');
  }

  Future<void> placeOrder({
    required String fullName,
    required String phone,
    required String address,
    required String city,
  }) async {
    final uid = userId;
    if (uid == null) throw Exception('User not logged in');

    final cartService = CartService();
    final cartItems = await cartService.getCartItems();

    if (cartItems.isEmpty) {
      throw Exception('Your cart is empty');
    }

    double total = 0.0;
    for (var item in cartItems) {
      total += item.price * item.quantity;
    }

    final ref = _ordersRef;
    if (ref == null) throw Exception('Could not access order reference');

    final orderDocRef = ref.doc();
    final orderData = {
      'fullName': fullName,
      'phone': phone,
      'address': address,
      'city': city,
      'items': cartItems.map((item) => item.toMap()).toList(),
      'total': total,
      'status': 'Pending',
      'createdAt': FieldValue.serverTimestamp(),
    };

    await orderDocRef.set(orderData);
    await cartService.clearCart();
  }

  Stream<List<OrderModel>> streamOrders() {
    final ref = _ordersRef;
    if (ref == null) return const Stream.empty();

    return ref
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) => OrderModel.fromFirestore(doc)).toList();
        });
  }
}
