import 'package:flutter/material.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import 'home_screen.dart';
import 'bookmark_screen.dart';
import 'profile_screen.dart';

class MainWrapper extends StatefulWidget {
  final AppState appState;

  const MainWrapper({super.key, required this.appState});

  @override
  State<MainWrapper> createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper> {
  int _currentIndex = 0;

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void navigateToTab(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.appState.isDarkMode;

    final pages = [
      HomeScreen(
        appState: widget.appState,
        onNavigateToBookmarks: () => _onTabTapped(1),
      ),
      BookmarkScreen(
        appState: widget.appState,
        onNavigateToHome: () => _onTabTapped(0),
      ),
      ProfileScreen(appState: widget.appState),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: pages,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: _onTabTapped,
        backgroundColor:
            isDark ? const Color(0xFF131A15) : Colors.white,
        destinations: [
          const NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Badge(
              isLabelVisible: widget.appState.bookmarkedIds.isNotEmpty,
              label: Text(
                '${widget.appState.bookmarkedIds.length}',
                style: const TextStyle(fontSize: 10),
              ),
              backgroundColor: AppTheme.chiliRed,
              child: const Icon(Icons.bookmark_outline_rounded),
            ),
            selectedIcon: Badge(
              isLabelVisible: widget.appState.bookmarkedIds.isNotEmpty,
              label: Text(
                '${widget.appState.bookmarkedIds.length}',
                style: const TextStyle(fontSize: 10),
              ),
              backgroundColor: AppTheme.chiliRed,
              child: const Icon(Icons.bookmark_rounded),
            ),
            label: 'Tersimpan',
          ),
          const NavigationDestination(
            icon: Icon(Icons.person_outline_rounded),
            selectedIcon: Icon(Icons.person_rounded),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}
