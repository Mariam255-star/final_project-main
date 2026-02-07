import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_color.dart';
import '../../core/utils/text_style.dart';
import '../../services/notification/notification_provider.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
          'Notification',
          style: TextStyles.subtitle(color: Colors.black),
        ),
        centerTitle: true,
      ),

      body: Consumer<NotificationProvider>(
        builder: (context, provider, child) {
          final notifications = provider.notifications;

          if (notifications.isEmpty) {
            return const Center(child: Text("No notifications yet"));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final n = notifications[index];

              return _notificationCard(
                n.title,
                n.body,
                n.image,
                n.price,
              );
            },
          );
        },
      ),
    );
  }

  Widget _notificationCard(String title, String body, String image, String price) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xffCFF0EA),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            height: 55,
            width: 55,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Image.network(image, fit: BoxFit.cover),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyles.bodyLarge(color: AppColor.secondaryColor),
                ),
                const SizedBox(height: 4),
                Text(
                  body,
                  style: TextStyles.caption(color: Colors.grey),
                ),
                const SizedBox(height: 2),
                Text(
                  "Price: $price EGP",
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
