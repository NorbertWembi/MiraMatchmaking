import 'package:flutter/material.dart';
import '../features/chat/chat_page.dart';
import '../features/swipe/view/swipe_screen.dart';
import '../features/matches/view/matches_screen.dart';
import 'notifications/notifications.dart'; // adjust path

class NavBar extends StatefulWidget {
  const NavBar({super.key});

  @override
  _NavBarState createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int _i = 0;

  void _onClick(int i) {
    if (i == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const ChatPage()),
      );
      return;
    }

    setState(() {
      _i = i;
    });
  }

  final List<Widget> _pages = [
    const SwipeScreen(),
    const MatchesScreen(),
    Center(
      child: Text(
        'Message Page',
        style: TextStyle(fontSize: 50),
      ),
    ),
    const NotificationsPage(), // FIXED
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_i],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        currentIndex: _i,
        onTap: _onClick,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Image.asset('assets/cards_inactive.png'),
            activeIcon: Image.asset('assets/cards_active.png'),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Image.asset('assets/indicator_inactive.png'),
            activeIcon: Image.asset('assets/indicator_active.png'),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Image.asset('assets/message_inactive.png'),
            activeIcon: Image.asset('assets/message_active.png'),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Image.asset('assets/people_inactive.png'),
            activeIcon: Image.asset('assets/people_active.png'),
            label: '',
          ),
        ],
      ),
    );
  }
}