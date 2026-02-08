import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:final_project/services/product/product_cart_service.dart';
import 'package:final_project/services/notification/notification_service.dart';

class Order {
  final String id;
  final String userId;
  final List<Map<String, dynamic>> items;
  final double totalPrice;
  final String status;
  final String shippingAddress;
  final String paymentMethod;
  final DateTime createdAt;

  Order({
    required this.id,
    required this.userId,
    required this.items,
    required this.totalPrice,
    this.status = 'confirmed',
    required this.shippingAddress,
    required this.paymentMethod,
    required this.createdAt,
  });

  factory Order.fromFirestore(Map<String, dynamic> data, String docId) {
    return Order(
      id: docId,
      userId: data['userId'] ?? '',
      items: List<Map<String, dynamic>>.from(data['items'] ?? []),
      totalPrice: (data['totalPrice'] ?? 0).toDouble(),
      status: data['status'] ?? 'confirmed',
      shippingAddress: data['shippingAddress'] ?? '',
      paymentMethod: data['paymentMethod'] ?? '',
      createdAt: data['createdAt'] is Timestamp
          ? (data['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'items': items,
      'totalPrice': totalPrice,
      'status': status,
      'shippingAddress': shippingAddress,
      'paymentMethod': paymentMethod,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}

class OrderService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  static Future<Order?> createOrder({
    required String shippingAddress,
    required String paymentMethod,
  }) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        print('User not logged in');
        return null;
      }

      final cartItems = ProductCartService.getCartItems();
      if (cartItems.isEmpty) {
        print('Cart is empty');
        return null;
      }

      final items = cartItems
          .map(
            (item) => {
              'productId': item.product.id,
              'productName': item.product.name,
              'productBrand': item.product.brand,
              'productPrice': item.product.price,
              'productImage': item.product.image,
              'quantity': item.quantity,
              'subtotal': item.getSubtotal(),
            },
          )
          .toList();

      final totalPrice = ProductCartService.getCartTotal();

      final order = Order(
        id: '',
        userId: user.uid,
        items: items,
        totalPrice: totalPrice,
        shippingAddress: shippingAddress,
        paymentMethod: paymentMethod,
        createdAt: DateTime.now(),
      );

      final docRef = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('orders')
          .add(order.toFirestore());

      final orderId = docRef.id;
      print('Order created: $orderId');

      await ProductCartService.clearCart(useFirebase: true);

      await _sendOrderConfirmationNotification(
        orderId: orderId,
        totalPrice: totalPrice,
        itemCount: items.length,
        items: items,
      );

      return order;
    } catch (e) {
      print('Error creating order: $e');
      return null;
    }
  }

  static Future<void> _sendOrderConfirmationNotification({
    required String orderId,
    required double totalPrice,
    required int itemCount,
    required List<Map<String, dynamic>> items,
  }) async {
    try {
      final orderData = {
        'orderId': orderId,
        'totalPrice': totalPrice.toStringAsFixed(2),
        'itemCount': itemCount.toString(),
        'items': items,
        'type': 'order_confirmed',
      };

      String itemsList = '';
      if (items.length <= 3) {
        itemsList = items
            .map((item) => '${item['productName']} (${item['quantity']}x)')
            .join('\n');
      } else {
        itemsList =
            '${items[0]['productName']} (${items[0]['quantity']}x)\n${items[1]['productName']} (${items[1]['quantity']}x)\n+${items.length - 2} more items';
      }

      final notificationBody = '''Items: $itemsList
Total: EGP ${totalPrice.toStringAsFixed(2)}''';

      await NotificationService.sendOrderNotification(
        title: '✅ Order Confirmed!',
        body: notificationBody,
        orderData: orderData,
      );
    } catch (e) {
      print('Error sending notification: $e');
    }
  }

  static Stream<List<Order>> getUserOrders() {
    final user = _auth.currentUser;
    if (user == null) {
      return Stream.value([]);
    }

    return _firestore
        .collection('users')
        .doc(user.uid)
        .collection('orders')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => Order.fromFirestore(doc.data(), doc.id))
              .toList();
        });
  }

  static Future<Order?> getOrder(String orderId) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return null;

      final doc = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('orders')
          .doc(orderId)
          .get();

      if (!doc.exists) return null;

      return Order.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
    } catch (e) {
      print('Error fetching order: $e');
      return null;
    }
  }

  static Future<void> updateOrderStatus(String orderId, String status) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return;

      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('orders')
          .doc(orderId)
          .update({'status': status});

      print('Order status updated: $status');
    } catch (e) {
      print('Error updating order: $e');
    }
  }
}
