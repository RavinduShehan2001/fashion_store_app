import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../models/product_model.dart';

class ProductService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Fetch all products from the Firestore "products" collection
  Future<List<ProductModel>> getProducts() async {
    final querySnapshot = await _db.collection('products').get();
    return querySnapshot.docs
        .map((doc) => ProductModel.fromFirestore(doc))
        .toList();
  }
}
