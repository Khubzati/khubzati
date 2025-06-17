import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:khubzati/core/routes/app_router.dart';

import '../bloc/data/data_cubit.dart';
import '../theme/styles/app_colors.dart';

import '../utils/snackbar.dart';

class AppBlocWrapperScreen<TBloc extends Cubit<TState>, TState>
    extends StatelessWidget {
  final TBloc? bloc;
  final BlocListener? blocListener;
  final PreferredSizeWidget? appBar;
  final Widget child;
  final Widget? drawer;
  final Widget? endDrawer;
  final Widget? bottomNavigationBar;
  final Color? backgroundColor;

  const AppBlocWrapperScreen({
    super.key,
    required this.child,
    this.bloc,
    this.blocListener,
    this.appBar,
    this.drawer,
    this.endDrawer,
    this.bottomNavigationBar,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor ?? AppColors.pageBackground,
      appBar: appBar ??
          AppBar(
            toolbarHeight: 0.w,
            scrolledUnderElevation: 0,
            backgroundColor: AppColors.primaryBurntOrange,
          ),
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: bloc != null
            ? BlocProvider<TBloc>(
                create: (context) => bloc!,
                child: _buildBlocListener(blocListener, child),
              )
            : _buildBlocListener(blocListener, child),
      ),
      drawer: drawer,
      endDrawer: endDrawer,
      bottomNavigationBar: bottomNavigationBar,
    );
  }

  MultiBlocListener _buildBlocListener(blocListener, child) {
    return MultiBlocListener(
      listeners: [
        BlocListener<DataCubit, DataState>(
          listener: (context, state) {
            state.whenOrNull(
              error: (message, statusCode) {
                if (statusCode == 401) {
                  _logout(context, message);
                } else {
                  showSnackBar(context, message, SnackBarStatus.error);
                }
              },
              success: (message) =>
                  showSnackBar(context, message, SnackBarStatus.success),
            );
          },
        ),
        if (blocListener != null) blocListener!
      ],
      child: child,
    );
  }

  void _logout(BuildContext context, String message) {
    context.router.replaceAll([const LoginRoute()]);
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => showGlobalSnackBar(message, SnackBarStatus.error),
    );
  }
}
