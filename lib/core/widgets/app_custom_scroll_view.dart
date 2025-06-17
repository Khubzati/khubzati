import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppCustomScrollView extends StatelessWidget {
  final List<Widget> children;
  final List<Widget>? bottomChildren;
  final EdgeInsetsGeometry? padding;
  const AppCustomScrollView({
    super.key,
    required this.children,
    this.bottomChildren,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const ClampingScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding:
                padding ?? EdgeInsets.only(top: 20.w, right: 25.w, left: 25.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: children,
            ),
          ),
        ),
        SliverFillRemaining(
          hasScrollBody: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            children: bottomChildren ?? [],
          ),
        )
      ],
    );
  }
}
