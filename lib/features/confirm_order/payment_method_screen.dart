import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_color.dart';
import '../../core/utils/text_style.dart';

import '../../services/product/product_cart_service.dart';

enum PaymentType { paypal, card, cash }

class PaymentMethodScreen extends StatefulWidget {
  const PaymentMethodScreen({super.key});

  @override
  State<PaymentMethodScreen> createState() => _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends State<PaymentMethodScreen> {
  PaymentType selected = PaymentType.paypal;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whiteColor,

      /// 🟢 AppBar
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.go('/cart'),
        ),
        title: Text(
          'Payment Method',
          style: TextStyles.subtitle(color: Colors.black),
        ),
        centerTitle: true,
      ),

      /// 🟢 Body
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _stepper(),
              const SizedBox(height: 28),

              _paymentTile(
                title: 'PayPal',
                icon: Icons.account_balance_wallet,
                value: PaymentType.paypal,
              ),

              _paymentTile(
                title: 'Credit / Debit Card',
                icon: Icons.credit_card,
                value: PaymentType.card,
              ),

              if (selected == PaymentType.card) _cardForm(),

              _paymentTile(
                title: 'Cash on Delivery',
                icon: Icons.money,
                value: PaymentType.cash,
              ),

              const SizedBox(height: 22),
              _buildSummary(),

              const SizedBox(height: 20),

              GestureDetector(
                onTap: () => context.go('/order-review'),
                child: _primaryButton('Continue'),
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
        _doneCircle(),
        _line(),
        _doneCircle(),
        _line(),
        _activeCircle('3'),
        _line(),
        _inactiveCircle('4'),
      ],
    );
  }

  // ================= Payment Tile =================

  Widget _paymentTile({
    required String title,
    required IconData icon,
    required PaymentType value,
  }) {
    final bool isSelected = selected == value;

    return GestureDetector(
      onTap: () => setState(() => selected = value),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColor.primaryColor.withOpacity(0.15)
              : const Color(0xffF6F6F6),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? AppColor.primaryColor : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? AppColor.primaryColor : Colors.grey,
              size: 28,
            ),
            const SizedBox(width: 12),
            Text(
              title,
              style: TextStyles.body(
                color: isSelected ? AppColor.primaryColor : Colors.black,
              ),
            ),
            const Spacer(),
            Radio<PaymentType>(
              value: value,
              groupValue: selected,
              activeColor: AppColor.primaryColor,
              onChanged: (val) => setState(() => selected = val!),
            ),
          ],
        ),
      ),
    );
  }

  // ================= Card Form =================

  Widget _cardForm() {
    return Column(
      children: [
        _textField('Card Holder Name'),
        _textField('Card Number'),
        Row(
          children: [
            Expanded(child: _textField('MM/YY')),
            const SizedBox(width: 10),
            Expanded(child: _textField('CVV')),
          ],
        ),
        CheckboxListTile(
          value: true,
          onChanged: (_) {},
          title: Text('Save card details', style: TextStyles.caption()),
          activeColor: AppColor.primaryColor,
          controlAffinity: ListTileControlAffinity.leading,
          contentPadding: EdgeInsets.zero,
        ),
      ],
    );
  }

  // ================= Summary =================

  Widget _buildSummary() {
    final cartTotal = ProductCartService.getCartTotal();
    final shipmentCost = 9.99;
    final totalWithShipment = cartTotal + shipmentCost;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xffF6F6F6),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          _SummaryRow(
            title: 'Items value',
            value: 'EGP ${cartTotal.toStringAsFixed(2)}',
          ),
          _SummaryRow(
            title: 'Shipment',
            value: 'EGP ${shipmentCost.toStringAsFixed(2)}',
          ),
          const Divider(),
          _SummaryRow(
            title: 'Total value',
            value: 'EGP ${totalWithShipment.toStringAsFixed(2)}',
          ),
        ],
      ),
    );
  }

  // ================= UI Helpers =================

  Widget _textField(String hint) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyles.caption(color: Colors.grey),
          filled: true,
          fillColor: const Color(0xffF6F6F6),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _primaryButton(String title) {
    return Container(
      height: 55,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColor.primaryColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(
        child: Text(title, style: TextStyles.button(color: Colors.white)),
      ),
    );
  }

  Widget _doneCircle() => const CircleAvatar(
    radius: 14,
    backgroundColor: Colors.green,
    child: Icon(Icons.check, size: 14, color: Colors.white),
  );

  Widget _activeCircle(String text) => CircleAvatar(
    radius: 14,
    backgroundColor: AppColor.primaryColor,
    child: Text(text, style: const TextStyle(color: Colors.white)),
  );

  Widget _inactiveCircle(String text) =>
      CircleAvatar(radius: 14, backgroundColor: Colors.grey, child: Text(text));

  Widget _line() => Expanded(child: Container(height: 1.2, color: Colors.grey));
}

// ================= Summary Row =================

class _SummaryRow extends StatelessWidget {
  final String title;
  final String value;

  const _SummaryRow({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: TextStyles.body()),
          Text(value, style: TextStyles.body()),
        ],
      ),
    );
  }
}
