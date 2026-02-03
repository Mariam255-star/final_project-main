import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_color.dart';
import '../../../core/utils/text_style.dart';

class ProductDetailsScreen extends StatelessWidget {
  const ProductDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whiteColor,

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            context.pop();
          },
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 🟢 Product Image
            Center(
              child: Image.asset('assets/medicines/cream_3.jpg', height: 200),
            ),

            const SizedBox(height: 20),

            /// 🟢 Name
            Text(
              'Acnetop Ultra Foam Face Wash',
              style: TextStyles.titleSmall(),
            ),

            const SizedBox(height: 8),

            /// 🟢 Rating
            Text(
              '4.2 / 5 ★★★★☆',
              style: TextStyles.caption(color: Colors.grey),
            ),

            const SizedBox(height: 16),

            /// 🟢 Description
            Text('Description', style: TextStyles.subtitle()),
            const SizedBox(height: 8),
            Text(
              'Skin care product used to treat acne and reduce inflammation.',
              style: TextStyles.body(color: Colors.grey),
            ),

            const Spacer(),

            /// 🟢 Bottom Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total: 2.44\$', style: TextStyles.subtitle()),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  onPressed: () {
                    // TODO: Add to cart logic
                  },
                  child: Text(
                    'Add to cart',
                    style: TextStyles.button(color: AppColor.whiteColor),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
