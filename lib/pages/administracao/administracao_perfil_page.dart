import 'package:flutter/material.dart';
import 'package:pmsbmibile3/models/usuario_model.dart';
import 'package:pmsbmibile3/models/usuario_perfil_model.dart';
import 'package:pmsbmibile3/state/auth_bloc.dart';
import 'administracao_perfil_page_bloc.dart';
import 'package:pmsbmibile3/bootstrap.dart';
import 'package:pmsbmibile3/naosuportato/url_launcher.dart'
    if (dart.library.io) 'package:url_launcher/url_launcher.dart';

class AdministracaoPerfilPage extends StatefulWidget {
  final AuthBloc authBloc;

  AdministracaoPerfilPage(this.authBloc);

  _AdministracaoPerfilPageState createState() =>
      _AdministracaoPerfilPageState();
}

class _AdministracaoPerfilPageState extends State<AdministracaoPerfilPage> {
  AdministracaoPerfilPageBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = AdministracaoPerfilPageBloc(
        Bootstrap.instance.firestore, widget.authBloc);
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
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
                    Divider(),
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
              AsyncSnapshot<AdministracaoPerfilPageState> snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text("Error"),
              );
            }

            return Wrap(
              alignment: WrapAlignment.start,
              children: <Widget>[
                snapshot.data?.relatorioPdfMakeModel?.pdfGerar != null &&
                        snapshot.data?.relatorioPdfMakeModel?.pdfGerar ==
                            false &&
                        snapshot.data?.relatorioPdfMakeModel?.pdfGerado ==
                            true &&
                        snapshot.data?.relatorioPdfMakeModel?.tipo ==
                            'administracao02'
                    ? IconButton(
                        tooltip: 'Ver relatório deste usuario.',
                        icon: Icon(Icons.link),
                        onPressed: () async {
                          bloc.administracaoPerfilPageEventSink(
                              GerarRelatorioPdfMakeEvent(
                                  pdfGerar: false,
                                  pdfGerado: false,
                                  tipo: 'administracao02',
                                  collection: 'Usuario',
                                  document: snapshot.data.usuarioId));
                          launch(snapshot.data?.relatorioPdfMakeModel?.url);
                        },
                      )
                    : snapshot.data?.relatorioPdfMakeModel?.pdfGerar != null &&
                            snapshot.data?.relatorioPdfMakeModel?.pdfGerar ==
                                true &&
                            snapshot.data?.relatorioPdfMakeModel?.pdfGerado ==
                                false &&
                            snapshot.data?.relatorioPdfMakeModel?.tipo ==
                                'administracao02'
                        ? CircularProgressIndicator()
                        : IconButton(
                            tooltip: 'Atualizar PDF deste usuario.',
                            icon: Icon(Icons.picture_as_pdf),
                            onPressed: () async {
                              bloc.administracaoPerfilPageEventSink(
                                  GerarRelatorioPdfMakeEvent(
                                      pdfGerar: true,
                                      pdfGerado: false,
                                      tipo: 'administracao02',
                                      collection: 'Usuario',
                                      document: snapshot.data.usuarioId));
                            },
                          ),
              ],
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
                  ...snapshot.data.map((variavel) {
                    if (variavel.perfilID.contentType == 'text') {
                      return Card(
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
                            child: ListTile(
                          title: Text(
                            "${variavel.perfilID.nome}:",
                            style: TextStyle(fontSize: 14),
                          ),
                          subtitle: Text(
                            "null",
                            style: TextStyle(fontSize: 16),
                          ),
                          selected: variavel.arquivo == null ? true : false,
                        ));
                      } else {
                        return Card(
                            child: InkWell(
                                onTap: variavel?.arquivo?.url != null
                                    ? () {
                                        launch(variavel.arquivo.url);
                                      }
                                    : null,
                                child: ListTile(
                                  title: Text(
                                    "${variavel.perfilID.nome}:",
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  subtitle: variavel?.arquivo?.url != null
                                      ? Text(
                                          "CLIQUE AQUI PARA VER O ARQUIVO",
                                          style: TextStyle(
                                              fontSize: 16, color: Colors.blue),
                                        )
                                      : Text(
                                          'Arquivo não disponivel. Usuario não fez upload.'),
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
      foto = Center(child: Text('Não enviada.'));
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
