import 'package:final_project/core/constants/app_color.dart';
import 'package:final_project/core/shared/widgets/main_layout.dart';
import 'package:final_project/core/utils/text_style.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  /// 🔹 Get user data from Firestore
  Future<Map<String, dynamic>?> getUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return null;

    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    if (!doc.exists) return null;
    return doc.data();
  }

  /// 🔹 Logout
  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
    if (mounted) {
      context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      currentIndex: 4, // Profile tab
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: AppColor.whiteColor,

        drawer: Drawer(
          backgroundColor: AppColor.primaryColor,
          child: FutureBuilder<Map<String, dynamic>?>(
            future: getUserData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                );
              }

              final firebaseUser =
                  FirebaseAuth.instance.currentUser;

              final data = snapshot.data;
              final firstName =
                  data?['firstName'] ??
                  firebaseUser?.displayName ??
                  'User';

              final email =
                  data?['email'] ??
                  firebaseUser?.email ??
                  '';

              return Column(
                children: [
                  const SizedBox(height: 60),
                  const CircleAvatar(
                    radius: 45,
                    backgroundImage:
                        AssetImage('assets/images/profile.png'),
                  ),
                  const SizedBox(height: 12),

                  Text(
                    'Welcome',
                    style: TextStyles.subtitle(
                      color: AppColor.whiteColor,
                    ),
                  ),

                  Text(
                    firstName,
                    style: TextStyles.body(
                      color: AppColor.whiteColor,
                    ),
                  ),

                  if (email.isNotEmpty)
                    Text(
                      email,
                      style: TextStyles.caption(
                        color:
                            AppColor.whiteColor.withOpacity(0.7),
                      ),
                    ),

                  const SizedBox(height: 40),

                  _drawerItem(
                    icon: Icons.person,
                    title: 'My Profile',
                    onTap: () => context.go('/my-profile'),
                  ),
                  _drawerItem(
                    icon: Icons.favorite,
                    title: 'Favorites',
                  ),
                  _drawerItem(
                    icon: Icons.settings,
                    title: 'Settings',
                  ),

                  const Spacer(),

                  _drawerItem(
                    icon: Icons.logout,
                    title: 'Logout',
                    isLogout: true,
                    onTap: logout,
                  ),
                  const SizedBox(height: 20),
                ],
              );
            },
          ),
        ),

        appBar: AppBar(
          backgroundColor: AppColor.primaryColor,
          elevation: 0,
          title: const Text("Profile"),
        ),

        body: const SizedBox(),
      ),
    );
  }

  Widget _drawerItem({
    required IconData icon,
    required String title,
    VoidCallback? onTap,
    bool isLogout = false,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: isLogout ? Colors.red : AppColor.whiteColor,
      ),
      title: Text(
        title,
        style: TextStyles.body(
          color: isLogout ? Colors.red : AppColor.whiteColor,
        ),
      ),
      onTap: onTap,
    );
  }
}
