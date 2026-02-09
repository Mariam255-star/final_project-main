import 'package:final_project/core/constants/app_color.dart';
import 'package:final_project/core/utils/text_style.dart';
import 'package:final_project/services/pharmcy/pharmacy_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:final_project/models/pharmacy_model.dart';


class PharmaScreen extends StatefulWidget {
  const PharmaScreen({super.key});

  @override
  State<PharmaScreen> createState() => _PharmaScreenState();
}

class _PharmaScreenState extends State<PharmaScreen> {
  late Future<List<Pharmacy>> futurePharmacies;

  @override
  void initState() {
    super.initState();
    futurePharmacies = PharmacyService.getPharmacies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whiteColor,

      body: Column(
        children: [
          /// 🔹 TOP IMAGE
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
                  icon: const Icon(Icons.arrow_back, color: AppColor.whiteColor),
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

          /// 🏥 Pharmacies from API
          Expanded(
            child: FutureBuilder<List<Pharmacy>>(
              future: futurePharmacies,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                }

                final pharmacies = snapshot.data!;

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: GridView.builder(
                    itemCount: pharmacies.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemBuilder: (context, index) {
                      final pharmacy = pharmacies[index];

                      return GestureDetector(
                        onTap: () {
                          {
                       context.push(
                      '/pharmacy-details',
                      extra: pharmacy,
                  );
                };

                        },
                        child: Container(
                          decoration: const BoxDecoration(
                            color: AppColor.secondaryColor,
                            shape: BoxShape.circle,
                          ),
                          padding: const EdgeInsets.all(14),
                          child: ClipOval(
                            child: Image.network(
                              pharmacy.image,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(Icons.local_pharmacy,
                                      color: Colors.white, size: 40),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
