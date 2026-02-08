import 'package:final_project/core/shared/widgets/main_layout.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_color.dart';
import '../../core/utils/text_style.dart';
import '../../services/product/product_cart_service.dart';

class OrderReviewScreen extends StatefulWidget {
  const OrderReviewScreen({super.key});

  @override
  State<OrderReviewScreen> createState() => _OrderReviewScreenState();
}

class _OrderReviewScreenState extends State<OrderReviewScreen> {
  @override
  Widget build(BuildContext context) {
    return MainLayout(
      currentIndex: 2,
      child: Scaffold(
        backgroundColor: AppColor.whiteColor,

        /// 🟢 AppBar
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => context.pop(),
          ),
          title: Text(
            'Order Review',
            style: TextStyles.subtitle(color: Colors.black),
          ),
          centerTitle: true,
        ),

        /// 🟢 Body
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _stepper(),
              const SizedBox(height: 24),

              _sectionTitle('Shipment options'),
              _shipmentTile('Mon 30 April - Wed 2 May', '\$1.99', true),
              _shipmentTile('Mon 30 April - Fri 4 May', '\$0.99', false),
              _shipmentTile('Standard shipment', '\$2.99', false),

              const SizedBox(height: 18),
              _sectionTitle('Order details'),
              _buildOrderItems(),

              const SizedBox(height: 18),
              _editableTile(
                'Delivery address',
                '1457 Dorothea Street\n8500 Phoenix, AZ',
              ),
              _editableTile('Billing address', 'Same as delivery'),
              _editableTile('Payment method', 'Card •••• 4563'),

              const SizedBox(height: 18),
              _discountCard(),

              const SizedBox(height: 26),
              _buildTotalSection(),

              const SizedBox(height: 18),
              GestureDetector(
                onTap: () => context.push('/confirmation'),
                child: _primaryButton('Confirm Order'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ================= Stepper =================

  Widget _stepper() {
    return Row(
      children: [
        _done(),
        _line(),
        _done(),
        _line(),
        _done(),
        _line(),
        _active('4'),
      ],
    );
  }

  // ================= Shipment Tile =================

  Widget _shipmentTile(String title, String price, bool selected) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: selected
            ? AppColor.primaryColor.withOpacity(0.12)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: Icon(
          selected ? Icons.radio_button_checked : Icons.radio_button_off,
          color: selected ? AppColor.primaryColor : Colors.grey,
        ),
        title: Text(title, style: TextStyles.body()),
        trailing: Text(price, style: TextStyles.body()),
      ),
    );
  }

  // ================= Order Items =================

  Widget _buildOrderItems() {
    final cartItems = ProductCartService.getCartItems();
    if (cartItems.isEmpty) {
      return Center(child: Text('No items in cart', style: TextStyles.body()));
    }

    return Column(
      children: cartItems.map((item) => _orderItemCard(item)).toList(),
    );
  }

  Widget _orderItemCard(dynamic cartItem) {
    final product = cartItem.product;
    final quantity = cartItem.quantity;
    final subtotal = cartItem.getSubtotal();

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: _box(),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              product.image,
              height: 65,
              width: 65,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 65,
                  width: 65,
                  color: Colors.grey[300],
                  child: const Icon(Icons.image_not_supported),
                );
              },
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: TextStyles.bodyLarge(color: AppColor.secondaryColor),
                ),
                const SizedBox(height: 4),
                Text(
                  product.brand,
                  style: TextStyles.caption(color: Colors.grey),
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'EGP ${product.price.toStringAsFixed(2)}',
                      style: TextStyles.subtitle(),
                    ),
                    Text(
                      'x$quantity',
                      style: TextStyles.caption(color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'EGP ${subtotal.toStringAsFixed(2)}',
                style: TextStyles.bodyLarge(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ================= Editable Tile =================

  Widget _editableTile(String title, String value) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(title, style: TextStyles.bodyLarge()),
      subtitle: Text(value, style: TextStyles.caption()),
      trailing: const Icon(Icons.edit, size: 18),
    );
  }

  // ================= Discount =================

  Widget _discountCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: _box(),
      child: Row(
        children: [
          Icon(Icons.discount_outlined, color: AppColor.primaryColor),
          const SizedBox(width: 10),
          Text('Discount code', style: TextStyles.body()),
        ],
      ),
    );
  }

  // ================= Total Section =================

  Widget _buildTotalSection() {
    final cartTotal = ProductCartService.getCartTotal();
    final shipmentCost = 9.99;
    final totalWithShipment = cartTotal + shipmentCost;

    return Column(
      children: [
        _PriceRow('Items value', 'EGP ${cartTotal.toStringAsFixed(2)}'),
        _PriceRow('Shipment', 'EGP ${shipmentCost.toStringAsFixed(2)}'),
        const Divider(),
        _PriceRow(
          'Total value',
          'EGP ${totalWithShipment.toStringAsFixed(2)}',
          bold: true,
        ),
      ],
    );
  }

  // ================= UI Helpers =================

  Widget _primaryButton(String text) {
    return Container(
      height: 55,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColor.primaryColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(
        child: Text(text, style: TextStyles.button(color: Colors.white)),
      ),
    );
  }

  Widget _sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(text, style: TextStyles.subtitle()),
    );
  }

  BoxDecoration _box() {
    return BoxDecoration(
      color: Colors.white,
      border: Border.all(color: Colors.grey.shade300),
      borderRadius: BorderRadius.circular(14),
      boxShadow: const [
        BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
      ],
    );
  }

  Widget _done() => const CircleAvatar(
    radius: 14,
    backgroundColor: Colors.green,
    child: Icon(Icons.check, size: 14, color: Colors.white),
  );

  Widget _active(String t) => CircleAvatar(
    radius: 14,
    backgroundColor: AppColor.primaryColor,
    child: Text(t, style: const TextStyle(color: Colors.white)),
  );

  Widget _line() => Expanded(child: Container(height: 1.2, color: Colors.grey));
}

// ================= Price Row =================

class _PriceRow extends StatelessWidget {
  final String title;
  final String value;
  final bool bold;

  const _PriceRow(this.title, this.value, {this.bold = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: TextStyles.body()),
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
}
