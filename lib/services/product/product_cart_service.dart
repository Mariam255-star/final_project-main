import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/product_model.dart';

class ProductCartService {
  static final List<CartItem> _cartItems = [];
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static const String _localCartKey = 'cart_items';

  /// 📱 LOCAL STORAGE METHODS

  /// Initialize cart from local storage
  static Future<void> initializeCartFromLocal() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cartJson = prefs.getString(_localCartKey);

      if (cartJson != null && cartJson.isNotEmpty) {
        final List<dynamic> cartList = jsonDecode(cartJson);
        _cartItems.clear();
        for (var item in cartList) {
          _cartItems.add(CartItem.fromJson(item));
        }
        print('Cart loaded from local storage: ${_cartItems.length} items');
      }
    } catch (e) {
      print('Error loading cart from local storage: $e');
    }
  }

  /// Save cart to local storage
  static Future<void> _saveCartToLocal() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cartJson = jsonEncode(
        _cartItems.map((item) => item.toJson()).toList(),
      );
      await prefs.setString(_localCartKey, cartJson);
      print('Cart saved to local storage');
    } catch (e) {
      print('Error saving cart to local storage: $e');
    }
  }

  /// 🔥 FIREBASE METHODS

  /// Initialize cart from Firebase
  static Future<void> initializeCartFromFirebase() async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        print('User not logged in');
        return;
      }

      final snapshot = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('cart')
          .get();

      _cartItems.clear();
      for (var doc in snapshot.docs) {
        _cartItems.add(CartItem.fromFirestore(doc.data()));
      }
      print('Cart loaded from Firebase: ${_cartItems.length} items');
    } catch (e) {
      print('Error loading cart from Firebase: $e');
    }
  }

  /// Save cart to Firebase
  static Future<void> _saveCartToFirebase() async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        print('User not logged in - cart not saved to Firebase');
        return;
      }

      final cartRef = _firestore
          .collection('users')
          .doc(user.uid)
          .collection('cart');

      // Clear existing cart in Firebase
      final existingDocs = await cartRef.get();
      for (var doc in existingDocs.docs) {
        await doc.reference.delete();
      }

      // Save current cart items
      for (var item in _cartItems) {
        await cartRef.add(item.toFirestore());
      }
      print('Cart saved to Firebase');
    } catch (e) {
      print('Error saving cart to Firebase: $e');
    }
  }

  /// 🛒 CART OPERATIONS

  /// Add product to cart (with both storage methods)
  static Future<void> addToCart(
    Product product, {
    int quantity = 1,
    bool useFirebase = false,
  }) async {
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

      // Save to storage
      if (useFirebase) {
        await _saveCartToFirebase();
      } else {
        await _saveCartToLocal();
      }
    } catch (e) {
      print('Error adding to cart: $e');
      rethrow;
    }
  }

  /// Remove product from cart
  static Future<void> removeFromCart(
    String productId, {
    bool useFirebase = false,
  }) async {
    try {
      _cartItems.removeWhere((item) => item.product.id == productId);
      print('Removed from cart: $productId');

      // Save to storage
      if (useFirebase) {
        await _saveCartToFirebase();
      } else {
        await _saveCartToLocal();
      }
    } catch (e) {
      print('Error removing from cart: $e');
      rethrow;
    }
  }

  /// Update quantity for product
  static Future<void> updateQuantity(
    String productId,
    int quantity, {
    bool useFirebase = false,
  }) async {
    try {
      final item = _cartItems.firstWhere(
        (item) => item.product.id == productId,
      );
      item.quantity = quantity;
      print('Updated quantity for $productId to $quantity');

      // Save to storage
      if (useFirebase) {
        await _saveCartToFirebase();
      } else {
        await _saveCartToLocal();
      }
    } catch (e) {
      print('Error updating quantity: $e');
      rethrow;
    }
  }

  /// Get all cart items
  static List<CartItem> getCartItems() {
    return List.unmodifiable(_cartItems);
  }

  /// Get cart total
  static double getCartTotal() {
    return _cartItems.fold(
      0.0,
      (sum, item) => sum + (item.product.price * item.quantity),
    );
  }

  /// Get number of unique items
  static int getCartItemCount() {
    return _cartItems.length;
  }

  /// Get total quantity of all items
  static int getTotalQuantity() {
    return _cartItems.fold(0, (sum, item) => sum + item.quantity);
  }

  /// Check if product is in cart
  static bool isProductInCart(String productId) {
    return _cartItems.any((item) => item.product.id == productId);
  }

  /// Get quantity of specific product
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

  /// Clear entire cart
  static Future<void> clearCart({bool useFirebase = false}) async {
    _cartItems.clear();
    print('Cart cleared');

    // Save to storage
    if (useFirebase) {
      await _saveCartToFirebase();
    } else {
      await _saveCartToLocal();
    }
  }

  /// Get cart summary
  static String getCartSummary() {
    return '''
Cart Summary:
Items: ${getCartItemCount()}
Total Quantity: ${getTotalQuantity()}
Total Price: EGP ${getCartTotal().toStringAsFixed(2)}
''';
  }
}

class CartItem {
  final Product product;
  int quantity;
  final DateTime addedAt;

  CartItem({
    required this.product,
    required this.quantity,
    DateTime? addedAt,
  }) : addedAt = addedAt ?? DateTime.now();

  /// Convert to JSON (for local storage)
  Map<String, dynamic> toJson() {
    return {
      'product': {
        'id': product.id,
        'name': product.name,
        'brand': product.brand,
        'category': product.category,
        'price': product.price,
        'rating': product.rating,
        'image': product.image,
        'description': product.description,
      },
      'quantity': quantity,
      'addedAt': addedAt.toIso8601String(),
    };
  }

  /// Create from JSON (from local storage)
  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      product: Product(
        id: json['product']['id'],
        name: json['product']['name'],
        brand: json['product']['brand'],
        category: json['product']['category'],
        price: (json['product']['price']).toDouble(),
        rating: (json['product']['rating']).toDouble(),
        image: json['product']['image'],
        description: json['product']['description'],
      ),
      quantity: json['quantity'],
      addedAt: DateTime.parse(json['addedAt']),
    );
  }

  /// Convert to Firebase format
  Map<String, dynamic> toFirestore() {
    return {
      'productId': product.id,
      'productName': product.name,
      'productBrand': product.brand,
      'productCategory': product.category,
      'productPrice': product.price,
      'productRating': product.rating,
      'productImage': product.image,
      'productDescription': product.description,
      'quantity': quantity,
      'addedAt': Timestamp.fromDate(addedAt),
    };
  }

  /// Create from Firebase data
  factory CartItem.fromFirestore(Map<String, dynamic> data) {
    return CartItem(
      product: Product(
        id: data['productId'],
        name: data['productName'],
        brand: data['productBrand'],
        category: data['productCategory'],
        price: (data['productPrice']).toDouble(),
        rating: (data['productRating']).toDouble(),
        image: data['productImage'],
        description: data['productDescription'],
      ),
      quantity: data['quantity'],
      addedAt: (data['addedAt'] as Timestamp).toDate(),
    );
  }

  /// Get subtotal for this item
  double getSubtotal() {
    return product.price * quantity;
  }

  /// Get display text
  String getDisplayText() {
    return '${product.name} x$quantity - EGP ${getSubtotal().toStringAsFixed(2)}';
  }
}
