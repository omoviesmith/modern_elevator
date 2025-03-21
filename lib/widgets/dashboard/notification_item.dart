// modern_elevator_app/lib/widgets/dashboard/notification_item.dart
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

class NotificationItem extends StatelessWidget {
  final String message;
  final DateTime timestamp;
  final VoidCallback? onTap;

  const NotificationItem({
    Key? key,
    required this.message,
    required this.timestamp,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: Color(0xFF121212),
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: ListTile(
          leading: Icon(
            Icons.notifications,
            color: Color(0xFFF7D104),
          ),
          title: Text(
            message,
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
          subtitle: Text(
            timeago.format(timestamp),
            style: TextStyle(
              fontSize: 14,
              color: Colors.white70,
            ),
          ),
        ),
      ),
    );
  }
}