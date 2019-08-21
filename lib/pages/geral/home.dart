import 'package:flutter/material.dart';
import 'package:pmsbmibile3/components/login_required.dart';
import 'package:pmsbmibile3/pages/comunicacao/noticia_leitura_page.dart';
import 'package:pmsbmibile3/state/auth_bloc.dart';

class HomePage extends StatefulWidget {
final AuthBloc authBloc;
  HomePage(this.authBloc);

  _HomePageState createState() => _HomePageState(this.authBloc);
}

class _HomePageState extends State<HomePage> {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//        child: child,
//     );
//   }
// }

// class HomePage extends StatelessWidget {
  final AuthBloc authBloc;
  _HomePageState(this.authBloc);

  @override
  Widget build(BuildContext context) {
    return DefaultLoginRequired(
      child: NoticiaLeituraPage(),
      authBloc: this.authBloc,
      // child: NoticiasNaoVisualizadasPage(),
    );
  }
}
