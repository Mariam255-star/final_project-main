import 'package:flutter/material.dart';
import 'package:final_project/core/constants/app_color.dart';
import 'package:final_project/core/utils/text_style.dart';
import 'package:go_router/go_router.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:final_project/services/product/product_cart_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  /// 🔹 Controllers
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  /// 🔹 States
  bool rememberMe = false;
  bool isLoading = false;
  bool obscurePassword = true;

  /// 🔥 Login with Firebase
  Future<void> _login() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showMessage("Please fill all fields");
      return;
    }

    if (password.length < 6) {
      _showMessage("Password must be at least 6 characters");
      return;
    }

    try {
      setState(() => isLoading = true);

      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (!mounted) return;

      /// ✅ Load user's cart from Firebase
      await ProductCartService.initializeCartFromFirebase();

      /// ✅ Success - Navigate to home
      context.go('/home');
    } on FirebaseAuthException catch (e) {
      _showMessage(e.message ?? "Login failed");
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  void _showMessage(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      body: Stack(
        children: [
          Image.asset(
            "assets/images/Rectangle 9 top.png",
            width: double.infinity,
            height: 300,
            fit: BoxFit.cover,
          ),

          SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 200),

                CircleAvatar(
                  radius: 48,
                  child: Image.asset("assets/images/Group 3.png", width: 55),
                ),

                const SizedBox(height: 24),

                Text(
                  "Login",
                  style: TextStyles.titleLarge(color: AppColor.secondaryColor),
                ),

                const SizedBox(height: 30),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      _textField("Email", controller: emailController),
                      const SizedBox(height: 16),
                      _textField(
                        "Password",
                        controller: passwordController,
                        isPassword: true,
                      ),

                      const SizedBox(height: 12),

                      Row(
                        children: [
                          SizedBox(
                            width: 18,
                            height: 18,
                            child: Checkbox(
                              value: rememberMe,
                              onChanged: (value) {
                                setState(() => rememberMe = value ?? false);
                              },
                              activeColor: AppColor.primaryColor,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text("Remember Me", style: TextStyles.caption()),
                          const Spacer(),
                          InkWell(
                            onTap: () {
                              context.push('/forget-password');
                            },
                            child: Text(
                              "Forgot Password?",
                              style: TextStyles.caption(
                                color: AppColor.primaryColor,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 22),

                      /// 🔹 Login Button
                      _mainButton(),

                      const SizedBox(height: 24),

                      Text("OR", style: TextStyles.caption()),

                      const SizedBox(height: 18),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          _SocialIcon(
                            icon: FontAwesomeIcons.google,
                            color: Colors.red,
                          ),
                          SizedBox(width: 18),
                          _SocialIcon(
                            icon: FontAwesomeIcons.facebookF,
                            color: Color(0xFF1877F2),
                          ),
                          SizedBox(width: 18),
                          _SocialIcon(
                            icon: FontAwesomeIcons.apple,
                            color: Colors.black,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                Image.asset(
                  "assets/images/Rectangle 12.png",
                  width: double.infinity,
                  height: 140,
                  fit: BoxFit.cover,
                ),
              ],
            ),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: GestureDetector(
                onTap: () => context.pop(),
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
        ],
      ),
    );
  }

  /// ================= Widgets =================

  Widget _textField(
    String hint, {
    required TextEditingController controller,
    bool isPassword = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword ? obscurePassword : false,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyles.caption(),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  obscurePassword ? Icons.visibility_off : Icons.visibility,
                  size: 18,
                ),
                onPressed: () {
                  setState(() => obscurePassword = !obscurePassword);
                },
              )
            : null,
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
          borderSide: BorderSide(color: AppColor.primaryColor),
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
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(26),
          ),
        ),
        onPressed: isLoading ? null : _login,
        child: isLoading
            ? const CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              )
            : Text("Login In", style: TextStyles.button(color: Colors.white)),
      ),
    );
  }
}

/// 🔹 Social Icon Widget
class _SocialIcon extends StatelessWidget {
  final IconData icon;
  final Color color;

  const _SocialIcon({required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        shape: BoxShape.circle,
      ),
      child: Center(child: FaIcon(icon, size: 20, color: color)),
    );
  }
}
