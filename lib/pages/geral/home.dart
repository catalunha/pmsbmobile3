import 'package:flutter/material.dart';
import 'package:pmsbmibile3/components/login_required.dart';
import 'package:pmsbmibile3/pages/comunicacao/noticia_leitura_page.dart';
import 'package:pmsbmibile3/state/auth_bloc.dart';

class HomePage extends StatelessWidget {
  final AuthBloc authBloc;
  HomePage(this.authBloc);

  @override
  Widget build(BuildContext context) {
    return DefaultLoginRequired(
      child: NoticiaLeituraPage(),
      authBloc: this.authBloc,
      // child: NoticiasNaoVisualizadasPage(),
    );
  }
}
