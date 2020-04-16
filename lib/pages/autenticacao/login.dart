import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pmsbmibile3/naosuportato/permission_handler.dart'
    if (dart.library.io) 'package:permission_handler/permission_handler.dart';
import 'package:pmsbmibile3/state/auth_bloc.dart';
import 'package:pmsbmibile3/style/pmsb_colors.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class LoginPageSizeMap {
  final double symmetricHorizontal;
  final double alturaTextField;
  final double larguraTextField;
  final double alturaBotao;
  final double larguraBotao;
  final double tamanhoMinCaixaLogin;

  LoginPageSizeMap(
      {this.symmetricHorizontal,
      this.alturaTextField,
      this.larguraTextField,
      this.alturaBotao,
      this.larguraBotao,
      this.tamanhoMinCaixaLogin,});
}

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

  LoginPageSizeMap loginPageSizeMap;

  double alturaTela;
  double larguraTela;

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

  LoginPageSizeMap definirSizeMap(BuildContext context) {
    if (kIsWeb) {
      return LoginPageSizeMap(
        symmetricHorizontal: MediaQuery.of(context).size.width * 0.30,
        tamanhoMinCaixaLogin: MediaQuery.of(context).size.width * 0.40 ,
        alturaTextField: MediaQuery.of(context).size.height * 0.06,
        larguraTextField: MediaQuery.of(context).size.width * 0.38,
        alturaBotao: MediaQuery.of(context).size.height * 0.06,
        larguraBotao: MediaQuery.of(context).size.width * 0.20,
      );
    } else {
      return LoginPageSizeMap(
        symmetricHorizontal: 20,
        tamanhoMinCaixaLogin: MediaQuery.of(context).size.width * 0.80 ,
        alturaTextField: MediaQuery.of(context).size.height * 0.08,
        larguraTextField: MediaQuery.of(context).size.width * 0.80,
        alturaBotao: MediaQuery.of(context).size.height * 0.08,
        larguraBotao: MediaQuery.of(context).size.width * 0.40,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    loginPageSizeMap = definirSizeMap(context);

    return Scaffold(
      body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(color: PmsbColors.fundo),
          padding: EdgeInsets.symmetric(
            horizontal: this.loginPageSizeMap.symmetricHorizontal,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // Imagem de cima
                Image.asset('assets/images/img_login_top.png'),

                Padding(
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.03,
                  ),
                ),

                Container(
                  constraints: BoxConstraints(minWidth: this.loginPageSizeMap.tamanhoMinCaixaLogin ),

                  //color: Colors.white,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                    color: PmsbColors.texto_primario,
                    boxShadow: [
                      BoxShadow(color: Colors.black12, blurRadius: 5),
                    ],
                  ),

                  padding: EdgeInsets.only(top: 22),
                  child: Column(
                    children: <Widget>[
                      // Entrada de email
                      Container(
                        width: this.loginPageSizeMap.larguraTextField,
                        height: this.loginPageSizeMap.alturaTextField,
                        padding: EdgeInsets.only(
                          top: 5,
                          left: 20,
                          right: 20,
                          bottom: 5,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(color: Colors.black26, blurRadius: 5)
                          ],
                        ),
                        child: TextFormField(
                          onSaved: (email) {
                            authBloc.dispatch(UpdateEmailAuthBlocEvent(email));
                          },
                          style: TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            icon: Icon(
                              Icons.email,
                              color: Colors.black54,
                            ),
                            hintText: 'E-mail',
                          ),
                        ),
                      ),

                      // Entrada de senha
                      Container(
                        width: this.loginPageSizeMap.larguraTextField,
                        height: this.loginPageSizeMap.alturaTextField,
                        margin: EdgeInsets.only(
                            top: 15), //distância de uma box para a outra
                        padding: EdgeInsets.only(
                          top: 5,
                          left: 20,
                          right: 20,
                          bottom: 5,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(color: Colors.black26, blurRadius: 5)
                          ],
                        ),
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
                              color: Colors.black54,
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
                          height: this.loginPageSizeMap.alturaBotao,
                          width: this.loginPageSizeMap.larguraBotao,
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  PmsbColors.cor_destaque,
                                  Colors.greenAccent
                                ],
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50))),
                          child: Center(
                            child: Text(
                              'entrar'.toUpperCase(),
                              style: TextStyle(
                                  color: Colors.white,
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
                              bottom: 10,
                            ), // posições do texto esqueci minha senha
                            child: GestureDetector(
                              onTap: () {
                                _formKey.currentState.save();
                                authBloc.dispatch(ResetPasswordAuthBlocEvent());
                              },
                              child: Text(
                                'Esqueci minha senha',
                                style: TextStyle(color: Colors.grey),
                              ),
                            )),
                      ),
                      Padding(
                        padding: EdgeInsets.all(5),
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.03,
                  ),
                ),

                // Imagem inferior
                Image.asset('assets/images/img_login_bot.png'),
              ],
            ),
          ),
        ),
    );
  }
}

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
