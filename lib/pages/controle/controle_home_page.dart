import 'package:flutter/material.dart';
import 'package:pmsbmibile3/components/default_scaffold.dart';
import 'package:pmsbmibile3/models/models_controle/acao_model.dart';
import 'package:pmsbmibile3/models/models_controle/etiqueta_model.dart';
import 'package:pmsbmibile3/models/models_controle/tarefa_model.dart';
import 'package:pmsbmibile3/state/auth_bloc.dart';
import 'package:pmsbmibile3/style/pmsb_colors.dart';
import 'package:pmsbmibile3/style/pmsb_styles.dart';
import 'package:pmsbmibile3/widgets/quadro_card_widget.dart';
// import 'package:pmsbmibile3/naosuportato/url_launcher.dart'
//     if (dart.library.io) 'package:url_launcher/url_launcher.dart';

class ControleTarefaHomePage extends StatefulWidget {
  final AuthBloc authBloc;

  const ControleTarefaHomePage(this.authBloc);

  @override
  _ControleTarefaHomePageState createState() => _ControleTarefaHomePageState();
}

class _ControleTarefaHomePageState extends State<ControleTarefaHomePage> {
  static List<Acao> listaAcao = [
    Acao(titulo: "", status: true),
    Acao(titulo: "", status: false),
  ];

  static List<Etiqueta> listaEtiquetas = [
    Etiqueta(cor: 0xFF20BBE8, titulo: "Wip"),
    Etiqueta(cor: 0xFFFF5733, titulo: "Help"),
    Etiqueta(cor: 0xFF8FD619 , titulo: "Working"),
  ];

  TarefaModel cardModel01 = new TarefaModel(
    descricaoAtividade: "Descrição teste",
    tituloAtividade: "Título do Card 01",
    acoes: listaAcao,
    etiquetas: listaEtiquetas,
   // publico: true,
  );

  //QuadroModel cardModel02 = new QuadroModel(
   // descricao: "Descrição teste",
   // titulo: "Titulo do Card 02",
   // publico: false,
 // );

  @override
  Widget build(BuildContext context) {
    return DefaultScaffold(
      backgroundColor: PmsbColors.navbar,
      backToRootPage: true,
      title: Text("Quadros de Equipe"),
      body: body(),
    );
  }

  Widget body() {
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 10.0),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Container(),
                Container(),
                // Text(
                //   "QUADROS DE EQUIPE",
                //   style: TextStyle(
                //     color: PmsbColors.texto_secundario,
                //     fontSize: 18,
                //   ),
                // ),
                RaisedButton(
                  child: Text("Adicionar"),
                  color: PmsbColors.cor_destaque,
                  onPressed: () {},
                )
              ],
            ),
          ),
        ),
        Expanded(
          child: mainQuadro(),
        )
      ],
    );
  }

  Widget mainQuadro() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: width * 0.10,
        vertical: height * 0.02,
      ),
      child: Container(
        // color: Colors.black12,
        child: ListView(
          children: <Widget>[
            textoQuadro("Meus quadros"),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: width * 0.05),
              child: Column(children: _listaMeusQuadros()),
            ),
            textoQuadro("Meus gerais"),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: width * 0.05),
              child: Column(children: _listasQuadrosGerais()),
            ),
          ],
        ),
      ),
    );
  }

  Widget textoQuadro(String texto) {
    return Padding(
      padding: EdgeInsets.only(top: 15.0, bottom: 15.0, left: 30),
      child: Text(
        texto,
        style: TextStyle(
          color: PmsbColors.texto_secundario,
          fontSize: 18,
        ),
      ),
    );
  }

  _listaMeusQuadros() {
    return <Widget>[
      Padding(
        padding: EdgeInsets.all(4.0),
        child: QuadroCardWidget(
          cor: PmsbColors.card,
          quadro: cardModel02,
        ),
      ),
      Padding(
        padding: EdgeInsets.all(4.0),
        child: QuadroCardWidget(
          cor: PmsbColors.card,
          quadro: cardModel01,
        ),
      )
    ];
  }

  _listasQuadrosGerais() {
    return <Widget>[
      Padding(
        padding: EdgeInsets.all(4.0),
        child: QuadroCardWidget(
          cor: Colors.black12,
          quadro: cardModel01,
        ),
      )
    ];
  }
}
