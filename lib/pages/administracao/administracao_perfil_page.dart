import 'package:flutter/material.dart';
import 'package:pmsbmibile3/models/usuario_model.dart';
import 'package:pmsbmibile3/models/usuario_perfil_model.dart';
import 'package:pmsbmibile3/state/auth_bloc.dart';
import 'package:pmsbmibile3/style/pmsb_colors.dart';
import 'package:pmsbmibile3/style/pmsb_styles.dart';
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
        bottomOpacity: 0.0,
        backgroundColor: PmsbColors.fundo,
        centerTitle: true,
        title: Text("Visualizar dados e perfil"),
      ),
      body: Container(
        color: PmsbColors.fundo,
        padding: EdgeInsets.symmetric(horizontal: 12),
        child: _body(),
      ),
    );
  }

  Widget _body() {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;

    return ListView(children: <Widget>[
      //Metade superior ( Imagem Usuario )
      StreamBuilder<UsuarioModel>(
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
            return Column(
              children: <Widget>[
                Container(
                  width: _width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      new SizedBox(
                        height: _height / 20,
                      ),
                      _ImagemAdminUnica(
                        fotoLocalPath: usuarioModelData?.foto?.localPath,
                        fotoUrl: usuarioModelData?.foto?.url,
                      ),
                      new SizedBox(
                        height: _height / 15,
                      ),
                      new Text(
                        '${snapshot.data.nome}',
                        style: new TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: _width / 15,
                            color: Colors.white),
                      ),
                      new SizedBox(
                        height: _height / 25,
                      )
                    ],
                  ),
                ),
                // Informacoes usuario ( celular, email e etc)
                new Center(
                    child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    new Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text("Celular: ",
                              style: PmsbStyles.textStyleListBold),
                          Text("${snapshot.data.celular}",
                              style: PmsbStyles.textStyleListPerfil01),
                        ]),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text("E-mail: ", style: PmsbStyles.textStyleListBold),
                          Text("${snapshot.data.email}",
                              style: PmsbStyles.textStyleListPerfil01),
                        ]),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text("Eixo: ", style: PmsbStyles.textStyleListBold),
                          Text("${snapshot.data.eixoIDAtual.nome}",
                              style: PmsbStyles.textStyleListPerfil01),
                        ]),
                  ],
                )),
              ],
            );
          }),

      //Icone de download Pdf
      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
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
                        : snapshot.data?.relatorioPdfMakeModel?.pdfGerar !=
                                    null &&
                                snapshot.data?.relatorioPdfMakeModel
                                        ?.pdfGerar ==
                                    true &&
                                snapshot.data?.relatorioPdfMakeModel
                                        ?.pdfGerado ==
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
        ],
      ),

      Divider(color: PmsbColors.texto_secundario),

      // Cards de documento
      StreamBuilder<List<UsuarioPerfilModel>>(
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
            return Column(
              children: <Widget>[
                ...snapshot.data.map((variavel) {
                  return Padding(
                      padding: const EdgeInsets.only(top: 5, bottom: 5),
                      // Card de variavel do perfil
                      child: VariavelPerfilCard(
                        usuarioPerfilModel: variavel,
                      ));
                }).toList()
              ],
            );
          }),

      SizedBox(height: 10)
    ]);
  }
}

class VariavelPerfilCard extends StatelessWidget {
  VariavelPerfilCard({@required this.usuarioPerfilModel});

  final UsuarioPerfilModel usuarioPerfilModel;

  @override
  Widget build(BuildContext context) {
    Widget widgetPerfil;

    if (this.usuarioPerfilModel.perfilID.contentType == 'text') {
      widgetPerfil = Text(
        "${this.usuarioPerfilModel.textPlain}",
        style: TextStyle(
          color: PmsbColors.texto_secundario,
          fontSize: 16,
        ),
      );
    } else {
      widgetPerfil = InkWell(
          onTap: this.usuarioPerfilModel?.arquivo?.url != null
              ? () {
                  launch(this.usuarioPerfilModel.arquivo.url);
                }
              : null,
          child: this.usuarioPerfilModel?.arquivo?.url != null
              ? Text(
                  "CLIQUE AQUI PARA VER O ARQUIVO",
                  style: TextStyle(fontSize: 16, color: Colors.blue),
                )
              : Text('Arquivo não disponivel. Usuario não fez upload.'));
    }

    return Container(
      width: MediaQuery.of(context).size.width * 0.95,
      height: MediaQuery.of(context).size.height * 0.10,
      decoration: BoxDecoration(
        color: PmsbColors.card,
        borderRadius: BorderRadius.all(
            Radius.circular(5.0) //                 <--- border radius here
            ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 10, left: 10),
            child: Text("${this.usuarioPerfilModel.perfilID.nome}:",
                style: TextStyle(
                  color: PmsbColors.texto_primario,
                  fontWeight: FontWeight.bold,
                )),
          ),
          Padding(
              padding: const EdgeInsets.only(top: 10, left: 10),
              child: widgetPerfil)
        ],
      ),
    );
  }
}

