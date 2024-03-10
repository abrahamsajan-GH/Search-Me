// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:search_me/constants/constants.dart';
import 'package:search_me/screens/user/home_screen.dart';
import 'package:search_me/widgets/notifications.dart';

class AdminNotification extends StatelessWidget {
  final TextEditingController _notificationController = TextEditingController();

  AdminNotification({super.key});

  void sendNotification(BuildContext context) async {
    DateTime now = DateTime.now();

    Timestamp timestamp = Timestamp.fromDate(now);

    await FirebaseFirestore.instance.collection('notifications').add({
      'notification': _notificationController.text,
      'timestamp': timestamp,
    });

    _notificationController.clear();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Notification sent')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 150,
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              decoration: BoxDecoration(
                color: blueClr.withOpacity(0.3),
                borderRadius: br8,
              ),
              child: TextField(
                controller: _notificationController,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Type Notification...',
                  hintStyle: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: blackClr,
                  ),
                ),
              ),
            ),
            h5,
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => sendNotification(context),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(bGreyClr),
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: br6,
                  )),
                ),
                child: const Text(
                  'Send Notification',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: whiteClr,
                  ),
                ),
              ),
            ),
            h30,
            const Text(
              'Notifications',
              style: TextStyle(fontSize: 18),
            ),
            h10,
            const NotificationsList(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => const HomeScreen()),
                    (route) => false,
                  );
                },
                style: ButtonStyle(
                    backgroundColor: const MaterialStatePropertyAll(redClr),
                    shape: MaterialStatePropertyAll(
                        RoundedRectangleBorder(borderRadius: br6))),
                child: const Text(
                  'SIGN OUT',
                  style: TextStyle(color: whiteClr),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
