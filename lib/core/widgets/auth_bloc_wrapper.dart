// ignore_for_file: depend_on_referenced_packages

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../utils/utils.dart';
import 'app_bloc_wrapper_screen.dart';
import '../../features/auth/application/blocs/auth_bloc.dart';

class AuthBlocWrapper extends StatelessWidget {
  final void Function()? success;
  final Widget child;
  const AuthBlocWrapper({
    super.key,
    required this.child,
    this.success,
  });

  @override
  Widget build(BuildContext context) {
    return AppBlocWrapperScreen(
      blocListener: BlocListener<AuthBloc, AuthState>(
        listenWhen: (previous, current) {
          return context.router.current.name ==
              ModalRoute.of(context)?.settings.name;
        },
        listener: (context, state) {
          if (state is AuthLoading) {
            showAppLoadingDialog(context);
          } else if (state is AuthError) {
            context.router.popForced();
          } else if (state is Authenticated) {
              context.router.popForced();
              success?.call();
          }
        },
      ),
      child: child,
    );
  }
}
