import 'package:final_project/core/routes/navigation.dart';
import 'package:flutter/material.dart';
import 'package:final_project/core/constants/app_color.dart';
import 'package:final_project/core/utils/text_style.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),

              /// 🔹 Logo
              Image.asset(
                'assets/images/logo.png',
                width: 300,
                height: 350,
                fit: BoxFit.contain,
              ),

              const SizedBox(height: 16),

              const SizedBox(height: 40),

              /// 🔹 Welcome Text
              Text("Welcome to MidLink", style: TextStyles.titleMedium()),

              const SizedBox(height: 32),

              /// 🔹 Register Button
              InkWell(
                onTap: () {
                  pushTo(context, '/register');
                },
                child: Container(
                  width: double.infinity,
                  height: 50,
                  decoration: BoxDecoration(
                    color: AppColor.primaryColor,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Center(
                    child: Text(
                      "Register",
                      style: TextStyles.button(color: AppColor.whiteColor),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              /// 🔹 Login Button
              InkWell(
                onTap: () {
                  pushTo(context, '/login'); // ✅ صح
                },
                child: Container(
                  width: double.infinity,
                  height: 50,
                  decoration: BoxDecoration(
                    color: AppColor.secondaryColor,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Center(
                    child: Text(
                      "Login",
                      style: TextStyles.button(color: AppColor.whiteColor),
                    ),
                  ),
                ),
              ),

              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
