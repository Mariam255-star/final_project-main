import 'package:final_project/core/constants/app_color.dart';
import 'package:final_project/core/utils/text_style.dart';
import 'package:final_project/core/widgets/custom_bottom_nav.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PharmaScreen extends StatelessWidget {
  const PharmaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whiteColor,

      /// 🟢 BODY
      body: Column(
        children: [
          /// 🔹 TOP IMAGE (بدل AppBar)
          Stack(
            children: [
              Image.asset(
                'assets/images/navbar.png',
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
              ),

              Positioned(
                top: 45,
                left: 16,
                child: IconButton(
                  icon: const Icon(
                    Icons.arrow_back,
                    color: AppColor.whiteColor,
                  ),
                  onPressed: () => context.go('/home'),
                ),
              ),

              Positioned(
                top: 50,
                left: 70,
                child: Text(
                  'Pharma',
                  style: TextStyles.titleMedium(color: AppColor.whiteColor),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          /// 🔍 Search
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search pharmacy',
                hintStyle: TextStyles.caption(color: Colors.grey),
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          /// 🏥 Pharmacies Grid
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GridView.builder(
                itemCount: 9,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemBuilder: (context, index) {
                  return Container(
                    decoration: const BoxDecoration(
                      color: AppColor.secondaryColor,
                      shape: BoxShape.circle,
                    ),
                    padding: const EdgeInsets.all(14),
                    child: Image.asset(
                      'assets/images/Elazapy.png',
                      fit: BoxFit.contain,
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),

      /// 🟢 Bottom Navigation (موحد)
      // bottomNavigationBar: const CustomBottomNav(currentIndex: 1),
    );
  }
}
