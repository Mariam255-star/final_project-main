import 'package:final_project/core/constants/app_color.dart';
import 'package:final_project/core/utils/text_style.dart';
import 'package:final_project/models/pharmacy_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PharmacyDetailsScreen extends StatelessWidget {
  final Pharmacy pharmacy;

  const PharmacyDetailsScreen({
    super.key,
    required this.pharmacy,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whiteColor,

      /// 🟢 AppBar
      appBar: AppBar(
        backgroundColor: AppColor.primaryColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.pop(),
        ),
      ),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 170,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColor.primaryColor,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(25),
                ),
                boxShadow: const [
                  BoxShadow(color: Colors.black12, blurRadius: 8),
                ],
              ),
              child: Center(
                child: Image.network(
                  pharmacy.image,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.local_pharmacy,
                          size: 70, color: AppColor.primaryColor),
                ),
              ),
            ),

            const SizedBox(height: 12),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// 🏥 Pharmacy Name
                  Text(
                    pharmacy.name,
                    style: TextStyles.titleMedium(
                        color: AppColor.secondaryColor),
                  ),

                  const SizedBox(height: 4),

                  /// 📝 Subtitle
                  Text(
                    pharmacy.description ?? "Your Health Partner",
                    style: TextStyles.caption(color: Colors.grey),
                  ),

                  const SizedBox(height: 10),

                  /// 🚚 Delivery Info
                  Row(
                    children: [
                      const Icon(Icons.delivery_dining,
                          size: 18, color: Colors.grey),
                      const SizedBox(width: 6),
                      Text(
                        "Delivery: ${pharmacy.deliveryTime ?? '30 min'}",
                        style: TextStyles.caption(color: Colors.grey),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  /// 🎯 Exclusive Offers
                  Text(
                    "Exclusive Offers",
                    style: TextStyles.bodyLarge(
                        color: AppColor.secondaryColor),
                  ),

                  const SizedBox(height: 10),

                  SizedBox(
                    height: 120,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 2,
                      itemBuilder: (context, index) => _offerCard(),
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// 🧴 Products
                  Text(
                    "Products",
                    style: TextStyles.bodyLarge(
                        color: AppColor.secondaryColor),
                  ),

                  const SizedBox(height: 10),

                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 6,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 0.75,
                    ),
                    itemBuilder: (context, index) {
                      return _productCard();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 🎯 Offer Card
  Widget _offerCard() {
    return Container(
      width: 200,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xffE8F6F3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Winter Wellness",
                  style: TextStyles.bodyLarge(
                      color: AppColor.secondaryColor),
                ),
                const SizedBox(height: 4),
                Text(
                  "30% off",
                  style: TextStyles.caption(color: Colors.grey),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColor.primaryColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    "Shop now",
                    style: TextStyles.caption(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          Image.asset(
            'assets/medicines/cream_1.png',
            height: 60,
          ),
        ],
      ),
    );
  }

  /// 🧴 Product Card
  Widget _productCard() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColor.whiteColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 6),
        ],
      ),
      child: Column(
        children: [
          Expanded(
            child: Image.asset(
              'assets/medicines/cream_3.jpg',
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Medicine Name",
            style: TextStyles.body(),
          ),
          const SizedBox(height: 4),
          Text(
            "5.8\$",
            style: TextStyles.caption(color: AppColor.primaryColor),
          ),
        ],
      ),
    );
  }
}
