import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:auto_route/auto_route.dart';

import '../theme/styles/app_colors.dart';
import '../routes/app_router.dart';
import 'shared_bottom_navbar.dart';
import '../../features/home_page/presentation/page/home_page.dart';
import '../../features/inventory/presentation/pages/inventory_screen.dart';
import '../../features/customer/profile/presentation/screens/profile_settings_screen.dart';

class GlobalNavigationWrapper extends StatefulWidget {
  final Widget child;
  final int initialIndex;

  const GlobalNavigationWrapper({
    super.key,
    required this.child,
    this.initialIndex = 0,
  });

  @override
  State<GlobalNavigationWrapper> createState() {
    print(
        '🏗️ GlobalNavigationWrapper createState called with initialIndex: $initialIndex');
    return GlobalNavigationWrapperState();
  }
}

class GlobalNavigationWrapperState extends State<GlobalNavigationWrapper> {
  late int _currentIndex;
  late PageController _pageController;

  GlobalNavigationWrapperState() {
    print('🔄 GlobalNavigationWrapperState constructor called');
  }

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: _currentIndex);
    print(
        '🏠 GlobalNavigationWrapper initState: initialIndex=${widget.initialIndex}, currentIndex=$_currentIndex');

    // Ensure the PageController is properly initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_pageController.hasClients) {
        print('🎯 PostFrameCallback: Animating to page $_currentIndex');
        _pageController.animateToPage(
          _currentIndex,
          duration: const Duration(milliseconds: 1),
          curve: Curves.linear,
        );
      } else {
        print('⚠️ PostFrameCallback: PageController has no clients yet');
      }
    });
  }

  @override
  void didUpdateWidget(GlobalNavigationWrapper oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialIndex != widget.initialIndex) {
      print(
          '🔄 GlobalNavigationWrapper didUpdateWidget: oldIndex=${oldWidget.initialIndex}, newIndex=${widget.initialIndex}');
      _currentIndex = widget.initialIndex;
      _pageController.animateToPage(
        widget.initialIndex,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      print('✅ Animated to page index: ${widget.initialIndex}');
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void onItemTap(int index) {
    print(
        '🎯 GlobalNavigationWrapper.onItemTap: index=$index, currentIndex=$_currentIndex');
    if (index != _currentIndex) {
      setState(() {
        _currentIndex = index;
      });
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      print('✅ Switched to page index: $index');
    } else {
      print('ℹ️ Already on page index: $index, no change needed');
    }
  }

  Widget _getPage(int index) {
    print('📄 _getPage called with index: $index');
    switch (index) {
      case 0:
        print('  → Returning HomePage');
        return const HomePage();
      case 1:
        print('  → Returning InventoryPage');
        return const InventoryPage();
      case 2:
        print('  → Returning ProfileSettingsScreen');
        return const ProfileSettingsScreen();
      case 3:
        print('  → Returning Settings placeholder');
        return _buildPlaceholderPage('Settings');
      default:
        print('  → Returning HomePage (default)');
        return const HomePage();
    }
  }

  Widget _buildPlaceholderPage(String title) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.construction,
              size: 64.sp,
              color: AppColors.primaryBurntOrange,
            ),
            SizedBox(height: 16.h),
            Text(
              '$title Page',
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.textDarkBrown,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'Coming Soon',
              style: TextStyle(
                fontSize: 16.sp,
                color: AppColors.textDarkBrown.withOpacity(0.7),
              ),
            ),
          ],
        ),
      ),
    );
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
        itemBuilder: (context, index) {
          return _getPage(index);
        },
      ),
      bottomNavigationBar: SharedBottomNavbar(
        currentIndex: _currentIndex,
        onCenterButtonTap: () {
          // Navigate to Add New Item screen
          context.router.push(const AddNewItemRoute());
        },
      ),
    );
  }
}
