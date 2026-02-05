import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? get currentUser => _auth.currentUser;

  /// 🔹 Register
  Future<User?> register(
    String firstName,
    String email,
    String password,
  ) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;

      if (user != null) {
        // 🔹 1) خزّن الاسم في Firebase Auth
        await user.updateDisplayName(firstName);
        await user.reload();

        // 🔹 2) خزّن البيانات في Firestore
        await _firestore.collection('users').doc(user.uid).set({
          'firstName': firstName,
          'email': email,
          'uid': user.uid,
          'createdAt': FieldValue.serverTimestamp(),
        });
      }

      return _auth.currentUser;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    }
  }

  /// 🔹 Login
  Future<User?> login(String email, String password) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    }
  }

  /// 🔹 Get User Data from Firestore
  Future<Map<String, dynamic>?> getUserData() async {
    final user = _auth.currentUser;
    if (user == null) return null;

    final doc = await _firestore.collection('users').doc(user.uid).get();
    return doc.data();
  }

  Future<void> updateUserProfile({
    String? firstName,
    String? secondname,
    String? phoneNumber,
    String? profileImageUrl,
  }) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not logged in');

    final updateData = <String, dynamic>{};

    if (firstName != null && firstName.isNotEmpty) {
      updateData['firstName'] = firstName;
      await user.updateDisplayName(firstName);
    }
    if (secondname != null && secondname.isNotEmpty) {
      updateData['secondname'] = secondname;
    }
    if (phoneNumber != null && phoneNumber.isNotEmpty) {
      updateData['phoneNumber'] = phoneNumber;
    }
    if (profileImageUrl != null && profileImageUrl.isNotEmpty) {
      updateData['profileImageUrl'] = profileImageUrl;
    }

    if (updateData.isNotEmpty) {
      await _firestore.collection('users').doc(user.uid).update(updateData);
      await user.reload();
    }
  }

  /// 🔹 Logout
  Future<void> logout() async {
    await _auth.signOut();
  }
}
