import 'package:flutter/material.dart';
import 'package:pmsbmibile3/state/auth_bloc.dart';
import 'package:provider/provider.dart';


class LoginPage extends StatefulWidget {
  @override
  LoginPageState createState() {
    return LoginPageState();
  }
}

class LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var authBloc = Provider.of<AuthBloc>(context);

    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: 24,
          ),
          child: ListView(
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                child: Image.asset('assets/images/logos/Splash_1024x1024.png'),
              ),
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
                            authBloc.dispatch(UpdatePasswordAuthBlocEvent(password));
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
