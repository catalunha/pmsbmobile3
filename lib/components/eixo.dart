import 'package:flutter/material.dart';
import 'package:pmsbmibile3/models/usuario_model.dart';
import 'package:pmsbmibile3/state/auth_bloc.dart';
import 'package:provider/provider.dart';

class EixoAtualUsuario extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authBloc = Provider.of<AuthBloc>(context);
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
          "Eixo - ${snapshot.data.eixoIDAtual.nome}",
          style: TextStyle(fontSize: 16, color: Colors.blue),
        );
      },
    );
  }
}