class _ImagemAdminUnica extends StatelessWidget {
  final String fotoUrl;
  final String fotoLocalPath;

  const _ImagemAdminUnica({this.fotoUrl, this.fotoLocalPath});

  @override
  Widget build(BuildContext context) {
    Widget foto;
    final _width = MediaQuery.of(context).size.width;

    if (fotoUrl != null) {
      foto = Container(
        width: _width * 0.50, // espessura da imagem de perfil
        height: _width * 0.50, // altura da imagem de perfil
        decoration: BoxDecoration(
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: PmsbColors.texto_terciario,
                blurRadius: 12.0,
                offset: Offset(0.57, 0.57))
          ],
          border: Border.all(
            width: 8.0,
            color: PmsbColors.cor_destaque, // cor da borda
          ),
          shape: BoxShape.circle, //formato imagem
          image: DecorationImage(
            fit: BoxFit.cover,
            image: NetworkImage(fotoUrl), //chama url
          ),
        ),
      );
    } else {
      String mensagem = (fotoUrl == null && fotoLocalPath == null)
          ? "Sem imagem."
          : "Não enviada.";

      foto = Stack(
        children: <Widget>[
          Container(
            width: _width * 0.50, // espessura da imagem de perfil
            height: _width * 0.50, // altura da imagem de perfil
            decoration: BoxDecoration(
              color: PmsbColors.card,
              //borda ao redor da imagem de perfil
              border: Border.all(
                width: 5.0, //espessura da borda
                color: PmsbColors.cor_destaque, // cor da borda
              ),
              shape: BoxShape.circle, //formato imagem
            ),
          ),
          Positioned(
              top: _width * 0.25, left: _width * 0.125, child: Text(mensagem)),
        ],
      );
    }
    return foto;
  }
}

// class _ImagemUnica extends StatelessWidget {
//   final String fotoUrl;
//   final String fotoLocalPath;

//   const _ImagemUnica({this.fotoUrl, this.fotoLocalPath});

//   @override
//   Widget build(BuildContext context) {
//     Widget foto;
//     if (fotoUrl == null && fotoLocalPath == null) {
//       foto = Center(child: Text('Sem imagem.'));
//     } else if (fotoUrl != null) {
//       foto = Container(
//           child: Padding(
//         padding: const EdgeInsets.all(2.0),
//         child: Image.network(fotoUrl),
//       ));
//     } else {
//       foto = Center(child: Text('Não enviada.'));
//     }

//     return Row(
//       children: <Widget>[
//         Spacer(
//           flex: 1,
//         ),
//         Expanded(
//           flex: 8,
//           child: foto,
//         ),
//         Spacer(
//           flex: 1,
//         ),
//       ],
//     );
//   }
// }

// -------------------------------------------

// SingleChildScrollView(
//   padding: const EdgeInsets.all(16.0),
//   child: Column(
//     children: <Widget>[
//       Container(
//         width: _width * 0.90,
//         height: _height * 0.10,
//         color: PmsbColors.card,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: <Widget>[
//             Padding(
//               padding: const EdgeInsets.only(top: 10, left: 10),
//               child: Text("Número do CPF:",
//                   style: TextStyle(
//                     color: PmsbColors.texto_primario,
//                     fontWeight: FontWeight.bold,
//                   )),
//             ),
//             Padding(
//               padding: const EdgeInsets.only(top: 10, left: 10),
//               child: Text(
//                 "12",
//                 style: TextStyle(
//                   color: PmsbColors.texto_secundario,
//                   fontSize: 16,
//                 ),
//               ),
//             ),
//           ],

