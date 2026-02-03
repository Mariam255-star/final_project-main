import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_color.dart';
import '../../core/utils/text_style.dart';

class AddressScreen extends StatelessWidget {
  const AddressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whiteColor,

      appBar: AppBar(
        backgroundColor: AppColor.whiteColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.go('/checkout'),

        ),
        title: Text(
          'Address',
          style: TextStyles.subtitle(color: Colors.black),
        ),
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _stepper(),
            const SizedBox(height: 20),

            _field('First name'),
            _field('Last name'),
            _field('Street & Appartment number'),
            _field('Zip Code'),
            _field('City'),

            const Spacer(),

            /// ✅ زرار شغال
            GestureDetector(
              onTap: () {
                context.push('/payment-method');
              },
              child: Container(
                height: 50,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColor.primaryColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    'next',
                    style: TextStyles.button(color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _stepper() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: const [
        CircleAvatar(backgroundColor: Colors.green, child: Text('1')),
        Expanded(child: Divider()),
        CircleAvatar(child: Text('2')),
        Expanded(child: Divider()),
        CircleAvatar(child: Text('3')),
        Expanded(child: Divider()),
        CircleAvatar(child: Text('4')),
      ],
    );
  }

  Widget _field(String hint) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        decoration: InputDecoration(
          hintText: hint,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
