import 'package:flutter/material.dart';
import 'package:pmsbmibile3/components/default_scaffold.dart';
import 'package:pmsbmibile3/pages/geral/geral_bloc.dart';
import 'package:pmsbmibile3/state/auth_bloc.dart';

class BemVindo extends StatefulWidget {
  final AuthBloc authBloc;

  BemVindo(this.authBloc);

  _BemVindoState createState() => _BemVindoState(this.authBloc);
}

class _BemVindoState extends State<BemVindo> {
  GeralBloc bloc;
  _BemVindoState(AuthBloc authBloc) : bloc = GeralBloc(authBloc);

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultScaffold(
      backToRootPage: false,
      title: StreamBuilder<GeralBlocState>(
        stream: bloc.stateStream,
        builder: (context, snap) {
          if (snap.hasError) {
            return Text("ERROR");
          }
          if (!snap.hasData) {
            return Text("Buscando usuario...");
          }
          return Text("Olá ${snap.data?.usuarioID?.nome}");
        },
      ),
      body: Center(
        child: Text(
            "Seja bem vindo(a)\nAo Aplicativo de gestão de dados para o\nPlano Municipal de Saneamento Básico\ndo estado do Tocantins.\nEscolha um menu a esquerda ou direita."),
      ),
    );
  }
}
