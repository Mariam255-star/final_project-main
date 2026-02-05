import '../../models/product_model.dart';

class ProductCartService {
  static final List<CartItem> _cartItems = [];

  static void addToCart(Product product, {int quantity = 1}) {
    try {
      final existingItem = _cartItems.firstWhere(
        (item) => item.product.id == product.id,
        orElse: () => CartItem(product: product, quantity: 0),
      );

      if (existingItem.quantity > 0) {
        existingItem.quantity += quantity;
        print(
          'Updated cart: ${product.name} now has quantity ${existingItem.quantity}',
        );
      } else {
        _cartItems.add(CartItem(product: product, quantity: quantity));
        print('Added to cart: ${product.name}');
      }
    } catch (e) {
      print('Error adding to cart: $e');
      rethrow;
    }
  }

  static void removeFromCart(String productId) {
    try {
      _cartItems.removeWhere((item) => item.product.id == productId);
      print('Removed from cart: $productId');
    } catch (e) {
      print('Error removing from cart: $e');
      rethrow;
    }
  }

  static void updateQuantity(String productId, int quantity) {
    try {
      final item = _cartItems.firstWhere(
        (item) => item.product.id == productId,
      );
      item.quantity = quantity;
      print('Updated quantity for $productId to $quantity');
    } catch (e) {
      print('Error updating quantity: $e');
      rethrow;
    }
  }

  static List<CartItem> getCartItems() {
    return _cartItems;
  }

  static double getCartTotal() {
    return _cartItems.fold(
      0.0,
      (sum, item) => sum + (item.product.price * item.quantity),
    );
  }

  static int getCartItemCount() {
    return _cartItems.length;
  }

  static int getTotalQuantity() {
    return _cartItems.fold(0, (sum, item) => sum + item.quantity);
  }

  static bool isProductInCart(String productId) {
    return _cartItems.any((item) => item.product.id == productId);
  }

  static int getProductQuantity(String productId) {
    try {
      final item = _cartItems.firstWhere(
        (item) => item.product.id == productId,
      );
      return item.quantity;
    } catch (e) {
      return 0;
    }
  }

  static void clearCart() {
    _cartItems.clear();
    print('Cart cleared');
  }

  static String getCartSummary() {
    return '''
Cart Summary:
Items: ${getCartItemCount()}
Total Quantity: ${getTotalQuantity()}
Total Price: SAR ${getCartTotal().toStringAsFixed(2)}
''';
  }
}

class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, required this.quantity});

  double getSubtotal() {
    return product.price * quantity;
  }

  String getDisplayText() {
    return '${product.name} x$quantity - SAR ${getSubtotal().toStringAsFixed(2)}';
  }
}
