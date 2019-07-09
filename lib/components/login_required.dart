import 'package:pmsbmibile3/state/auth_bloc.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:pmsbmibile3/pages/autenticacao/login.dart';
import 'package:pmsbmibile3/pages/geral/splash.dart';
import 'package:pmsbmibile3/pages/geral/loading.dart';

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
    final bloc = Provider.of<AuthBloc>(context);

    return StreamBuilder<AuthStatus>(
      stream: bloc.status,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text("ERROR"),
          );
        }
        if (!snapshot.hasData) {
          return loadingPage;
        }
        switch (snapshot.data) {
          case AuthStatus.Uninitialized:
            return splashPage;
          case AuthStatus.Unauthenticated:
            return loginPage;
          case AuthStatus.Authenticating:
            return loadingPage;
          case AuthStatus.Authenticated:
            return child;
        }
      },
    );
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