//           //trailing: Text("${questions.length}", style: trailingStyle),
//         ),
//       ),
//       SizedBox(height: 10.0),
//       Card(
//         color: PmsbColors.card,
//         shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(10.0)),
//         child: ListTile(
//           contentPadding: const EdgeInsets.all(10.0),
//           title: Text("Imagem do CPF:",
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 color: PmsbColors.texto_primario,
//                 fontWeight: FontWeight.bold,
//               )),
//           trailing: Text("CLIQUE AQUI PARA VER O ARQUIVO",
//               style: TextStyle(
//                 color: Colors.blue,
//                 fontSize: 16,
//               )),
//         ),
//       ),
//       SizedBox(height: 10.0),
//       Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: <Widget>[],
//       )
//     ],
//   ),
// ),

// // -----------------------------
// Column(children: <Widget>[
//   Expanded(
//       flex: 1,
//       child: StreamBuilder<UsuarioModel>(
//           stream: bloc.usuarioModelStream,
//           builder: (context, snapshot) {
//             if (snapshot.hasError) {
//               return Center(
//                 child: Text("Error"),
//               );
//             }
//             if (!snapshot.hasData) {
//               return Center(
//                 child: Text("Sem perfil em pdf/csv/web"),
//               );
//             }
//             usuarioModelData = snapshot.data;
//             return Container(
//               child: Column(children: <Widget>[
//                 Divider(),
//                 Padding(padding: EdgeInsets.all(3)),
//                 Expanded(
//                   flex: 2,
//                   child: Row(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: <Widget>[
//                       Expanded(
//                           flex: 5,
//                           child: Container(
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: <Widget>[
//                                 Text(
//                                     "ID: ${snapshot.data.id.substring(0, 10)}"),
//                                 Text("Nome: ${snapshot.data.nome}"),
//                                 Text("Celular: ${snapshot.data.celular}"),
//                                 Text("Email: ${snapshot.data.email}"),
//                                 Text(
//                                     "Eixo: ${snapshot.data.eixoIDAtual.nome}"),
//                               ],
//                             ),
//                           ))
//                     ],
//                   ),
//                 ),
//               ]),
//             );
//           })),

//   //
//   Expanded(
//     flex: 0,
//     child: StreamBuilder<AdministracaoPerfilPageState>(
//       stream: bloc.administracaoPerfilPageStateStream,
//       builder: (BuildContext context,
//           AsyncSnapshot<AdministracaoPerfilPageState> snapshot) {
//         if (snapshot.hasError) {
//           return Center(
//             child: Text("Error"),
//           );
//         }

//         return Wrap(
//           alignment: WrapAlignment.start,
//           children: <Widget>[
//             snapshot.data?.relatorioPdfMakeModel?.pdfGerar != null &&
//                     snapshot.data?.relatorioPdfMakeModel?.pdfGerar ==
//                         false &&
//                     snapshot.data?.relatorioPdfMakeModel?.pdfGerado ==
//                         true &&
//                     snapshot.data?.relatorioPdfMakeModel?.tipo ==
//                         'administracao02'
//                 ? IconButton(
//                     tooltip: 'Ver relatório deste usuario.',
//                     icon: Icon(Icons.link),
//                     onPressed: () async {
//                       bloc.administracaoPerfilPageEventSink(
//                           GerarRelatorioPdfMakeEvent(
//                               pdfGerar: false,
//                               pdfGerado: false,
//                               tipo: 'administracao02',
//                               collection: 'Usuario',
//                               document: snapshot.data.usuarioId));
//                       launch(snapshot.data?.relatorioPdfMakeModel?.url);
//                     },
//                   )
//                 : snapshot.data?.relatorioPdfMakeModel?.pdfGerar != null &&
//                         snapshot.data?.relatorioPdfMakeModel?.pdfGerar ==
//                             true &&
//                         snapshot.data?.relatorioPdfMakeModel?.pdfGerado ==
//                             false &&
//                         snapshot.data?.relatorioPdfMakeModel?.tipo ==
//                             'administracao02'
//                     ? CircularProgressIndicator()
//                     : IconButton(
//                         tooltip: 'Atualizar PDF deste usuario.',
//                         icon: Icon(Icons.picture_as_pdf),
//                         onPressed: () async {
//                           bloc.administracaoPerfilPageEventSink(
//                               GerarRelatorioPdfMakeEvent(
//                                   pdfGerar: true,
//                                   pdfGerado: false,
//                                   tipo: 'administracao02',
//                                   collection: 'Usuario',
//                                   document: snapshot.data.usuarioId));
//                         },
//                       ),
//           ],
//         );
//       },
//     ),
//   ),
//   Expanded(
//     flex: 4,
//     child: StreamBuilder<List<UsuarioPerfilModel>>(
//         stream: bloc.usuarioPerfilModelStream,
//         builder: (context, snapshot) {
//           if (snapshot.hasError) {
//             return Center(
//               child: Text("Erro"),
//             );
//           }
//           if (!snapshot.hasData) {
//             return Center(
//               child: CircularProgressIndicator(),
//             );
//           }
//           return ListView(
//             children: <Widget>[
//               ...snapshot.data.map((variavel) {
//                 if (variavel.perfilID.contentType == 'text') {
//                   return Card(
//                       child: ListTile(
//                     title: Text(
//                       "${variavel.perfilID.nome}:",
//                       style: TextStyle(fontSize: 14),
//                     ),
//                     subtitle: Text(
//                       "${variavel.textPlain}",
//                       style: TextStyle(fontSize: 16),
//                     ),
//                   ));
//                 } else {
//                   if (variavel.arquivo == null) {
//                     return Card(
//                         child: ListTile(
//                       title: Text(
//                         "${variavel.perfilID.nome}:",
//                         style: TextStyle(fontSize: 14),
//                       ),
//                       subtitle: Text(
//                         "null",
//                         style: TextStyle(fontSize: 16),
//                       ),
//                       selected: variavel.arquivo == null ? true : false,
//                     ));
//                   } else {
//                     return Card(
//                         child: InkWell(
//                             onTap: variavel?.arquivo?.url != null
//                                 ? () {
//                                     launch(variavel.arquivo.url);
//                                   }
//                                 : null,
//                             child: ListTile(
//                               title: Text(
//                                 "${variavel.perfilID.nome}:",
//                                 style: TextStyle(fontSize: 14),
//                               ),
//                               subtitle: variavel?.arquivo?.url != null
//                                   ? Text(
//                                       "CLIQUE AQUI PARA VER O ARQUIVO",
//                                       style: TextStyle(
//                                           fontSize: 16, color: Colors.blue),
//                                     )
//                                   : Text(
//                                       'Arquivo não disponivel. Usuario não fez upload.'),
//                             )));
//                   }
//                 }
//               }).toList()
//             ],
//           );
//         }),
//   ),
// ]);

// Documento tipo texto
// if (variavel.perfilID.contentType == 'text') {
//   return Padding(
//       padding: const EdgeInsets.only(top: 5, bottom: 5),
//       // Card de variavel do perfil
//       child: VariavelPerfilCard(
//         nome: variavel.perfilID.nome,
//         valor: variavel.textPlain,
//         url: variavel.arquivo.url,
//         height: _height * 0.2,
//         width: _width * 0.90,
//       ));
// } else {
//   VariavelPerfilCard(

//     nome: variavel.perfilID.nome,
//     valor: variavel.textPlain,
//     url: variavel.arquivo.url,
//     height: _height * 0.2,
//     width: _width * 0.90,
//   );
// Documento não disponivel
// if (variavel.arquivo == null) {
//   return  Card(
//       child: ListTile(
//     title: Text(
//       "${variavel.perfilID.nome}:",
//       style: TextStyle(fontSize: 14),
//     ),
//     subtitle: Text(
//       "null",
//       style: TextStyle(fontSize: 16),
//     ),
//     selected: variavel.arquivo == null ? true : false,
//   ));
// } else {
//   // Documento Disponivel
//   return Card(
//       child: InkWell(
//           onTap: variavel?.arquivo?.url != null
//               ? () {
//                   launch(variavel.arquivo.url);
//                 }
//               : null,
//           child: ListTile(
//             title: Text(
//               "${variavel.perfilID.nome}:",
//               style: TextStyle(fontSize: 14),
//             ),
//             subtitle: variavel?.arquivo?.url != null
//                 ? Text(
//                     "CLIQUE AQUI PARA VER O ARQUIVO",
//                     style: TextStyle(
//                         fontSize: 16, color: Colors.blue),
//                   )
//                 : Text(
//                     'Arquivo não disponivel. Usuario não fez upload.'),
//           )));
// }
//}
