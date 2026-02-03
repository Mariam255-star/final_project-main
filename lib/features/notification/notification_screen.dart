import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_color.dart';
import '../../core/utils/text_style.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whiteColor,

      /// 🟢 AppBar
      appBar: AppBar(
        backgroundColor: AppColor.whiteColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.go('/home'),
        ),
        title: Text(
          'Notification',
          style: TextStyles.subtitle(color: Colors.black),
        ),
        centerTitle: true,
      ),

      /// 🟢 Body
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 6,
        itemBuilder: (context, index) {
          return _notificationCard();
        },
      ),
    );
  }

  /// 🔔 Notification Card
  Widget _notificationCard() {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xffCFF0EA),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          /// 🧴 Product Image
          Container(
            height: 55,
            width: 55,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Image.asset(
              'assets/medicines/cream_3.jpg',
              fit: BoxFit.contain,
            ),
          ),

          const SizedBox(width: 12),

          /// 📝 Text Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Product Name',
                  style: TextStyles.bodyLarge(color: AppColor.secondaryColor),
                ),
                const SizedBox(height: 4),
                Text(
                  'Pharma Name : الوصف',
                  style: TextStyles.caption(color: Colors.grey),
                ),
                const SizedBox(height: 2),
                Text(
                  'Salary : 2.44\$',
                  style: TextStyles.caption(color: Colors.grey),
                ),
                const SizedBox(height: 2),
                Text(
                  'Description : ....',
                  style: TextStyles.caption(color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
