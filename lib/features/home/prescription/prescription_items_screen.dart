import 'package:final_project/core/shared/widgets/main_layout.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:final_project/core/constants/app_color.dart';
import 'package:final_project/core/utils/text_style.dart';

class PrescriptionItemsScreen extends StatelessWidget {
  const PrescriptionItemsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      currentIndex: 0, // 👈 Home
      child: Scaffold(
        backgroundColor: AppColor.whiteColor,

        /// 🟢 AppBar
        appBar: AppBar(
          backgroundColor: AppColor.primaryColor,
          elevation: 0,

          /// 🔙 Back Arrow
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              context.go('/scan-prescription');
            },
          ),

          title: Text(
            'Your Prescription',
            style: TextStyles.subtitle(color: AppColor.whiteColor),
          ),
          centerTitle: true,
        ),

        /// 🟢 Body
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: GridView.builder(
            itemCount: 6,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.75,
            ),
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  context.push('/product-details');
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColor.whiteColor,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 6,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 10),

                      /// 🟢 Product Image
                      Image.asset('assets/medicines/cream_3.jpg', height: 90),

                      const SizedBox(height: 10),

                      /// 🟢 Product Name
                      Text(
                        'Medicine name',
                        style: TextStyles.body(),
                        textAlign: TextAlign.center,
                      ),

                      const Spacer(),

                      /// 🟢 Button
                      Container(
                        margin: const EdgeInsets.all(10),
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColor.primaryColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Center(
                          child: Text(
                            'Add',
                            style: TextStyles.button(
                              color: AppColor.whiteColor,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
