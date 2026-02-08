import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_color.dart';
import '../../core/utils/text_style.dart';
import '../../services/order_service.dart';

class ConfirmationScreen extends StatefulWidget {
  const ConfirmationScreen({super.key});

  @override
  State<ConfirmationScreen> createState() => _ConfirmationScreenState();
}

class _ConfirmationScreenState extends State<ConfirmationScreen> {
  bool _isProcessing = false;
  String? _orderId;

  @override
  void initState() {
    super.initState();
    _processOrder();
  }

  Future<void> _processOrder() async {
    setState(() => _isProcessing = true);

    try {
      final order = await OrderService.createOrder(
        shippingAddress: '1457 Dorothea Street, 8500 Phoenix, AZ',
        paymentMethod: 'Card •••• 4563',
      );

      if (order != null) {
        setState(() => _orderId = order.id);
        print('✅ Order created successfully: ${order.id}');
      }
    } catch (e) {
      print('❌ Error processing order: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error processing order: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() => _isProcessing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      appBar: AppBar(
        backgroundColor: AppColor.whiteColor,
        elevation: 0,
        leading: _isProcessing
            ? null
            : IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => context.pop(),
              ),
        title: Text(
          'Confirmation',
          style: TextStyles.subtitle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            _stepper(),
            const SizedBox(height: 40),

            if (_isProcessing)
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(AppColor.primaryColor),
              )
            else if (_orderId != null)
              Column(
                children: [
                  const Icon(Icons.check_circle, size: 90, color: Colors.green),
                  const SizedBox(height: 24),
                  Text(
                    'Thank you for your purchase!',
                    style: TextStyles.subtitle(),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Your order #$_orderId has been confirmed.\n'
                    'You will receive order details\n'
                    'via notification and email.',
                    textAlign: TextAlign.center,
                    style: TextStyles.body(color: Colors.grey),
                  ),
                ],
              )
            else
              Column(
                children: [
                  const Icon(Icons.error_outline, size: 90, color: Colors.red),
                  const SizedBox(height: 24),
                  Text(
                    'Order Processing Failed',
                    style: TextStyles.subtitle(),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'There was an error processing your order.\n'
                    'Please try again.',
                    textAlign: TextAlign.center,
                    style: TextStyles.body(color: Colors.grey),
                  ),
                ],
              ),

            const Spacer(),
            GestureDetector(
              onTap: _isProcessing
                  ? null
                  : () {
                      context.go('/home');
                    },
              child: _primaryButton(_isProcessing ? 'Processing...' : 'OK'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _stepper() {
    return Row(
      children: [
        _done(),
        _line(),
        _done(),
        _line(),
        _done(),
        _line(),
        if (_orderId != null) _done() else _activeCircle('4'),
      ],
    );
  }

  Widget _primaryButton(String text) {
    return Container(
      height: 50,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColor.primaryColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Text(
          text.toLowerCase(),
          style: TextStyles.button(color: Colors.white),
        ),
      ),
    );
  }

  Widget _done() => const CircleAvatar(
    radius: 14,
    backgroundColor: Colors.green,
    child: Icon(Icons.check, size: 14, color: Colors.white),
  );

  Widget _activeCircle(String text) => CircleAvatar(
    radius: 14,
    backgroundColor: AppColor.primaryColor,
    child: Text(
      text,
      style: const TextStyle(color: Colors.white, fontSize: 10),
    ),
  );

  Widget _line() => Expanded(child: Container(height: 1, color: Colors.grey));
}
