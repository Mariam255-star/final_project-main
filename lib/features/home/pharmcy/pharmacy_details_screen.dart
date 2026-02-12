import 'package:final_project/core/constants/app_color.dart';
import 'package:final_project/core/utils/text_style.dart';
import 'package:final_project/models/pharmacy_model.dart';
import 'package:final_project/models/product_model.dart';
import 'package:final_project/services/product_services.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PharmacyDetailsScreen extends StatelessWidget {
  final Pharmacy pharmacy;

  const PharmacyDetailsScreen({super.key, required this.pharmacy});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
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
            /// 🔹 Header
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
              ),
              child: Center(
                child: Image.network(
                  pharmacy.image,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.local_pharmacy, size: 70),
                ),
              ),
            ),

            const SizedBox(height: 12),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    pharmacy.name,
                    style: TextStyles.titleMedium(
                      color: AppColor.secondaryColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    pharmacy.description,
                    style: TextStyles.caption(color: Colors.grey),
                  ),
                  const SizedBox(height: 10),

                  Row(
                    children: [
                      const Icon(Icons.delivery_dining,
                          size: 18, color: Colors.grey),
                      const SizedBox(width: 6),
                      Text(
                        "Delivery: ${pharmacy.deliveryTime}",
                        style: TextStyles.caption(color: Colors.grey),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  /// ================== OFFERS ==================
                  Text(
                    "Exclusive Offers",
                    style: TextStyles.bodyLarge(
                        color: AppColor.secondaryColor),
                  ),
                  const SizedBox(height: 12),

                  FutureBuilder<List<Product>>(
                    future: ProductService.getProducts(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const SizedBox(
                          height: 160,
                          child: Center(
                              child: CircularProgressIndicator()),
                        );
                      }

                      final products = snapshot.data ?? [];

                      return SizedBox(
                        height: 160, // 🔥 زودنا الارتفاع
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: products.length,
                          itemBuilder: (context, index) =>
                              _offerCard(context, products[index]),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 20),

                  /// ================== PRODUCTS ==================
                  Text(
                    "Products",
                    style: TextStyles.bodyLarge(
                        color: AppColor.secondaryColor),
                  ),
                  const SizedBox(height: 10),

                  FutureBuilder<List<Product>>(
                    future: ProductService.getProducts(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(
                            child: CircularProgressIndicator());
                      }

                      final products = snapshot.data ?? [];

                      return GridView.builder(
                        shrinkWrap: true,
                        physics:
                            const NeverScrollableScrollPhysics(),
                        itemCount: products.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 0.75,
                        ),
                        itemBuilder: (context, index) {
                          return _productCard(
                              context, products[index]);
                        },
                      );
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

  /// ================== OFFER CARD ==================
  Widget _offerCard(BuildContext context, Product product) {
    return GestureDetector(
      onTap: () {
        context.push('/product-details', extra: product);
      },
      child: Container(
        width: 220,
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xffE8F6F3),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            /// Text Part
            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    product.name,
                    style: TextStyles.bodyLarge(
                        color: AppColor.secondaryColor),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    "${product.price} EGP",
                    style:
                        TextStyles.caption(color: Colors.grey),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColor.primaryColor,
                      borderRadius:
                          BorderRadius.circular(20),
                    ),
                    child: Text(
                      "Shop now",
                      style: TextStyles.caption(
                          color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),

            /// Image
            SizedBox(
              width: 70,
              height: 70,
              child: Image.network(
                product.image,
                fit: BoxFit.contain,
                errorBuilder:
                    (context, error, stackTrace) =>
                        const Icon(Icons.image),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// ================== PRODUCT CARD ==================
  Widget _productCard(
      BuildContext context, Product product) {
    return GestureDetector(
      onTap: () {
        context.push('/product-details', extra: product);
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColor.whiteColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(color: Colors.black12, blurRadius: 6)
          ],
        ),
        child: Column(
          children: [
            Expanded(
              child: Image.network(
                product.image,
                fit: BoxFit.contain,
                errorBuilder:
                    (context, error, stackTrace) =>
                        const Icon(Icons.image),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              product.name,
              style: TextStyles.body(),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              "${product.price} EGP",
              style: TextStyles.caption(
                  color: AppColor.primaryColor),
            ),
          ],
        ),
      ),
    );
  }
}
