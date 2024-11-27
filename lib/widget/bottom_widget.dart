import 'package:flutter/material.dart';

import '../pages/discusion_screen.dart';
import '../pages/home.dart';
import '../pages/leaderboard_screen.dart';
import '../pages/profile_screen.dart';

class MyBottomBar extends StatefulWidget {
  const MyBottomBar({super.key});

  @override
  _MyBottomBarState createState() =>
      _MyBottomBarState();
}

class _MyBottomBarState extends State<MyBottomBar> {
  int _selectedIndex = 0; // to keep track of the selected screen

  // Define your screens
  final List<Widget> _screens = [
    const MyHomeScreen(), // Home Screen
    const LeaderboardScreen(), // Leaderboard Screen
    const DiscussionForumsScreen(), // Discussion Forums Screen
    const ProfileScreen(), // Profile Screen
  ];

  // This method handles the tap on navigation bar items
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex, // retain the state of each screen
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 0,
        backgroundColor: Colors.grey,

        currentIndex: _selectedIndex, // this will highlight the selected item
        onTap: _onItemTapped, // method to handle taps
        showSelectedLabels: true, // show the label of the selected item
        showUnselectedLabels: false, // hide labels of unselected items
        type: BottomNavigationBarType.shifting, // prevents shifting when selected
        selectedItemColor: Theme.of(context).primaryColor, // active icon color
        unselectedItemColor: Colors.grey, // inactive icon color
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.leaderboard),
            label: 'Leaderboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.forum),
            label: 'Forums',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
