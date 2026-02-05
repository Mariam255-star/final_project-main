import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:final_project/core/constants/app_color.dart';
import 'package:final_project/core/utils/text_style.dart';
import 'package:final_project/models/product_model.dart';
import 'package:final_project/services/product_services.dart';

class SkinCareScreen extends StatelessWidget {
  const SkinCareScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whiteColor,

      /// 🟢 AppBar
      appBar: AppBar(
        backgroundColor: AppColor.primaryColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColor.whiteColor),
          onPressed: () => context.go('/home'),
        ),
        title: Text(
          'Products',
          style: TextStyles.subtitle(color: AppColor.whiteColor),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// 🔍 Search (UI بس)
            TextField(
              decoration: InputDecoration(
                hintText: 'Search',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: const Icon(Icons.filter_list),
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 16),

            /// 📦 Products from API
            Expanded(
              child: FutureBuilder<List<Product>>(
                future: ProductService.getProducts(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return const Center(
                      child: Text("حدث خطأ في تحميل البيانات"),
                    );
                  }

                  final products = snapshot.data ?? [];

                  if (products.isEmpty) {
                    return const Center(child: Text("لا يوجد منتجات"));
                  }

                  return ListView.builder(
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final product = products[index];

                      return GestureDetector(
                        onTap: () {
                          context.push(
                            '/product-details',
                            extra: product,
                          );
                        },
                        child: Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListTile(
                            leading: Image.network(
                              product.image,
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(
                                  Icons.image_not_supported,
                                  size: 40,
                                );
                              },
                            ),
                            title: Text(
                              product.name,
                              style: TextStyles.bodyLarge(
                                color: AppColor.secondaryColor,
                              ),
                            ),
                            subtitle: Text(
                              "${product.brand} • ⭐ ${product.rating}",
                              style: TextStyles.caption(color: Colors.grey),
                            ),
                            trailing: Text(
                              "${product.price} EGP",
                              style: TextStyles.bodyLarge(
                                color: AppColor.primaryColor,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
