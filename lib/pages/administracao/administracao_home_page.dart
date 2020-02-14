import 'package:flutter/material.dart';
import 'package:pmsbmibile3/components/default_scaffold.dart';
import 'package:pmsbmibile3/models/usuario_model.dart';
import 'package:pmsbmibile3/state/auth_bloc.dart';
import 'package:pmsbmibile3/naosuportato/url_launcher.dart'
    if (dart.library.io) 'package:url_launcher/url_launcher.dart';
import 'package:pmsbmibile3/style/pmsb_colors.dart';
import 'package:pmsbmibile3/style/pmsb_styles.dart';
import 'administracao_home_page_bloc.dart';
import 'package:pmsbmibile3/bootstrap.dart';

class AdministracaoHomePage extends StatefulWidget {
  final AuthBloc authBloc;

  const AdministracaoHomePage(this.authBloc);

  _AdministracaoHomePageState createState() => _AdministracaoHomePageState();
}

class _AdministracaoHomePageState extends State<AdministracaoHomePage> {
  AdministracaoHomePageBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = AdministracaoHomePageBloc(
        Bootstrap.instance.firestore, widget.authBloc);
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultScaffold(
      title: Text("Administração"),
      body: Container(
        child: StreamBuilder<AdministracaoHomePageBlocState>(
            stream: bloc.stateStream,
            builder: (BuildContext context,
                AsyncSnapshot<AdministracaoHomePageBlocState> snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Text("Erro. Na leitura de usuarios."),
                );
              }
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (snapshot.hasData) {
                if (snapshot.data.isDataValid) {
                  List<Widget> listaWdg = List<Widget>();
                  for (var usuario in snapshot.data?.usuarioList) {
                    listaWdg.add(ItemListView(usuario));
                  }
                  return Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Expanded(
                            flex: 10,
                            child: Text('Lista dos usuarios ativos'),
                          ),
                          Wrap(alignment: WrapAlignment.start, children: <
                              Widget>[
                            (snapshot.data?.relatorioPdfMakeModel?.pdfGerar !=
                                        null &&
                                    snapshot.data?.relatorioPdfMakeModel
                                            ?.pdfGerar ==
                                        false &&
                                    snapshot.data?.relatorioPdfMakeModel
                                            ?.pdfGerado ==
                                        true &&
                                    snapshot.data?.relatorioPdfMakeModel
                                            ?.tipo ==
                                        'administracao01')
                                ? IconButton(
                                    tooltip: 'Ver relatório dos usuários.',
                                    icon: Icon(Icons.link),
                                    onPressed: () async {
                                      bloc.eventSink(GerarRelatorioPdfMakeEvent(
                                        pdfGerar: false,
                                        pdfGerado: false,
                                        tipo: 'administracao01',
                                        collection: 'Usuario',
                                      ));
                                      launch(snapshot
                                          .data?.relatorioPdfMakeModel?.url);
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
                                        snapshot.data?.relatorioPdfMakeModel
                                                ?.tipo ==
                                            'administracao01'
                                    ? CircularProgressIndicator()
                                    : IconButton(
                                        tooltip: 'Atualizar PDF dos usuários.',
                                        icon: Icon(Icons.picture_as_pdf),
                                        onPressed: () async {
                                          bloc.eventSink(
                                              GerarRelatorioPdfMakeEvent(
                                            pdfGerar: true,
                                            pdfGerado: false,
                                            tipo: 'administracao01',
                                            collection: 'Usuario',
                                          ));
                                        },
                                      ),
                          ]),
                        ],
                      ),
                      Expanded(
                        flex: 10,
                        child: ListView(
                          children: listaWdg,
                        ),
                      )
                    ],
                  );
                } else {
                  return Text('Existem dados inválidos...');
                }
              }
              return Text('Dados incompletos...');
            }),
      ),
    );
  }
}

class ItemListView extends StatelessWidget {
  final UsuarioModel usuario;

  ItemListView(this.usuario);

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          Navigator.pushNamed(context, "/administracao/perfil",
              arguments: usuario.id);
        },
        child: adminCard()
        // Card(
        //   child: Container(
        //     padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        //     child: Row(
        //       crossAxisAlignment: CrossAxisAlignment.start,
        //       children: <Widget>[
        //         Expanded(
        //           flex: 2,
        //           child: _ImagemUnica(
        //             fotoLocalPath: usuario?.foto?.localPath,
        //             fotoUrl: usuario?.foto?.url,
        //           ),
        //         ),
        //         Expanded(
        //           flex: 5,
        //           child: Container(
        //             padding: EdgeInsets.only(left: 6),
        //             child: Column(
        //               crossAxisAlignment: CrossAxisAlignment.start,
        //               children: <Widget>[
        //                 Text("ID: ${usuario.id.substring(0, 5)}"),
        //                 Text("Nome: ${usuario.nome}"),
        //                 Text("Celular: ${usuario.celular}"),
        //                 Text("Email: ${usuario.email}"),
        //                 Text("Eixo: ${usuario.eixoIDAtual.nome}"),
        //               ],
        //             ),
        //           ),
        //         ),
        //       ],
        //     ),
        //   ),
        // ),
        );
  }

  adminCard() {
    return Padding(
        padding: const EdgeInsets.only(
            top: 6, bottom: 0), //distância entre os cards e o topo
        child: Container(
          height: 140.0, //distância entre os cards
          child: Stack(
            children: <Widget>[
              Positioned(
                left:
                    50.0, //distância do card por trás da imagem para a esquerda
                right: 4, //distância do card por trás da imagem para a direita
                child: Container(
                  width: 290.0,
                  height: 138.0, // espessura do card
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(17.0),
                    ),
                    color: PmsbColors.card,
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: 9.0,
                        //bottom: 20.0,
                        left: 80.0, // distância do campo de texto para o da imagem
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text("${usuario.nome}",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold)),

                          admimRowLine("Celular", usuario.celular),
                          admimRowLine("E-mail:", usuario.email),
                          admimRowLine("Eixo", usuario.eixoIDAtual.nome),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 9.0, //altura da imagem de perfil
                child: _ImagemAdminUnica(
                    fotoLocalPath: usuario?.foto?.localPath,
                    fotoUrl: usuario?.foto?.url),
              ),
            ],
          ),
        ));
  }

  admimRowLine(String intancia, String valor) {
    return Row(
        //mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start ,
        children: <Widget>[
          Text("$intancia: ",
              style: TextStyle(
                  color: PmsbColors.texto_secundario,
                  fontSize: 14,
                  fontWeight: FontWeight.bold)),
          Flexible(
              child: Text("$valor", style: PmsbStyles.textStyleListPerfil)),
        ]);
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
        width: _width * 0.30, // espessura da imagem de perfil
        height: _width * 0.30, // altura da imagem de perfil
        decoration: BoxDecoration(
          color: PmsbColors.card,
          //borda ao redor da imagem de perfil
          border: Border.all(
            width: 5.0, //espessura da borda
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
            width: _width * 0.30, // espessura da imagem de perfil
            height: _width * 0.30, // altura da imagem de perfil
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
              top: _width * 0.13, left: _width * 0.03, child: Text(mensagem)),
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
