import 'package:final_project/core/shared/widgets/main_layout.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_color.dart';
import '../../core/utils/text_style.dart';
import '../../services/product/product_cart_service.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  @override
  void initState() {
    super.initState();
    _loadCart();
  }

  Future<void> _loadCart() async {
    await ProductCartService.initializeCartFromFirebase();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final cartItems = ProductCartService.getCartItems();
    final cartTotal = ProductCartService.getCartTotal();
    final totalWithTax = cartTotal * 1.1;

    return MainLayout(
      currentIndex: 2,
      child: Scaffold(
        backgroundColor: AppColor.whiteColor,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => context.pop(),
          ),
          title: Text(
            'Checkout',
            style: TextStyles.subtitle(color: Colors.black),
          ),
          centerTitle: true,
        ),
        body: cartItems.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.shopping_cart_outlined,
                      size: 80,
                      color: Colors.grey.shade300,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Your cart is empty',
                      style: TextStyles.subtitle(color: Colors.grey),
                    ),
                  ],
                ),
              )
            : Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    /// 🔹 Checkout Options
                    _checkoutRow('SHIPPING', 'Add shipping address'),
                    _checkoutRow('DELIVERY', 'Free\nStandard | 3-4 days'),
                    _checkoutRow('PAYMENT', 'Visa *1234'),
                    _checkoutRow('PROMOS', 'Apply promo code'),

                    const SizedBox(height: 16),

                    /// 🔹 Items Header
                    _itemsHeader(),

                    /// 🔹 Cart Items
                    Expanded(
                      child: ListView.builder(
                        itemCount: cartItems.length,
                        itemBuilder: (context, index) {
                          final item = cartItems[index];
                          return _buildItemRow(item);
                        },
                      ),
                    ),

                    /// 🔹 Summary
                    _summaryRow(
                      'Subtotal (${cartItems.length})',
                      'EGP ${cartTotal.toStringAsFixed(2)}',
                    ),
                    _summaryRow('Shipping total', 'Free'),
                    _summaryRow(
                      'Taxes (10%)',
                      'EGP ${(cartTotal * 0.1).toStringAsFixed(2)}',
                    ),
                    _summaryRow(
                      'Total',
                      'EGP ${totalWithTax.toStringAsFixed(2)}',
                      bold: true,
                    ),

                    const SizedBox(height: 12),

                    /// 🔹 Place Order Button
                    _greenButton(
                      title: 'Place order',
                      onTap: () {
                        context.go('/address');
                      },
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildItemRow(CartItem item) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.grey.shade200,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                item.product.image,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.image_not_supported);
                },
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.product.name,
                  style: TextStyles.bodyLarge(color: AppColor.secondaryColor),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  item.product.brand,
                  style: TextStyles.caption(color: Colors.grey),
                ),
                Text(
                  'Quantity: ${item.quantity}',
                  style: TextStyles.caption(color: Colors.grey),
                ),
              ],
            ),
          ),
          Text(
            'EGP ${item.getSubtotal().toStringAsFixed(2)}',
            style: TextStyles.bodyLarge(color: AppColor.primaryColor),
          ),
        ],
      ),
    );
  }

  Widget _checkoutRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: TextStyles.caption()),
          Row(
            children: [
              Text(value, style: TextStyles.caption()),
              const SizedBox(width: 6),
              const Icon(Icons.arrow_forward_ios, size: 14),
            ],
          ),
        ],
      ),
    );
  }

  Widget _itemsHeader() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('ITEMS'),
          Expanded(child: Text('DESCRIPTION')),
          Text('PRICE'),
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
