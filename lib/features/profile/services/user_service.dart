import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../models/user_model.dart';

class UserService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? get currentUid => _auth.currentUser?.uid;

  DocumentReference<Map<String, dynamic>>? get _userDocRef {
    final uid = currentUid;
    if (uid == null) return null;
    return _db.collection('users').doc(uid);
  }

  Future<void> createUserProfile({
    required String uid,
    required String name,
    required String email,
    String phone = '',
    String address = '',
  }) async {
    final docRef = _db.collection('users').doc(uid);
    final user = UserModel(
      uid: uid,
      name: name,
      email: email,
      phone: phone,
      address: address,
      createdAt: DateTime.now(),
    );
    await docRef.set(user.toMap());
  }

  Stream<UserModel?> streamUserProfile() {
    final ref = _userDocRef;
    if (ref == null) return Stream.value(null);

    return ref.snapshots().map((snapshot) {
      if (!snapshot.exists) return null;
      return UserModel.fromFirestore(snapshot);
    });
  }

  Future<UserModel?> getUserProfile() async {
    final ref = _userDocRef;
    if (ref == null) return null;

    final snapshot = await ref.get();
    if (!snapshot.exists) return null;
    return UserModel.fromFirestore(snapshot);
  }

  Future<void> updateUserProfile({
    required String name,
    required String phone,
    required String address,
  }) async {
    final ref = _userDocRef;
    if (ref == null) throw Exception('User not logged in');

    final snapshot = await ref.get();
    if (snapshot.exists) {
      await ref.update({
        'name': name,
        'phone': phone,
        'address': address,
      });
    } else {
      // If user registered before Firestore integration was added
      final currentUser = _auth.currentUser;
      await ref.set({
        'name': name,
        'email': currentUser?.email ?? '',
        'phone': phone,
        'address': address,
        'createdAt': FieldValue.serverTimestamp(),
      });
    }

    await _auth.currentUser?.updateDisplayName(name);
  }
}
