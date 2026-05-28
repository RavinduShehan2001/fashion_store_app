import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../models/cart_model.dart';
import '../../../models/product_model.dart';

class CartService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get active user ID
  String? get userId => _auth.currentUser?.uid;

  // Get reference to the user's cart subcollection
  CollectionReference<Map<String, dynamic>>? get _cartRef {
    final uid = userId;
    if (uid == null) return null;
    return _db.collection('users').doc(uid).collection('cart');
  }

  // Stream cart items for real-time updates
  Stream<List<CartModel>> streamCartItems() {
    final ref = _cartRef;
    if (ref == null) return const Stream.empty();
    return ref.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => CartModel.fromFirestore(doc)).toList();
    });
  }

  // Add a product to the cart
  Future<void> addToCart(ProductModel product) async {
    final ref = _cartRef;
    if (ref == null) throw Exception('User not logged in');

    final docRef = ref.doc(product.id);
    final docSnapshot = await docRef.get();

    if (docSnapshot.exists) {
      // If product already in cart, increment quantity
      final currentQty = docSnapshot.data()?['quantity'] as int? ?? 1;
      await docRef.update({'quantity': currentQty + 1});
    } else {
      // If product not in cart, parse price and create new item with quantity 1
      var cleanPrice = product.price.replaceAll('\$', '');
      var priceDouble = double.tryParse(cleanPrice) ?? 0.0;

      final cartItem = CartModel(
        productId: product.id,
        name: product.name,
        price: priceDouble,
        image: product.image,
        quantity: 1,
      );
      await docRef.set(cartItem.toMap());
    }
  }

  // Update product quantity (increase/decrease)
  Future<void> updateQuantity(String productId, int change) async {
    final ref = _cartRef;
    if (ref == null) throw Exception('User not logged in');

    final docRef = ref.doc(productId);
    final docSnapshot = await docRef.get();

    if (docSnapshot.exists) {
      final currentQty = docSnapshot.data()?['quantity'] as int? ?? 1;
      final newQty = currentQty + change;

      if (newQty <= 0) {
        // If quantity is 0 or less, remove item from cart
        await docRef.delete();
      } else {
        await docRef.update({'quantity': newQty});
      }
    }
  }

  // Remove a product completely from the cart
  Future<void> removeFromCart(String productId) async {
    final ref = _cartRef;
    if (ref == null) throw Exception('User not logged in');
    await ref.doc(productId).delete();
  }

  // Get all cart items in a single future fetch
  Future<List<CartModel>> getCartItems() async {
    final ref = _cartRef;
    if (ref == null) return [];
    final snapshot = await ref.get();
    return snapshot.docs.map((doc) => CartModel.fromFirestore(doc)).toList();
  }

  // Clear the entire cart subcollection atomically
  Future<void> clearCart() async {
    final ref = _cartRef;
    if (ref == null) throw Exception('User not logged in');
    final snapshot = await ref.get();
    if (snapshot.docs.isEmpty) return;

    final batch = _db.batch();
    for (var doc in snapshot.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();
  }
}
