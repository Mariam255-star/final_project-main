import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class ProfileService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final ImagePicker _imagePicker = ImagePicker();

  Future<Map<String, dynamic>?> loadUserProfileData() async {
    final user = _auth.currentUser;
    if (user == null) return null;

    try {
      final doc = await _firestore.collection('users').doc(user.uid).get();
      if (doc.exists) {
        return doc.data() as Map<String, dynamic>;
      }
      return null;
    } catch (e) {
      throw Exception('Error loading profile data: $e');
    }
  }

  Future<File?> pickImageFromCamera() async {
    try {
      final pickedFile = await _imagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        return File(pickedFile.path);
      }
      return null;
    } catch (e) {
      throw Exception('Error taking photo: $e');
    }
  }

  Future<File?> pickImageFromGallery() async {
    try {
      final pickedFile = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        return File(pickedFile.path);
      }
      return null;
    } catch (e) {
      throw Exception('Error picking image: $e');
    }
  }

  Future<String?> uploadProfileImage(File image) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw Exception('User not logged in');
      }

      print('🔵 Starting upload for user: ${user.uid}');
      print('📄 File size: ${image.lengthSync()} bytes');

      final fileName =
          'profile_images/${user.uid}_${DateTime.now().millisecondsSinceEpoch}.jpg';
      print('📝 File name: $fileName');

      final Reference ref = _storage.ref(fileName);
      final UploadTask uploadTask = ref.putFile(
        image,
        SettableMetadata(contentType: 'image/jpeg'),
      );

      uploadTask.snapshotEvents.listen(
        (TaskSnapshot snapshot) {
          final progress =
              (snapshot.bytesTransferred / snapshot.totalBytes) * 100;
          print('⏳ Upload progress: ${progress.toStringAsFixed(0)}%');
        },
        onError: (e) {
          print('❌ Upload stream error: $e');
        },
      );

      final TaskSnapshot snapshot = await uploadTask;
      final String downloadUrl = await snapshot.ref.getDownloadURL();
      print('✅ Upload successful! URL: $downloadUrl');
      return downloadUrl;
    } catch (e) {
      print('❌ Firebase Storage Error: $e');
      print('📋 Error type: ${e.runtimeType}');
      rethrow;
    }
  }

  Future<void> updateUserProfile({
    String? firstName,
    String? secondname,
    String? phoneNumber,
    String? profileImageUrl,
  }) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not logged in');

    try {
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
        updateData['updatedAt'] = FieldValue.serverTimestamp();
        await _firestore.collection('users').doc(user.uid).update(updateData);
        await user.reload();
      }
    } catch (e) {
      throw Exception('Error updating profile: $e');
    }
  }

  Stream<Map<String, dynamic>?> getUserProfileStream() {
    final user = _auth.currentUser;
    if (user == null) {
      return Stream.value(null);
    }

    return _firestore.collection('users').doc(user.uid).snapshots().map((doc) {
      if (!doc.exists) return null;
      return doc.data();
    });
  }
}
