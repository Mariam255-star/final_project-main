import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_color.dart';
import '../../core/utils/text_style.dart';

class CartItemsScreen extends StatelessWidget {
  const CartItemsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whiteColor,

      appBar: AppBar(
        backgroundColor: AppColor.whiteColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.push('/home'),
        ),
        title: Text(
          'Cart Items',
          style: TextStyles.subtitle(color: Colors.black),
        ),
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _headerRow(),
            const SizedBox(height: 12),

            Expanded(
              child: ListView.builder(
                itemCount: 4,
                itemBuilder: (context, index) {
                  return _cartItem();
                },
              ),
            ),

            _summaryRow('Subtotal (2)', '\$19.98'),
            _summaryRow('Shipping total', 'Free'),
            _summaryRow('Taxes', '\$2.00'),
            _summaryRow('Total', '\$21.98', bold: true),

            const SizedBox(height: 12),
            _greenButton(
              title: 'Checkout',
              onTap: () => context.go('/checkout'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _headerRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: const [Text('ITEMS'), Text('DESCRIPTION'), Text('PRICE')],
    );
  }

  Widget _cartItem() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Image.asset('assets/medicines/cream_3.jpg', height: 50),
          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('Brand'),
                Text('DISPRIN'),
                Text('Description'),
                Text('Quantity: 01'),
              ],
            ),
          ),

          const Text('\$10.99'),
        ],
      ),
    );
  }

  Widget _summaryRow(String title, String value, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title),
          Text(
            value,
            style: TextStyle(
              fontWeight: bold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _greenButton({required String title, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: 50,
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColor.primaryColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(title, style: TextStyles.button(color: Colors.white)),
        ),
      ),
    );
  }
}
