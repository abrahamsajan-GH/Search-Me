import 'package:flutter/material.dart';
import 'package:search_me/screens/admin/admin_home.dart';
import 'package:search_me/screens/admin/admin_notif.dart';
import 'package:search_me/screens/admin/admin_reg.dart';
import 'package:search_me/screens/admin/admin_subs.dart';
import 'package:search_me/screens/admin/bottom_nav.dart';

class AdminLanding extends StatelessWidget {
  AdminLanding({super.key});

  final pages = [
    const AdminHome(),
    AdminNotification(),
    const AdminRegistration(),
    const AdminSubscriptions(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: ValueListenableBuilder(
        valueListenable: indexChangeNotifier,
        builder: (context, int index, child) => pages[index],
      )),
      bottomNavigationBar: const BottomNavWidgets(),
    );
  }
}
