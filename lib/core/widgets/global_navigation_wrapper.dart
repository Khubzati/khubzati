import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';

import '../routes/app_router.dart';
import 'shared_bottom_navbar.dart';
import '../../features/home_page/presentation/page/home_page.dart';
import '../../features/inventory/presentation/pages/inventory_screen.dart';
import '../../features/history/presentation/screens/history_screen.dart';
import '../../features/menu/presentation/screens/profile_menu_screen.dart';

class GlobalNavigationWrapper extends StatefulWidget {
  final Widget child;
  final int initialIndex;

  const GlobalNavigationWrapper({
    super.key,
    required this.child,
    this.initialIndex = 0,
  });

  @override
  State<GlobalNavigationWrapper> createState() =>
      GlobalNavigationWrapperState();
}

class GlobalNavigationWrapperState extends State<GlobalNavigationWrapper> {
  late int _currentIndex;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void onItemTap(int index) {
    if (index == _currentIndex) return;

    // Handle profile tab (index 3) - just update index, ProfileMenuScreen is shown in PageView
    // No special navigation needed since it's part of the main navigation

    // Handle other tabs - update index and animate page
    setState(() {
      _currentIndex = index;
    });
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  Widget _getPage(int index) {
    switch (index) {
      case 0:
        return const HomePage();
      case 1:
        return const InventoryPage();
      case 2:
        return const HistoryScreen();
      case 3:
        // Return ProfileMenuScreen instead of navigating
        return const ProfileMenuScreen();
      default:
        return const HomePage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        itemCount: 4,
        itemBuilder: (context, index) => _getPage(index),
      ),
      bottomNavigationBar: SharedBottomNavbar(
        currentIndex: _currentIndex,
        onCenterButtonTap: () {
          context.router.push(const AddItemRoute());
        },
      ),
    );
  }
}
