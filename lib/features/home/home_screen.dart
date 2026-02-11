import 'package:final_project/core/constants/app_color.dart';
import 'package:final_project/core/utils/text_style.dart';
import 'package:final_project/models/product_model.dart';
import 'package:final_project/services/product_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  Stream<String> _getFirstNameStream() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return Stream.value('User');
    }

    return FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .snapshots()
        .map((doc) {
          if (!doc.exists) return 'User';
          return doc.data()?['firstName'] ?? 'User';
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      body: Column(
        children: [
          /// 🔹 Header
          Container(
            height: 200,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 40),
            decoration: const BoxDecoration(
              color: AppColor.primaryColor,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: StreamBuilder<String>(
              stream: _getFirstNameStream(),
              builder: (context, snapshot) {
                final name = snapshot.connectionState == ConnectionState.active
                    ? snapshot.data ?? 'User'
                    : 'User';

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Hello, $name",
                          style: TextStyles.titleMedium(
                            color: AppColor.whiteColor,
                          ),
                        ),
                        InkWell(
                          onTap: () => context.go('/notifications'),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(
                              color: AppColor.whiteColor,
                              shape: BoxShape.circle,
                            ),
                            child: Image.asset(
                              'assets/images/Bell.png',
                              width: 24,
                              height: 24,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    /// Upload Prescription
                    InkWell(
                      borderRadius: BorderRadius.circular(30),
                      onTap: () {
                        context.go('/scan-prescription');
                      },
                      child: Container(
                        height: 50,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: AppColor.whiteColor,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                "Upload your Prescription",
                                style: TextStyles.body(color: Colors.grey),
                              ),
                            ),
                            Image.asset(
                              'assets/images/uploadprecipes.png',
                              width: 24,
                              height: 24,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),

          const SizedBox(height: 16),

          /// 🔹 Search
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              height: 50,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      "Search for medicine, pharmacy...",
                      style: TextStyles.body(color: Colors.grey),
                    ),
                  ),
                  const Icon(Icons.search, color: Colors.grey),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          /// 🔹 Categories
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Top Categories", style: TextStyles.titleSmall()),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _categoryItem(
                      context,
                      "Our pharm",
                      'assets/images/Our Pharme.png',
                      '/our-pharm',
                    ),
                    _categoryItem(
                      context,
                      "Hair care",
                      'assets/images/Hair Care.png',
                      '/hair-care',
                    ),
                    _categoryItem(
                      context,
                      "Skin Care",
                      'assets/images/Skin Care.png',
                      '/skin-care',
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          /// 🔹 Offers
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Exclusive Offers", style: TextStyles.titleSmall()),
                  const SizedBox(height: 12),
                  FutureBuilder<List<Product>>(
                    future: ProductService.getProducts(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      if (snapshot.hasError) {
                        return Center(
                          child: Text(
                            'Error: ${snapshot.error}',
                            style: TextStyles.caption(color: Colors.red),
                          ),
                        );
                      }

                      final products = snapshot.data ?? [];
                      if (products.isEmpty) {
                        return Text(
                          'No offers available',
                          style: TextStyles.caption(color: Colors.grey),
                        );
                      }

                      final offers = products.take(2).toList();

                      return Column(
                        children: [
                          _offerItem(context, offers[0]),
                          if (offers.length > 1) ...[
                            const SizedBox(height: 12),
                            _offerItem(context, offers[1]),
                          ],
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        
        ],
      ),
    );
  }

  /// 🔹 Category Item
  Widget _categoryItem(
    BuildContext context,
    String title,
    String imagePath,
    String route,
  ) {
    return InkWell(
      borderRadius: BorderRadius.circular(40),
      onTap: () => context.go(route),
      child: Column(
        children: [
          Container(
            width: 70,
            height: 70,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              shape: BoxShape.circle,
            ),
            child: Image.asset(imagePath, width: 32, height: 32),
          ),
          const SizedBox(height: 8),
          Text(title, style: TextStyles.caption()),
        ],
      ),
    );
  }

  /// 🔹 Offer Item
  Widget _offerItem(BuildContext context, Product product) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {
        context.push(
          '/product-details',
          extra: product,
        );
      },
      child: Container(
        height: 90,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: AppColor.primaryColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  product.image,
                  width: 36,
                  height: 36,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => const Icon(
                    Icons.image,
                    size: 32,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    product.name,
                    style: TextStyles.bodyLarge(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    '${product.price} EGP ⭐ ${product.rating.toStringAsFixed(1)}',
                    style: TextStyles.body(color: AppColor.primaryColor),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColor.primaryColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                "Shop now",
                style: TextStyles.button(color: AppColor.whiteColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
