import 'package:flutter/material.dart';
import 'package:final_project/core/utils/text_style.dart';
import 'package:final_project/core/constants/app_color.dart';
import 'package:go_router/go_router.dart';
import 'package:final_project/services/profile/profile_service.dart';
import 'dart:io';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final ProfileService _profileService = ProfileService();

  late TextEditingController _nameController;
  late TextEditingController _secondNameController;
  late TextEditingController _phoneController;

  File? _selectedImage;
  String? _profileImageUrl;
  bool _isLoading = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _secondNameController = TextEditingController();
    _phoneController = TextEditingController();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    setState(() => _isLoading = true);
    try {
      final data = await _profileService.loadUserProfileData();
      if (data != null && mounted) {
        setState(() {
          _nameController.text = data['firstName'] ?? '';
          _secondNameController.text = data['secondname'] ?? '';
          _phoneController.text = data['phoneNumber'] ?? '';
          _profileImageUrl = data['profileImageUrl'];
        });
      }
    } catch (e) {
      _showSnackBar('Error loading data: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _pickImageFromGallery() async {
    try {
      final image = await _profileService.pickImageFromGallery();
      if (image != null && mounted) {
        setState(() {
          _selectedImage = image;
        });
      }
    } catch (e) {
      _showSnackBar('$e');
    }
  }

  Future<void> _pickImageFromCamera() async {
    try {
      final image = await _profileService.pickImageFromCamera();
      if (image != null && mounted) {
        setState(() {
          _selectedImage = image;
        });
      }
    } catch (e) {
      _showSnackBar('$e');
    }
  }

  Future<void> _saveProfile() async {
    setState(() => _isSaving = true);
    try {
      String? imageUrl = _profileImageUrl;

      if (_selectedImage != null) {
        try {
          print('🔧 Attempting to upload image...');
          imageUrl = await _profileService.uploadProfileImage(_selectedImage!);
          print('🟢 Image uploaded successfully: $imageUrl');
          if (mounted) {
            setState(() {
              _profileImageUrl = imageUrl;
              _selectedImage = null;
            });
          }
        } catch (uploadError) {
          print('🔴 Image upload failed: $uploadError');
          if (mounted) {
            _showSnackBar('⚠️ Image upload failed, but profile will be saved');
          }
        }
      }

      print('💾 Saving profile to Firestore...');
      await _profileService.updateUserProfile(
        firstName: _nameController.text.trim(),
        secondname: _secondNameController.text.trim(),
        phoneNumber: _phoneController.text.trim(),
        profileImageUrl: imageUrl,
      );

      if (mounted) {
        _showSnackBar('✅ Profile updated successfully!');
        print('✅ Profile saved successfully!');
        Future.delayed(const Duration(seconds: 1), () {
          if (mounted) {
            context.pop();
          }
        });
      }
    } catch (e) {
      print('🔴 Error saving profile: $e');
      if (mounted) {
        _showSnackBar('❌ Error saving profile: $e');
      }
    } finally {
      setState(() => _isSaving = false);
    }
  }

  void _showImagePickerBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(
                Icons.camera_alt,
                color: AppColor.primaryColor,
              ),
              title: const Text('Take a Photo'),
              onTap: () {
                Navigator.pop(context);
                _pickImageFromCamera();
              },
            ),
            ListTile(
              leading: const Icon(Icons.image, color: AppColor.primaryColor),
              title: const Text('Pick from Gallery'),
              onTap: () {
                Navigator.pop(context);
                _pickImageFromGallery();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 2)),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _secondNameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      appBar: AppBar(
        title: const Text('Edit Profile'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: _isSaving
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.check_circle, color: Colors.green),
            onPressed: _isSaving ? null : _saveProfile,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// 🟢 Profile Image
                    Center(
                      child: Stack(
                        children: [
                          CircleAvatar(
                            radius: 55,
                            backgroundImage: _selectedImage != null
                                ? FileImage(_selectedImage!) as ImageProvider
                                : (_profileImageUrl != null &&
                                          _profileImageUrl!.isNotEmpty
                                      ? NetworkImage(_profileImageUrl!)
                                            as ImageProvider
                                      : const AssetImage(
                                              'assets/images/profile.png',
                                            )
                                            as ImageProvider),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: GestureDetector(
                              onTap: _showImagePickerBottomSheet,
                              child: CircleAvatar(
                                radius: 16,
                                backgroundColor: AppColor.primaryColor,
                                child: const Icon(
                                  Icons.camera_alt,
                                  size: 18,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),

                    /// 🟢 Title
                    Text('Your Info', style: TextStyles.titleSmall()),
                    const SizedBox(height: 12),

                    /// Name Field
                    _textField(hint: 'Name', controller: _nameController),

                    /// Second Name Field
                    _textField(
                      hint: 'Second Name',
                      controller: _secondNameController,
                    ),

                    /// Phone Number Field
                    _textField(
                      hint: 'Phone Number',
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _textField({
    required String hint,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyles.caption(color: Colors.grey),
          filled: true,
          fillColor: const Color(0xffF7F7F7),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
