import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pmsbmibile3/naosuportato/permission_handler.dart'
    if (dart.library.io) 'package:permission_handler/permission_handler.dart';
import 'package:pmsbmibile3/state/auth_bloc.dart';

class LoginPage extends StatefulWidget {
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
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFFFEB3B), Color(0xFFFBC02D)],
            ),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: 24,
          ),
          child: Form(
            key: _formKey,
            child: ListView(
              children: <Widget>[
                // New --------------------

                Padding(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.08),
                ),

                // Imagem de cima
                Align(
                  alignment: Alignment.center,
                  child: Image.asset('assets/images/img_login_top.png'),
                ),

                Padding(
                  padding: EdgeInsets.all(5),
                ),

                Container(
                  //color: Colors.white,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(color: Colors.black12, blurRadius: 5)
                      ]),
                  height: MediaQuery.of(context).size.height *
                      0.50, //altura da box de fundo
                  width: MediaQuery.of(context).size.width *
                      0.30, //largura da box de fundo
                  padding: EdgeInsets.only(top: 22), //altura da box de email
                  child: Column(
                    children: <Widget>[
                      // Entrada de email
                      Container(
                        width: MediaQuery.of(context).size.width *
                            0.80, //tamanho da box de texto email
                        height: MediaQuery.of(context).size.height *
                            0.08, //espessura da box de texto email
                        padding: EdgeInsets.only(
                            top: 5, left: 20, right: 20, bottom: 5),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(50)),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(color: Colors.black26, blurRadius: 5)
                            ]),
                        child: TextFormField(
                          onSaved: (email) {
                            authBloc.dispatch(UpdateEmailAuthBlocEvent(email));
                          },
                          style: TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            icon: Icon(
                              Icons.email,
                              color: Colors.black,
                            ),
                            hintText: 'E-mail',
                          ),
                        ),
                      ),

                      // Entrada de senha
                      Container(
                        width: MediaQuery.of(context).size.width *
                            0.80, //tamanho da box de texto senha
                        height: MediaQuery.of(context).size.height *
                            0.08, //espessura da box de texto senha
                        margin: EdgeInsets.only(
                            top: 15), //distância de uma box para a outra
                        padding: EdgeInsets.only(
                            top: 5, left: 20, right: 20, bottom: 5),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(50)),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(color: Colors.black26, blurRadius: 5)
                            ]),
                        child: TextFormField(
                          onSaved: (password) {
                            authBloc.dispatch(
                                UpdatePasswordAuthBlocEvent(password));
                          },
                          obscureText: true,
                          style: TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            icon: Icon(
                              Icons.vpn_key,
                              color: Colors.black,
                            ),
                            hintText: 'Senha',
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.05,
                        ),
                      ),

                      // Botao

                      GestureDetector(
                        onTap: () {
                          _formKey.currentState.save();
                          authBloc.dispatch(LoginAuthBlocEvent());
                        },
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.08,
                          width: MediaQuery.of(context).size.width *
                              0.40, // tamanho do botão entrar,
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Color(0xFFFFEB3B), Color(0xFFFBC02D)],
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50))),
                          child: Center(
                            child: Text(
                              'entrar'.toUpperCase(),
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14),
                            ),
                          ),
                        ),
                      ),

                      Padding(
                        padding: EdgeInsets.only(top: 10),
                      ),

                      Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                            padding: const EdgeInsets.only(
                              top: 35,
                              right: 25,
                              bottom: 0,
                            ), // posições do texto esqueci minha senha
                            child: GestureDetector(
                              onTap: () {
                                _formKey.currentState.save();
                                authBloc.dispatch(ResetPasswordAuthBlocEvent());
                              },
                              child: Text(
                                'Esqueci minha senha',
                                style: TextStyle(color: Colors.blueAccent),
                              ),
                            )),
                      ),
                    ],
                  ),
                ),

                // Imagem inferior
                Padding(
                  padding: EdgeInsets.only(
                      top: 5), //distância da imagem para a box de fundo
                  child: Align(
                    alignment: Alignment.center,
                    child: Image.asset('assets/images/img_login_bot.png'),
                  ),
                ),

                // Old --------------------
                // Container(
                //   padding: EdgeInsets.symmetric(
                //     horizontal: 24,
                //     vertical: 12,
                //   ),
                //   child: Form(
                //     key: _formKey,
                //     child: Column(
                //       crossAxisAlignment: CrossAxisAlignment.stretch,
                //       children: <Widget>[
                //         Container(
                //           padding: EdgeInsets.symmetric(
                //             vertical: 12,
                //           ),
                //           child: Center(
                //             child: Text(
                //               'PMSB - 22 - TO',
                //               style: TextStyle(fontSize: 30, color: Colors.blue),
                //             ),
                //           ),
                //         ),
                //         Container(
                //           padding: EdgeInsets.symmetric(
                //             vertical: 12,
                //           ),
                //           child: TextFormField(
                //             onSaved: (email) {
                //               authBloc.dispatch(UpdateEmailAuthBlocEvent(email));
                //             },
                //             decoration: InputDecoration(
                //               hintText: "Informe seu email",
                //             ),
                //           ),
                //         ),
                //         Container(
                //           padding: EdgeInsets.symmetric(
                //             vertical: 12,
                //           ),
                //           child: TextFormField(
                //             onSaved: (password) {
                //               authBloc.dispatch(
                //                   UpdatePasswordAuthBlocEvent(password));
                //             },
                //             obscureText: true,
                //             decoration: InputDecoration(
                //               hintText: "Informe sua senha",
                //             ),
                //           ),
                //         ),
                //         Padding(
                //           padding: EdgeInsets.symmetric(
                //             vertical: 12,
                //           ),
                //         ),
                //         Container(
                //           padding: EdgeInsets.symmetric(
                //             vertical: 4,
                //           ),
                //           child: RaisedButton(
                //             child: Text("Acessar com email e senha"),
                //             onPressed: () {
                //               _formKey.currentState.save();
                //               authBloc.dispatch(LoginAuthBlocEvent());
                //             },
                //           ),
                //         ),
                //         Container(
                //           padding: EdgeInsets.symmetric(
                //             vertical: 4,
                //           ),
                //           child: RaisedButton(
                //             child: Text("Resetar senha"),
                //             onPressed: () {
                //               _formKey.currentState.save();
                //               authBloc.dispatch(ResetPasswordAuthBlocEvent());
                //             },
                //           ),
                //         ),
                //       ],
                //     ),
                //   ),
                // ),
                // Container(
                //   alignment: Alignment.center,
                //   child: Image.asset('assets/images/logos/Splash_1024x1024.png'),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
