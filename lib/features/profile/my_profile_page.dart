import 'package:flutter/material.dart';
import 'package:final_project/core/utils/text_style.dart';
import 'package:final_project/core/constants/app_color.dart';
import 'package:go_router/go_router.dart';
import 'package:final_project/services/profile/auth_profile_service.dart';

class MyProfilePage extends StatefulWidget {
  const MyProfilePage({super.key});

  @override
  State<MyProfilePage> createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {
  final AuthProfileService _authProfileService = AuthProfileService();

  Future<Map<String, dynamic>?> _getUserData() async {
    try {
      return await _authProfileService.getUserData();
    } catch (e) {
      _showSnackBar('Error fetching user data: $e');
      return null;
    }
  }

  Future<void> _logout() async {
    try {
      await _authProfileService.logout();
      if (mounted) {
        context.go('/login');
      }
    } catch (e) {
      _showSnackBar('Error logging out: $e');
    }
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _logout();
            },
            child: const Text('Logout', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      appBar: AppBar(
        title: const Text('My Profile'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/home'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => context.push('/edit-profile'),
          ),
        ],
      ),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: _getUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final userData = snapshot.data;
          final profileImageUrl = userData?['profileImageUrl'];
          final userName = userData?['firstName'] ?? 'User';

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                /// Profile Image
                CircleAvatar(
                  radius: 55,
                  backgroundImage:
                      profileImageUrl != null && profileImageUrl.isNotEmpty
                      ? NetworkImage(profileImageUrl) as ImageProvider
                      : const AssetImage('assets/images/profile.png'),
                ),
                const SizedBox(height: 16),

                /// User Name
                Text(userName, style: TextStyles.titleMedium()),
                const SizedBox(height: 12),

                /// Action Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _actionButton('Edit your Profile', () {
                      context.push('/edit-profile');
                    }),
                    const SizedBox(width: 10),
                    _actionButton('Share your profile', () {
                      _showSnackBar('Share feature coming soon');
                    }),
                  ],
                ),

                const SizedBox(height: 30),

                _profileItem('Favourites', Icons.favorite),
                _profileItem('Save in your bag', Icons.download),
                const Divider(),
                _profileItem('Location', Icons.location_on),
                GestureDetector(
                  onTap: _showLogoutDialog,
                  child: _profileItem('Logout', Icons.logout, isLogout: true),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _actionButton(String text, VoidCallback onTap) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xff7ADCC0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      child: Text(text),
    );
  }

  Widget _profileItem(String title, IconData icon, {bool isLogout = false}) {
    return ListTile(
      leading: Icon(icon, color: isLogout ? Colors.red : Colors.green),
      title: Text(
        title,
        style: TextStyles.body(color: isLogout ? Colors.red : Colors.black),
      ),
    );
  }
}
