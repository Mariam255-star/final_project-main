import 'package:flutter/material.dart';
import 'package:final_project/core/constants/app_color.dart';
import 'package:final_project/core/utils/text_style.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project/services/product/product_cart_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  /// 🔹 Controllers
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  /// 🔹 States
  bool agree = false;
  bool obscurePassword = true;
  bool obscureConfirmPassword = true;
  bool loading = false;

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Image.asset(
            "assets/images/Rectangle 9 top.png",
            width: double.infinity,
            height: 250,
            fit: BoxFit.cover,
          ),

          Positioned(
            top: 80,
            left: 0,
            right: 0,
            child: Column(
              children: [
                CircleAvatar(
                  radius: 48,
                  backgroundColor: Colors.white,
                  child: Image.asset("assets/images/logo.png", width: 60),
                ),
                const SizedBox(height: 16),
                Text(
                  "Register",
                  style: TextStyles.titleLarge(color: Colors.black),
                ),
              ],
            ),
          ),

          SingleChildScrollView(
            padding: const EdgeInsets.only(top: 250),
            child: Column(
              children: [
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      _textField("First Name", controller: firstNameController),
                      const SizedBox(height: 16),
                      _textField("Last Name", controller: lastNameController),
                      const SizedBox(height: 16),
                      _textField("Email Address", controller: emailController),
                      const SizedBox(height: 16),
                      _passwordField(
                        "Password",
                        controller: passwordController,
                        obscure: obscurePassword,
                        onToggle: () {
                          setState(() {
                            obscurePassword = !obscurePassword;
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      _passwordField(
                        "Confirm Password",
                        controller: confirmPasswordController,
                        obscure: obscureConfirmPassword,
                        onToggle: () {
                          setState(() {
                            obscureConfirmPassword = !obscureConfirmPassword;
                          });
                        },
                      ),
                      const SizedBox(height: 12),

                      Row(
                        children: [
                          SizedBox(
                            width: 18,
                            height: 18,
                            child: Checkbox(
                              value: agree,
                              onChanged: (value) {
                                setState(() {
                                  agree = value ?? false;
                                });
                              },
                              activeColor: Colors.green,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              "Agree to our Terms & Condition",
                              style: TextStyles.caption(),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),
                      _mainButton(),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Image.asset(
                  "assets/images/Rectangle 20.png",
                  width: double.infinity,
                  height: 120,
                  fit: BoxFit.cover,
                ),
              ],
            ),
          ),

          Positioned(
            top: 0,
            left: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: GestureDetector(
                  onTap: () => context.go('/welcome'),
                  child: const CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.arrow_back_ios_new,
                      size: 18,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// ================= Widgets =================

  Widget _textField(String hint, {required TextEditingController controller}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyles.caption(),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.green),
        ),
      ),
    );
  }

  Widget _passwordField(
    String hint, {
    required TextEditingController controller,
    required bool obscure,
    required VoidCallback onToggle,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyles.caption(),
        suffixIcon: IconButton(
          icon: Icon(
            obscure ? Icons.visibility_off : Icons.visibility,
            size: 18,
          ),
          onPressed: onToggle,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.green),
        ),
      ),
    );
  }

  Widget _mainButton() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColor.primaryColor,
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(26),
          ),
        ),
        onPressed: agree && !loading ? _register : null,
        child: loading
            ? const CircularProgressIndicator(color: Colors.white)
            : Text("Sign Up", style: TextStyles.button(color: Colors.white)),
      ),
    );
  }

  /// 🔥 Register with Firebase
  Future<void> _register() async {
    final firstName = firstNameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    if (firstName.isEmpty || email.isEmpty || password.isEmpty) {
      _showMessage("Please fill all required fields");
      return;
    }

    if (password != confirmPassword) {
      _showMessage("Passwords do not match");
      return;
    }

    try {
      setState(() => loading = true);

      final auth = FirebaseAuth.instance;
      final firestore = FirebaseFirestore.instance;

      final userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await firestore.collection('users').doc(userCredential.user!.uid).set({
        'firstName': firstName,
        'lastName': lastNameController.text.trim(),
        'email': email,
        'uid': userCredential.user!.uid,
        'createdAt': FieldValue.serverTimestamp(),
      });

      /// ✅ Load user's cart from Firebase
      await ProductCartService.initializeCartFromFirebase();

      /// ✅ Navigate to home
      context.go('/home');
    } on FirebaseAuthException catch (e) {
      _showMessage(e.message ?? "Register failed");
    } finally {
      setState(() => loading = false);
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}
