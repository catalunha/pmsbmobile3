import 'package:pmsbmibile3/api/auth_api_mobile.dart';
import 'package:pmsbmibile3/bootstrap.dart';
import 'package:pmsbmibile3/state/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:pmsbmibile3/pages/autenticacao/login.dart';
import 'package:pmsbmibile3/pages/geral/splash.dart';
import 'package:pmsbmibile3/pages/geral/loading.dart';

class LoginRequired extends StatelessWidget {
  final Widget loginPage;
  final Widget splashPage;
  final Widget loadingPage;
  final Widget child;
  final AuthBloc bloc;

  LoginRequired({
    @required this.loadingPage,
    @required this.loginPage,
    @required this.splashPage,
    @required this.child,
  })  : assert(loadingPage != null),
        assert(loginPage != null),
        assert(splashPage != null),
        assert(child != null),
        bloc = AuthBloc(AuthApiMobile(), Bootstrap.instance.firestore);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AuthStatus>(
      stream: bloc.status,
      builder: (context, snapshot) {
        Widget r = loadingPage;
        if (snapshot.hasError) {
          r = Center(
            child: Text("ERROR"),
          );
        }
        if (!snapshot.hasData) {
          r = loadingPage;
        }
        switch (snapshot.data) {
          case AuthStatus.Uninitialized:
            r = splashPage;
            break;
          case AuthStatus.Unauthenticated:
            r = loginPage;
            break;
          case AuthStatus.Authenticating:
            r = loadingPage;
            break;
          case AuthStatus.Authenticated:
            r = child;
            break;
        }
        return r;
      },
    );
  }
}

class DefaultLoginRequired extends StatelessWidget {
  final AuthBloc authBloc;
  final Widget child;

  DefaultLoginRequired({this.child, this.authBloc});

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
