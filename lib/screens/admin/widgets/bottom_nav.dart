import 'package:flutter/material.dart';

ValueNotifier<int> indexChangeNotifier = ValueNotifier(0);

class BottomNavWidgets extends StatelessWidget {
  const BottomNavWidgets({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: indexChangeNotifier,
      builder: (context, int newIndex, _) {
        return BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.black,
          onTap: (index) => indexChangeNotifier.value = index,
          currentIndex: newIndex,
          selectedItemColor: Colors.white,
          selectedFontSize: 13,
          unselectedItemColor: Colors.grey,
          selectedIconTheme: const IconThemeData(
            color: Colors.white,
          ),
          unselectedIconTheme: const IconThemeData(
            color: Colors.grey,
          ),
          items: const [
            
            BottomNavigationBarItem(
                icon: Icon(Icons.notification_add), label: 'Notification'),
            BottomNavigationBarItem(
                icon: Icon(Icons.person), label: 'Registration'),
            BottomNavigationBarItem(
                icon: Icon(Icons.workspaces_outlined), label: 'Subscription'),
          ],
        );
      },
    );
  }
}
