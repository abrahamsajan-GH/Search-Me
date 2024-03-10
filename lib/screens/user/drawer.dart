import 'package:flutter/material.dart';
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
              color: Colors.indigo[300],
            ),
            child: const Center(
              child: Text(
                'Advertisement Plot',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          ListTile(
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => const Registration())),
            leading: const Icon(
              Icons.person_add,
              color: Colors.indigo,
            ),
            title: const Text(
              'Org Registration',
              style: TextStyle(
                color: Colors.indigo,
                fontSize: 16,
              ),
            ),
          ),
          ListTile(
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => const ScreenLogin())),
            leading: const Icon(
              Icons.login,
              color: Colors.indigo,
            ),
            title: const Text(
              'Sign In',
              style: TextStyle(
                color: Colors.indigo,
                fontSize: 16,
              ),
            ),
          ),
          const ListTile(
            leading: Icon(
              Icons.card_giftcard_outlined,
              color: Colors.indigo,
            ),
            title: Text(
              'Offers & Gifts',
              style: TextStyle(
                color: Colors.indigo,
                fontSize: 16,
              ),
            ),
          ),
          const ListTile(
            leading: Icon(
              Icons.phone,
              color: Colors.indigo,
            ),
            title: Text(
              'Contact',
              style: TextStyle(
                color: Colors.indigo,
                fontSize: 16,
              ),
            ),
          ),
          const AdPlotSmall(),
          const ListTile(
            leading: Icon(
              Icons.help,
              color: Colors.indigo,
            ),
            title: Text(
              'FAQ',
              style: TextStyle(
                color: Colors.indigo,
                fontSize: 16,
              ),
            ),
          ),
          const ListTile(
            leading: Icon(
              Icons.book,
              color: Colors.indigo,
            ),
            title: Text(
              'Terms & Conditions',
              style: TextStyle(
                color: Colors.indigo,
                fontSize: 16,
              ),
            ),
          ),
          const ListTile(
            leading: Icon(
              Icons.privacy_tip,
              color: Colors.indigo,
            ),
            title: Text(
              'Privacy Policy',
              style: TextStyle(
                color: Colors.indigo,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
