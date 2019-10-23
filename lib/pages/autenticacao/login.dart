import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pmsbmibile3/naosuportato/permission_handler.dart'
    if (dart.library.io) 'package:permission_handler/permission_handler.dart';
import 'package:pmsbmibile3/state/auth_bloc.dart';

class LoginPage extends StatefulWidget {
  // final AuthBloc authBloc =
  //     Bootstrap.instance.authBloc
  // LoginPage();

  final AuthBloc authBloc;

  LoginPage(this.authBloc);

  @override
  LoginPageState createState() {
    return LoginPageState(this.authBloc);
  }
}

class LoginPageState extends State<LoginPage> {
  // PermissionStatus _status;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final AuthBloc authBloc;

  LoginPageState(this.authBloc);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _checkPermission();
  }

  void _checkPermission() async {
    var a = PermissionHandler().checkPermissionStatus(PermissionGroup.storage);
    await a.then(_updateStatus);
  }

  FutureOr _updateStatus(PermissionStatus value) {
    if (value == PermissionStatus.denied) {
      _askPermission();
    }
  }

  _askPermission() async {
    var a = PermissionHandler().requestPermissions([
      PermissionGroup.storage,
    ]);
    await a.then(_onStatusRequested);
  }

  FutureOr _onStatusRequested(Map<PermissionGroup, PermissionStatus> value) {
    _updateStatus(value[PermissionGroup.storage]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: 24,
          ),
          child: ListView(
            children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 12,
                        ),
                        child: Center(
                          child: Text(
                          'PMSB - 22 - TO',
                          style: TextStyle(fontSize: 30, color: Colors.blue),
                        ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 12,
                        ),
                        child: TextFormField(
                          onSaved: (email) {
                            authBloc.dispatch(UpdateEmailAuthBlocEvent(email));
                          },
                          decoration: InputDecoration(
                            hintText: "Informe seu email",
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 12,
                        ),
                        child: TextFormField(
                          onSaved: (password) {
                            authBloc.dispatch(
                                UpdatePasswordAuthBlocEvent(password));
                          },
                          obscureText: true,
                          decoration: InputDecoration(
                            hintText: "Informe sua senha",
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 12,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 4,
                        ),
                        child: RaisedButton(
                          child: Text("Acessar com email e senha"),
                          onPressed: () {
                            _formKey.currentState.save();
                            authBloc.dispatch(LoginAuthBlocEvent());
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                alignment: Alignment.center,
                child: Image.asset('assets/images/logos/Splash_1024x1024.png'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
