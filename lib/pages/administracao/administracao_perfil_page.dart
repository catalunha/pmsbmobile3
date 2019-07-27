import 'package:flutter/material.dart';
import 'package:pmsbmibile3/models/usuario_model.dart';
import 'package:pmsbmibile3/models/usuario_perfil_model.dart';
import 'package:pmsbmibile3/services/services.dart';
import 'administracao_perfil_page_bloc.dart';
import 'package:pmsbmibile3/bootstrap.dart';
import 'package:url_launcher/url_launcher.dart';

class AdministracaoPerfilPage extends StatelessWidget {
  final bloc = AdministracaoPerfilPageBloc(Bootstrap.instance.firestore);

  void dispose() {
    bloc.dispose();
  }

  //auxiliares
  var usuarioModelData;

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
    return Column(children: <Widget>[
      Expanded(
          flex: 1,
          child: StreamBuilder<UsuarioModel>(
              stream: bloc.usuarioModelStream,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text("Error"),
                  );
                }
                if (!snapshot.hasData) {
                  return Center(
                    child: Text("Sem perfil em pdf/csv/web"),
                  );
                }
                usuarioModelData = snapshot.data;
                return Container(
                  child: Column(children: <Widget>[
                    Padding(padding: EdgeInsets.all(3)),
                    Expanded(
                      flex: 2,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                            flex: 2,
                            child: _ImagemUnica(
                              fotoLocalPath: usuarioModelData?.foto?.localPath,
                              fotoUrl: usuarioModelData?.foto?.url,
                            ),
                          ),
                          Expanded(
                              flex: 5,
                              child: Container(
                                // padding: EdgeInsets.only(left: 6),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                        "ID: ${snapshot.data.id.substring(0, 10)}"),
                                    Text("Nome: ${snapshot.data.nome}"),
                                    Text("Celular: ${snapshot.data.celular}"),
                                    Text("Email: ${snapshot.data.email}"),
                                    Text(
                                        "Eixo: ${snapshot.data.eixoIDAtual.nome}"),
                                  ],
                                ),
                              ))
                        ],
                      ),
                    ),
                  ]),
                );
              })),
      Expanded(
        flex: 0,
        child: StreamBuilder<AdministracaoPerfilPageState>(
          stream: bloc.administracaoPerfilPageStateStream,
          builder: (BuildContext context,
              AsyncSnapshot<AdministracaoPerfilPageState> snapshotState) {
            if (snapshotState.hasError) {
              return Center(
                child: Text("Error"),
              );
            }
            if (!snapshotState.hasData) {
              return Center(
                child: Text("Sem dados de perfil"),
              );
            }
            return ButtonTheme.bar(
              child: ButtonBar(
                children: <Widget>[
                  Text('csv'),
                  IconButton(
                    icon: Icon(Icons.border_bottom),
                    onPressed: () {
                      GeradorCsvService.generateCsvFromUsuarioModel(
                          usuarioModelData);
                      //launch(snapshotState.data.urlCSV);
                    },
                  ),
                  // Text('web'),
                  // IconButton(
                  //   icon: Icon(Icons.web),
                  //   onPressed: () {
                  //     launch(snapshotState.data.urlMD);
                  //   },
                  // ),
                  Text('pdf'),
                  IconButton(
                    icon: Icon(Icons.picture_as_pdf),
                    onPressed: () {
                      var mdtext = GeradorMdService.generateMdFromUsuarioModel(
                          usuarioModelData);
                      GeradorPdfService.generatePdfFromMd(mdtext);
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
      Expanded(
        flex: 4,
        child: StreamBuilder<List<UsuarioPerfilModel>>(
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
                    if (variavel.perfilID.contentType == 'text') {
                      return Card(
                          color: variavel.textPlain == null
                              ? Colors.yellowAccent
                              : Colors.white,
                          child: ListTile(
                            title: Text(
                              "${variavel.perfilID.nome}:",
                              style: TextStyle(fontSize: 14),
                            ),
                            subtitle: Text(
                              "${variavel.textPlain}",
                              style: TextStyle(fontSize: 16),
                            ),
                          ));
                    } else {
                      if (variavel.arquivo == null) {
                        return Card(
                            color: Colors.yellowAccent,
                            child: ListTile(
                              title: Text(
                                "${variavel.perfilID.nome}:",
                                style: TextStyle(fontSize: 14),
                              ),
                              subtitle: Text(
                                "null",
                                style: TextStyle(fontSize: 16),
                              ),
                            ));
                      } else {
                        return Card(
                            child: InkWell(
                                onTap: () {
                                  variavel?.arquivo?.url != null
                                      ? launch(variavel.arquivo.url)
                                      : {};
                                },
                                child: ListTile(
                                  title: Text(
                                    "${variavel.perfilID.nome}:",
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  subtitle: variavel?.arquivo?.url != null ? Text(
                                    "CLIQUE AQUI PARA VER O ARQUIVO",
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.blue),
                                  ): Text('Url não disponivel. Usuario não fez upload.'),
                                )));
                      }
                    }
                  }).toList()
                ],
              );
            }),
      ),
    ]);
  }
}

class _ImagemUnica extends StatelessWidget {
  final String fotoUrl;
  final String fotoLocalPath;

  const _ImagemUnica({this.fotoUrl, this.fotoLocalPath});

  @override
  Widget build(BuildContext context) {
    Widget foto;
    if (fotoUrl == null && fotoLocalPath == null) {
      foto = Center(child: Text('Sem imagem.'));
    } else if (fotoUrl != null) {
      foto = Container(
          child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Image.network(fotoUrl),
      ));
    } else {
      foto = Container(
          color: Colors.yellow,
          child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: Icon(Icons.people, size: 75), //Image.asset(fotoLocalPath),
          ));
    }

    return Row(
      children: <Widget>[
        Spacer(
          flex: 1,
        ),
        Expanded(
          flex: 8,
          child: foto,
        ),
        Spacer(
          flex: 1,
        ),
      ],
    );
  }
}
