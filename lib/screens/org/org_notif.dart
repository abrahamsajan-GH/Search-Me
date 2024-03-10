import 'package:flutter/material.dart';
import 'package:search_me/constants/constants.dart';
import 'package:search_me/widgets/notifications.dart';

class OrgNotification extends StatelessWidget {
  const OrgNotification({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
          child: Padding(
        padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Notifications',
              style: TextStyle(fontSize: 16, color: blackClr),
            ),
            NotificationsList(),
          ],
        ),
      )),
    );
  }
}
