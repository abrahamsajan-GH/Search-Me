import 'package:flutter/material.dart';
import 'package:search_me/screens/org/org_bott_nav.dart';
import 'package:search_me/screens/org/org_home.dart';
import 'package:search_me/screens/org/org_notif.dart';
import 'package:search_me/screens/org/org_profile.dart';
import 'package:search_me/screens/org/org_subs.dart';

class OrgLanding extends StatelessWidget {
  OrgLanding({super.key});

  final pages = [
    const OrgHome(),
    const OrgNotification(),
    const OrgProfile(),
    const OrgSubscriptions(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: ValueListenableBuilder(
        valueListenable: indexChangeNotifier,
        builder: (context, int index, child) => pages[index],
      )),
      bottomNavigationBar: const OrgBottomNavWidgets(),
    );
  }
}
