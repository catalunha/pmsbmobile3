import 'package:flutter/material.dart';
import 'package:pmsbmibile3/models/usuario_model.dart';
import 'package:pmsbmibile3/state/auth_bloc.dart';

class EixoAtualUsuario extends StatelessWidget {
  final AuthBloc authBloc;

  EixoAtualUsuario(this.authBloc);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<UsuarioModel>(
      stream: authBloc.perfil,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text("ERROR"),
          );
        }
        if (!snapshot.hasData) {
          return Center(
            child: Text("SEM DADOS"),
          );
        }
        return Text(
          "Eixo: ${snapshot.data.eixoIDAtual.nome}",
          style: TextStyle(fontSize: 16, color: Colors.blue),
        );
      },
    );
  }
}
