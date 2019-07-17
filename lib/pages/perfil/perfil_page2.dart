import 'package:flutter/material.dart';
import 'package:pmsbmibile3/bootstrap.dart';
import 'package:pmsbmibile3/models/models.dart';
import 'package:pmsbmibile3/models/usuario_perfil_model2.dart';
import 'package:pmsbmibile3/pages/perfil/perfil_page_bloc2.dart';
import 'package:provider/provider.dart';
import 'package:pmsbmibile3/state/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:pmsbmibile3/state/auth_bloc.dart';
import 'package:pmsbmibile3/pages/perfil/perfil_bloc.dart';

class PerfilPage extends StatelessWidget {
  // const PerfilPage({Key key}) : super(key: key);

  final bloc = PerfilPageBloc(Bootstrap.instance.firestore);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Perfil'),
      ),
      body: Container(
          child: StreamBuilder<List<UsuarioPerfilModel>>(
              stream: bloc.usuarioPerfilModelListStream,
              initialData: [],
              builder: (BuildContext context,
                  AsyncSnapshot<List<UsuarioPerfilModel>> snapshot) {
                if (snapshot.hasError) {
                  return Text('Erro ao listar perfil.');
                }
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return ListView(
                    children: snapshot.data
                        .map((usuarioPerfil) =>
                            _listTile(context, usuarioPerfil))
                        .toList());
              })),
    );
  }

  Widget _listTile(BuildContext context, UsuarioPerfilModel usuarioPerfil) {
    return Card(
      color: (usuarioPerfil.usuarioArquivoID == null) ==
              (usuarioPerfil.textPlain == null)
          ? Colors.yellow
          : Colors.white,
      child: InkWell(
        onTap: () {
          if (usuarioPerfil.perfilID.contentType == 'text') {
            Navigator.pushNamed(context, "/perfil/crudtext",
                arguments: usuarioPerfil.id);
          } else {
            Navigator.pushNamed(context, "/perfil/crudarq",
                arguments: usuarioPerfil.id);
          }
        },
        child: ListTile(
          title: Text('${usuarioPerfil.perfilID.nome}'),
          subtitle: usuarioPerfil.textPlain != null
              ? Text('${usuarioPerfil.textPlain}')
              : usuarioPerfil.usuarioArquivoID != null
                  ? Text('Arquivo anexado com sucesso.')
                  : Text('Informe o que se pede.'),
          trailing: usuarioPerfil.perfilID.contentType == 'text' ? Icon(Icons.edit):Icon(Icons.art_track),
        ),
      ),
    );
  }
}
