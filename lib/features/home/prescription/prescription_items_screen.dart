import 'package:final_project/core/shared/widgets/main_layout.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:final_project/core/constants/app_color.dart';
import 'package:final_project/core/utils/text_style.dart';
import 'package:final_project/models/product_model.dart';
import 'package:final_project/services/product_services.dart';

class PrescriptionItemsScreen extends StatelessWidget {
  const PrescriptionItemsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      currentIndex: 0,
      child: Scaffold(
        backgroundColor: AppColor.whiteColor,

        appBar: AppBar(
          backgroundColor: AppColor.primaryColor,
          elevation: 0,
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

        body: Padding(
          padding: const EdgeInsets.all(16),
          child: FutureBuilder<List<Product>>(
            future: ProductService.getProducts(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(child: Text("Error: ${snapshot.error}"));
              }

              // ✅ فلترة منتجات الصيدلية فقط
              final products = snapshot.data!
                  .where((p) => p.category == "pharmacy")
                  .toList();

              if (products.isEmpty) {
                return const Center(child: Text("No medicines found"));
              }

              return GridView.builder(
                itemCount: products.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.75,
                ),
                itemBuilder: (context, index) {
                  final product = products[index];

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
                          Image.network(
                            product.image,
                            height: 90,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.image, size: 60),
                          ),

                          const SizedBox(height: 10),

                          /// 🟢 Product Name
                          Text(
                            product.name,
                            style: TextStyles.body(),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),

                          const Spacer(),

                          /// 🟢 Price
                          Text(
                            "${product.price} EGP",
                            style: TextStyles.bodyLarge(
                              color: AppColor.secondaryColor,
                            ),
                          ),

                          const SizedBox(height: 6),

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
              );
            },
          ),
        ),
      ),
    );
  }
}
