import 'package:flutter/material.dart';
import 'package:pmsbmibile3/components/login_required.dart';
import 'package:pmsbmibile3/pages/geral/bemvindo.dart';
import 'package:pmsbmibile3/state/auth_bloc.dart';

class HomePage extends StatefulWidget {
final AuthBloc authBloc;
  HomePage(this.authBloc);

  _HomePageState createState() => _HomePageState(this.authBloc);
}

class _HomePageState extends State<HomePage> {

  final AuthBloc authBloc;
  _HomePageState(this.authBloc);

  @override
  Widget build(BuildContext context) {
    return DefaultLoginRequired(
      child: BemVindo(widget.authBloc),
      // child: NoticiaLeituraPage(),
      authBloc: this.authBloc,
      // child: NoticiasNaoVisualizadasPage(),
    );
  }
}
