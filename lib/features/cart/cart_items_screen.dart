import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_color.dart';
import '../../core/utils/text_style.dart';
import '../../services/product/product_cart_service.dart';

class CartItemsScreen extends StatefulWidget {
  const CartItemsScreen({super.key});

  @override
  State<CartItemsScreen> createState() => _CartItemsScreenState();
}

class _CartItemsScreenState extends State<CartItemsScreen> {
  @override
  void initState() {
    super.initState();
    _loadCart();
  }

  Future<void> _loadCart() async {
    await ProductCartService.initializeCartFromFirebase().catchError((_) {
      return ProductCartService.initializeCartFromLocal();
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final cartItems = ProductCartService.getCartItems();
    final cartTotal = ProductCartService.getCartTotal();
    final totalQuantity = ProductCartService.getTotalQuantity();

    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      appBar: AppBar(
        backgroundColor: AppColor.whiteColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.go('/home'),
        ),
        title: Text(
          'Cart Items (${cartItems.length})',
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
                  const SizedBox(height: 24),
                  _greenButton(
                    title: 'Continue Shopping',
                    onTap: () => context.go('/home'),
                  ),
                ],
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: cartItems.length,
                      itemBuilder: (context, index) {
                        final cartItem = cartItems[index];
                        return _buildCartItemCard(cartItem, index);
                      },
                    ),
                  ),

                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        _summaryRow(
                          'Subtotal ($totalQuantity items)',
                          'EGP ${cartTotal.toStringAsFixed(2)}',
                        ),
                        _summaryRow('Shipping total', 'Free'),
                        _summaryRow(
                          'Taxes',
                          'EGP ${(cartTotal * 0.1).toStringAsFixed(2)}',
                        ),
                        const Divider(thickness: 1, height: 12),
                        _summaryRow(
                          'Total',
                          'EGP ${(cartTotal * 1.1).toStringAsFixed(2)}',
                          bold: true,
                        ),
                      ],
                    ),
                  ),

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

  Widget _buildCartItemCard(CartItem cartItem, int index) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            /// 📷 Product Image
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey.shade200,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  cartItem.product.image,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.image_not_supported);
                  },
                ),
              ),
            ),

            const SizedBox(width: 12),

            /// 📝 Product Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    cartItem.product.name,
                    style: TextStyles.bodyLarge(color: AppColor.secondaryColor),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    cartItem.product.brand,
                    style: TextStyles.caption(color: Colors.grey),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'EGP ${cartItem.product.price.toStringAsFixed(2)}',
                    style: TextStyles.bodyLarge(color: AppColor.primaryColor),
                  ),
                  const SizedBox(height: 8),

                  /// Quantity Controls
                  _buildQuantityControls(cartItem),
                ],
              ),
            ),

            /// ❌ Delete Button
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.red),
              onPressed: () {
                _showDeleteDialog(cartItem.product.id);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuantityControls(CartItem cartItem) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: cartItem.quantity > 1
                ? () async {
                    await ProductCartService.updateQuantity(
                      cartItem.product.id,
                      cartItem.quantity - 1,
                      useFirebase: true,
                    );
                    setState(() {});
                  }
                : null,
            child: Icon(
              Icons.remove,
              size: 18,
              color: cartItem.quantity > 1 ? Colors.black : Colors.grey,
            ),
          ),
          const SizedBox(width: 8),
          Text(cartItem.quantity.toString(), style: TextStyles.body()),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () async {
              await ProductCartService.updateQuantity(
                cartItem.product.id,
                cartItem.quantity + 1,
                useFirebase: true,
              );
              setState(() {});
            },
            child: const Icon(Icons.add, size: 18, color: Colors.black),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(String productId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove item?'),
        content: const Text('Are you sure you want to remove this item?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              await ProductCartService.removeFromCart(
                productId,
                useFirebase: true,
              );
              setState(() {});
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Item removed from cart')),
              );
            },
            child: const Text('Remove', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Widget _summaryRow(String title, String value, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyles.body(color: bold ? Colors.black : Colors.grey),
          ),
          Text(
            value,
            style: TextStyles.body(
              color: Colors.black,
            ).copyWith(fontWeight: bold ? FontWeight.bold : FontWeight.normal),
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
