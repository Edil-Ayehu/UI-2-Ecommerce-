import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ecommerce_ui/utils/app_textstyles.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: isDark ? Colors.white : Colors.black,
          ),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Notifications',
          style: AppTextStyle.withColor(
            AppTextStyle.h3,
            isDark ? Colors.white : Colors.black,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {},
            child: Text(
              'Mark all as read',
              style: AppTextStyle.withColor(
                AppTextStyle.bodyMedium,
                Theme.of(context).primaryColor,
              ),
            ),
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _demoNotifications.length,
        itemBuilder: (context, index) => _buildNotificationCard(
          context,
          _demoNotifications[index],
        ),
      ),
    );
  }

  Widget _buildNotificationCard(BuildContext context, NotificationItem notification) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: notification.isRead
            ? Theme.of(context).cardColor
            : Theme.of(context).primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withOpacity(0.2)
                : Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: _getIconBackgroundColor(context, notification.type),
            shape: BoxShape.circle,
          ),
          child: Icon(
            _getNotificationIcon(notification.type),
            color: _getIconColor(context, notification.type),
          ),
        ),
        title: Text(
          notification.title,
          style: AppTextStyle.withColor(
            AppTextStyle.bodyLarge,
            Theme.of(context).textTheme.bodyLarge!.color!,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              notification.message,
              style: AppTextStyle.withColor(
                AppTextStyle.bodySmall,
                isDark ? Colors.grey[400]! : Colors.grey[600]!,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              notification.time,
              style: AppTextStyle.withColor(
                AppTextStyle.bodySmall,
                isDark ? Colors.grey[400]! : Colors.grey[600]!,
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getNotificationIcon(NotificationType type) {
    switch (type) {
      case NotificationType.order:
        return Icons.shopping_bag_outlined;
      case NotificationType.delivery:
        return Icons.local_shipping_outlined;
      case NotificationType.promo:
        return Icons.local_offer_outlined;
      case NotificationType.payment:
        return Icons.payment_outlined;
    }
  }

  Color _getIconBackgroundColor(BuildContext context, NotificationType type) {
    switch (type) {
      case NotificationType.order:
        return Theme.of(context).primaryColor.withOpacity(0.1);
      case NotificationType.delivery:
        return Colors.green[100]!;
      case NotificationType.promo:
        return Colors.orange[100]!;
      case NotificationType.payment:
        return Colors.red[100]!;
    }
  }

  Color _getIconColor(BuildContext context, NotificationType type) {
    switch (type) {
      case NotificationType.order:
        return Theme.of(context).primaryColor;
      case NotificationType.delivery:
        return Colors.green;
      case NotificationType.promo:
        return Colors.orange;
      case NotificationType.payment:
        return Colors.red;
    }
  }
}

enum NotificationType { order, delivery, promo, payment }

class NotificationItem {
  final String title;
  final String message;
  final String time;
  final NotificationType type;
  final bool isRead;

  NotificationItem({
    required this.title,
    required this.message,
    required this.time,
    required this.type,
    this.isRead = false,
  });
}

final List<NotificationItem> _demoNotifications = [
  NotificationItem(
    title: 'Order Confirmed!',
    message: 'Your order #12345 has been confirmed and is being processed.',
    time: '2 minutes ago',
    type: NotificationType.order,
  ),
  NotificationItem(
    title: 'Special Offer!',
    message: 'Get 20% off on all shoes this weekend!',
    time: '1 hour ago',
    type: NotificationType.promo,
    isRead: true,
  ),
  NotificationItem(
    title: 'Out for Delivery',
    message: 'Your order #12344 is out for delivery.',
    time: '3 hours ago',
    type: NotificationType.delivery,
    isRead: true,
  ),
  NotificationItem(
    title: 'Payment Successful',
    message: 'Payment for order #12345 was successful.',
    time: '5 hours ago',
    type: NotificationType.payment,
    isRead: true,
  ),
];
