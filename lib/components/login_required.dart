import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:pmsbmibile3/state/user_repository.dart';

import 'package:pmsbmibile3/pages/login.dart';
import 'package:pmsbmibile3/pages/splash.dart';
import 'package:pmsbmibile3/pages/loading.dart';

class LoginRequired extends StatelessWidget {
  final Widget loginPage;
  final Widget splashPage;
  final Widget loadingPage;
  final Widget child;

  LoginRequired({
    this.loadingPage,
    this.loginPage,
    this.splashPage,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    UserRepository userRepository = Provider.of<UserRepository>(context);

    switch (userRepository.status) {
      case Status.Uninitialized:
        return splashPage;
      case Status.Unauthenticated:
        return loginPage;
      case Status.Authenticating:
        return loadingPage;
      case Status.Authenticated:
        return child;
    }
  }
}

class DefaultLoginRequired extends StatelessWidget {
  final Widget child;

  DefaultLoginRequired({
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return LoginRequired(
      splashPage: SplashPage(),
      loginPage: LoginPage(),
      loadingPage: LoadingPage(),
      child: child,
    );
  }
}
