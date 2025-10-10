import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import '../widgets/global_navigation_wrapper.dart';

@RoutePage()
class MainNavigationScreen extends StatelessWidget {
  final int initialIndex;

  const MainNavigationScreen({
    super.key,
    this.initialIndex = 0,
  });

  @override
  Widget build(BuildContext context) {
    print('MainNavigationScreen build: initialIndex=$initialIndex');
    return GlobalNavigationWrapper(
      key: UniqueKey(), // Force recreation every time
      initialIndex: initialIndex,
      child:
          const SizedBox.shrink(), // This will be replaced by PageView content
    );
  }
}
