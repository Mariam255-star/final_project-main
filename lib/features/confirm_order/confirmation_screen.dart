import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_color.dart';
import '../../core/utils/text_style.dart';

class ConfirmationScreen extends StatelessWidget {
  const ConfirmationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whiteColor,

      appBar: AppBar(
        backgroundColor: AppColor.whiteColor,
        elevation: 0,
        leading: IconButton(
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

            const Icon(Icons.check_circle,
                size: 90, color: Colors.green),

            const SizedBox(height: 24),
            Text(
              'Thank you for your purchase!',
              style: TextStyles.subtitle(),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'Your order has been successfully placed.\n'
              'You will receive order details\nand tracking information.',
              textAlign: TextAlign.center,
              style: TextStyles.body(color: Colors.grey),
            ),

            const Spacer(),
            GestureDetector(
              onTap: () => context.go('/home'),
              child: _primaryButton('OK'),
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
        _done(),
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

  Widget _line() => Expanded(child: Container(height: 1, color: Colors.grey));
}
