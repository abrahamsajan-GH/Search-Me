import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:search_me/constants/constants.dart';

class NotificationsList extends StatelessWidget {
  const NotificationsList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('notifications')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final notifications = snapshot.data?.docs ?? [];

          return ListView.builder(
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final notification =
                  notifications[index].data() as Map<String, dynamic>;
              final notificationText = notification['notification'];
              final timestamp = notification['timestamp'];

              final dateTime = (timestamp as Timestamp).toDate();
              final date = '${dateTime.day}-${dateTime.month}-${dateTime.year}';
              final time = '${dateTime.hour}:${dateTime.minute}';

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(color: blackClr, borderRadius: br6),
                  child: ListTile(
                    title: Text(
                      notificationText,
                      style: const TextStyle(color: whiteClr, fontSize: 14),
                    ),
                    subtitle: Text(
                      '$date $time',
                      style: const TextStyle(color: greyClr, fontSize: 12),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
