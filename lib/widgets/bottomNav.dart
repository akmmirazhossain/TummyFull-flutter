import 'package:flutter/material.dart';

class BottomNav extends StatefulWidget {
  final Function(int) onTabTapped;

  BottomNav({required this.onTabTapped});

  @override
  _BottomNavState createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'MenuBN',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.list),
          label: 'My Orders',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.notifications),
          label: 'Notifications',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
      currentIndex: _selectedIndex,
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.black,
      onTap: (index) {
        setState(() {
          _selectedIndex = index;
        });
        widget.onTabTapped(index);
      },
      type: BottomNavigationBarType.fixed,
    );
  }
}
