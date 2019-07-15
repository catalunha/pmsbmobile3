import 'package:flutter/material.dart';
import 'package:pmsbmibile3/components/square_image.dart';
import 'package:pmsbmibile3/models/usuario_model.dart';
import 'package:pmsbmibile3/models/usuario_perfil_model.dart';
import 'administracao_perfil_page_bloc.dart';
import 'package:pmsbmibile3/bootstrap.dart';
import 'package:url_launcher/url_launcher.dart';

class AdministracaoPerfilPage extends StatelessWidget {
  final bloc = AdministracaoPerfilPageBloc(Bootstrap.instance.firestore);

  @override
  Widget build(BuildContext context) {
    var usuarioId = ModalRoute.of(context).settings.arguments;
    if (usuarioId != null) {
      bloc.administracaoPerfilPageEventSink(UpdateUsuarioIdEvent(usuarioId));
    }
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: Colors.red,
        centerTitle: true,
        title: Text("Visualizar dados e perfil"),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 12),
        child: _body(),
      ),
    );
  }

  Widget _body() {
    return StreamBuilder<UsuarioModel>(
        stream: bloc.usuarioModelStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text("Error"),
            );
          }
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return Container(
              child: Column(children: <Widget>[
            Padding(padding: EdgeInsets.all(10)),
            Expanded(
              flex: 2,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                      flex: 2,
                      child: SquareImage(
                        image: NetworkImage(snapshot.data.usuarioArquivoID.url),
                      )),
                  Expanded(
                      flex: 5,
                      child: Container(
                        padding: EdgeInsets.only(left: 6),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text("ID: ${snapshot.data.id.substring(0, 10)}"),
                            Text("Nome: ${snapshot.data.nome}"),
                            Text("Celular: ${snapshot.data.celular}"),
                            Text("Email: ${snapshot.data.email}"),
                            Text("Eixo: ${snapshot.data.eixoIDAtual.nome}"),
                          ],
                        ),
                      ))
                ],
              ),
            ),
            Padding(
                padding: EdgeInsets.all(5),
                child: Text(
                  "Documentos do usuario:",
                  style: TextStyle(fontSize: 16),
                )),
            Padding(padding: EdgeInsets.all(10)),
            Expanded(
              flex: 6,
              child: StreamBuilder<List<UsuarioPerfil>>(
                  stream: bloc.usuarioPerfilModelStream,
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Center(
                        child: Text("Erro"),
                      );
                    }
                    if (!snapshot.hasData) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return ListView(
                      children: <Widget>[
                        // ignore: sdk_version_ui_as_code
                        ...snapshot.data.map((variavel) {
                          if (variavel.perfilID.contentType != 'text/plain') {
                            return Card(
                                child: InkWell(
                                    onTap: () {
                                      launch(variavel.conteudo);
                                    },
                                    child: ListTile(
                                      title: Text(
                                        "${variavel.perfilID.nome}:",
                                        style: TextStyle(fontSize: 14),
                                      ),
                                      subtitle: Text(
//                                        "${variavel.conteudo}",
                                        "CLIQUE AQUI PARA VER O ARQUIVO",
                                        style: TextStyle(fontSize: 16, color: Colors.blue),
                                      ),
                                    )));
                          } else {
                            return Card(
                                child: ListTile(
                              title: Text(
                                ">>${variavel.perfilID.nome}:",
                                style: TextStyle(fontSize: 14),
                              ),
                              subtitle: Text(
                                "${variavel.conteudo}",
                                style: TextStyle(fontSize: 16),
                              ),
                            ));
                          }
                        }).toList()
                      ],
                    );
                  }),
            ),
          ]));
        });
  }
}
