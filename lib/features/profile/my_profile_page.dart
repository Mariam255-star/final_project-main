import 'package:flutter/material.dart';
import 'package:final_project/core/utils/text_style.dart';
import 'package:final_project/core/constants/app_color.dart';
import 'package:go_router/go_router.dart';

class MyProfilePage extends StatelessWidget {
  const MyProfilePage({super.key});

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
          IconButton(icon: const Icon(Icons.settings), onPressed: () {}),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 55,
              backgroundImage: AssetImage('assets/images/profile.png'),
            ),
            const SizedBox(height: 16),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _actionButton('Edit your Profile', () {
                  context.push('/edit-profile');
                }),
                const SizedBox(width: 10),
                _actionButton('Share your profile', () {}),
              ],
            ),

            const SizedBox(height: 30),

            _profileItem('Favourites', Icons.favorite),
            _profileItem('Save in your bag', Icons.download),
            const Divider(),
            _profileItem('Location', Icons.location_on),
            _profileItem('Logout', Icons.logout, isLogout: true),
          ],
        ),
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
