import 'package:flutter/material.dart';
import 'package:search_me/constants/constants.dart';
import 'package:search_me/screens/user/login_screen.dart';
import 'package:search_me/screens/user/registration.dart';
import 'package:search_me/widgets/ad_plots.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: indigoClr[300],
            ),
            child: const Center(
              child: Text(
                'Advertisement Plot',
                style: TextStyle(
                    color: whiteClr, fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          ListTile(
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => const Registration())),
            leading: const Icon(
              Icons.person_add,
              color: indigoClr,
            ),
            title: const Text(
              'Org Registration',
              style: TextStyle(
                color: indigoClr,
                fontSize: 16,
              ),
            ),
          ),
          ListTile(
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => const ScreenLogin())),
            leading: const Icon(
              Icons.login,
              color: indigoClr,
            ),
            title: const Text(
              'Sign In',
              style: TextStyle(
                color: indigoClr,
                fontSize: 16,
              ),
            ),
          ),
          const ListTile(
            leading: Icon(
              Icons.card_giftcard_outlined,
              color: indigoClr,
            ),
            title: Text(
              'Offers & Gifts',
              style: TextStyle(
                color: indigoClr,
                fontSize: 16,
              ),
            ),
          ),
          const ListTile(
            leading: Icon(
              Icons.phone,
              color: indigoClr,
            ),
            title: Text(
              'Contact',
              style: TextStyle(
                color: indigoClr,
                fontSize: 16,
              ),
            ),
          ),
          const AdPlotSmall(),
          const ListTile(
            leading: Icon(
              Icons.help,
              color: indigoClr,
            ),
            title: Text(
              'FAQ',
              style: TextStyle(
                color: indigoClr,
                fontSize: 16,
              ),
            ),
          ),
          const ListTile(
            leading: Icon(
              Icons.book,
              color: indigoClr,
            ),
            title: Text(
              'Terms & Conditions',
              style: TextStyle(
                color: indigoClr,
                fontSize: 16,
              ),
            ),
          ),
          const ListTile(
            leading: Icon(
              Icons.privacy_tip,
              color: indigoClr,
            ),
            title: Text(
              'Privacy Policy',
              style: TextStyle(
                color: indigoClr,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
