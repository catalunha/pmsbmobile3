import 'package:flutter/material.dart';
import 'package:pmsbmibile3/bootstrap.dart';
import 'package:pmsbmibile3/components/default_scaffold.dart';
import 'package:pmsbmibile3/components/preambulo.dart';
import 'package:pmsbmibile3/models/pergunta_model.dart';
import 'package:pmsbmibile3/pages/aplicacao/pendencias_page_bloc.dart';
import 'package:pmsbmibile3/pages/page_arguments.dart';
import 'package:pmsbmibile3/pages/aplicacao/requisito_list_item_bloc.dart';
import 'package:pmsbmibile3/style/pmsb_colors.dart';
import 'package:pmsbmibile3/style/pmsb_styles.dart';

//Aplicação 03

class PendenciasPage extends StatefulWidget {
  const PendenciasPage(this.questionarioAplicadoID, {Key key})
      : super(key: key);

  final String questionarioAplicadoID;

  @override
  _PendenciasPageState createState() => _PendenciasPageState();
}

class _PendenciasPageState extends State<PendenciasPage> {
  final bloc = PendenciasPageBloc(Bootstrap.instance.firestore);

  @override
  void initState() {
    super.initState();
    bloc.dispatch(UpdateQuestionarioIDPendenciasPageBlocEvent(
        widget.questionarioAplicadoID));
  }

  _listaPerguntas() {
    return StreamBuilder<PendenciasPageBlocState>(
      stream: bloc.state,
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return Padding(
            padding: EdgeInsets.all(8),
            child: Text("SEM DADOS"),
          );
        return ListView(
          children: snapshot.data.perguntas
              .map(
                (pergunta) => PerguntaAplicadaListItem(
                  pergunta,
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      "/aplicacao/aplicando_pergunta",
                      arguments: AplicandoPerguntaPageArguments(
                          widget.questionarioAplicadoID,
                          perguntaID: pergunta.id),
                    );
                  },
                ),
              )
              .toList(),
        );
      },
    );
  }

  _bodyTodos(context) {
    return Column(
      children: <Widget>[
        Preambulo(
          eixo: true,
          setor: true,
          questionarioID: widget.questionarioAplicadoID,
          questionarioAplicado: true,
          referencia: true,
        ),
        Expanded(
          child: _listaPerguntas(),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultScaffold(
      backToRootPage: false,
      // actionsMore: <Widget>[],
      title: Text("Resumo"),
      body: _bodyTodos(context),
    );
  }
}

class PerguntaAplicadaListItem extends StatelessWidget {
  const PerguntaAplicadaListItem(this._perguntaAplicada,
      {Key key, this.onPressed})
      : super(key: key);

  final void Function() onPressed;

  final PerguntaAplicadaModel _perguntaAplicada;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 5),
      child: Container(
        color: PmsbColors.card,
        // width: MediaQuery.of(context).size.width * 0.95, //distância entre os cards
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              //Primeira linha
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  _perguntaAplicada.titulo,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 8),

              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Flexible(
                    flex: 8,
                    child: Text(
                      "Tem informação: ",
                      style: PmsbStyles.textoSecundario,
                    ),
                  ),
                  Flexible(
                      flex: 8,
                      child: _iconResposta(_perguntaAplicada.temRespostaValida))
                ],
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Flexible(
                    flex: 8,
                    child: Text(
                      "Pode ser respondida: ",
                      style: PmsbStyles.textoSecundario,
                    ),
                  ),
                  Flexible(
                      flex: 8,
                      child: _iconResposta(!_perguntaAplicada.temPendencias)

                      // Icon(
                      //   Icons.check,
                      //   size: 25,
                      //   color: Colors.green,
                      // ),
                      )
                ],
              ),
              SizedBox(height: 5),
              Align(
                alignment: Alignment.centerRight,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    GestureDetector(
                      onTap: _perguntaAplicada.temPendencias ? null : onPressed,
                      child: Container(
                        // width: 65,
                        height: 30,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.topRight,
                              end: Alignment.bottomLeft,
                              colors: _perguntaAplicada.foiRespondida
                                  ? [
                                      Colors.green[300],
                                      PmsbColors.cor_destaque,
                                    ]
                                  : [
                                      Colors.red[300],
                                      Colors.redAccent,
                                    ]),
                          //vermelho: red[300] e achar outro tom
                          //verde: green[300] e cor_destaque
                          //laranja: orange[300] e deppOrange
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        ),
                        child: Text(
                          _perguntaAplicada.foiRespondida
                              ? '  Respodida  '
                              : '  Não Respondida  ',
                          style: TextStyle(
                            color: PmsbColors.texto_secundario,
                            fontSize: 20,
                            //fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      tooltip: 'Listar requisitos',
                      icon: Icon(
                        Icons.rotate_90_degrees_ccw,
                        color: _perguntaAplicada.referenciasRequitosDefinidas
                            ? Colors.green
                            : Colors.red,
                      ),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => Dialog(
                            elevation: 5,
                            child: ListView(
                              children: <Widget>[
                                ListTile(
                                  title: Text("Requisitos"),
                                ),
                                for (var item in _perguntaAplicada.requisitos.entries)
                                  RequisitoListItem(item.value),
                                FlatButton(
                                  child: Text("OK"),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );

    // Column(
    //   children: <Widget>[
    //     ListTile(
    //       title: Text(_perguntaAplicada.titulo),
    //       // trailing: IconButton(
    //       //   tooltip: 'Pergunta pode ser respondida ?',
    //       //   //Sim.
    //       //   //Nao. Pois tem pendencia e podem ser:
    //       //   //- tem req e nao foi especificada a pergunta req
    //       //   //- se tem o req ele pode nao ter sido atendido.
    //       //   icon: _perguntaAplicada.temPendencias
    //       //       ? Icon(Icons.clear, color: Colors.red)
    //       //       : Icon(Icons.check, color: Colors.green),
    //       //   onPressed: _perguntaAplicada.temPendencias ? null : onPressed,
    //       // ),
    //     ),
    //     Container(
    //       padding: EdgeInsets.symmetric(horizontal: 8),
    //       child: Row(
    //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //         children: <Widget>[
    //           // Pode ser respondida
    //           IconButton(
    //             tooltip: 'Pergunta pode ser respondida ?',
    //             icon: _perguntaAplicada.temPendencias
    //                 ? Icon(Icons.clear, color: Colors.red)
    //                 : Icon(Icons.check, color: Colors.green),
    //             onPressed: _perguntaAplicada.temPendencias ? null : onPressed,
    //           ),

    //           // Foi respondida
    //           if (_perguntaAplicada.foiRespondida)
    //             IconButton(
    //               tooltip: 'Pergunta foi respondida ?',
    //               icon: Icon(Icons.thumb_up, color: Colors.green),
    //               onPressed: () {},
    //             )
    //           else
    //             IconButton(
    //               tooltip: 'Pergunta foi respondida ?',
    //               icon: Icon(Icons.thumb_down),
    //               onPressed: () {},
    //             ),

    //           // Tem informacao valida

    //           if (!_perguntaAplicada.foiRespondida &&
    //               _perguntaAplicada.temRespostaValida)
    //             IconButton(
    //               tooltip:
    //                   'Pergunta não foi respondida e tem informação válida ?',
    //               icon: Icon(Icons.thumbs_up_down),
    //               onPressed: () {},
    //             )
    //           else
    //             IconButton(
    //                 tooltip:
    //                     'Pergunta não foi respondida e tem informação válida ?',
    //                 icon: Icon(Icons.thumb_down),
    //                 onPressed: () {}),

    //           // Requisitos
    //           IconButton(
    //             tooltip: 'Requisitos definidos ?',
    //             icon: Icon(
    //               Icons.rotate_90_degrees_ccw,
    //               color: _perguntaAplicada.referenciasRequitosDefinidas
    //                   ? Colors.green
    //                   : Colors.red,
    //             ),
    //             onPressed: () {
    //               showDialog(
    //                 context: context,
    //                 builder: (context) => Dialog(
    //                   elevation: 5,
    //                   child: ListView(
    //                     children: <Widget>[
    //                       ListTile(
    //                         title: Text("Requisitos"),
    //                       ),
    //                       for (var item in _perguntaAplicada.requisitos.entries)
    //                         RequisitoListItem(item.value),
    //                       FlatButton(
    //                         child: Text("OK"),
    //                         onPressed: () {
    //                           Navigator.pop(context);
    //                         },
    //                       ),
    //                     ],
    //                   ),
    //                 ),
    //               );
    //             },
    //           ),
    //         ],
    //       ),
    //     ),
    //   ],
    // );
  }

  _iconResposta(bool item) {
    return item
        ? Icon(Icons.check, color: Colors.green)
        : Icon(Icons.clear, color: Colors.red);
  }
}

class RequisitoListItem extends StatefulWidget {
  final Requisito requisito;

  const RequisitoListItem(this.requisito, {Key key}) : super(key: key);

  @override
  _RequisitoListItemState createState() {
    return _RequisitoListItemState();
  }
}

class _RequisitoListItemState extends State<RequisitoListItem> {
  RequisitoListItemBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc =
        RequisitoListItemBloc(Bootstrap.instance.firestore, widget.requisito);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<PerguntaAplicadaModel>(
      stream: bloc.state,
      builder: (context, snap) {
        if (snap.hasError) {
          return Padding(
            padding: EdgeInsets.all(8),
            child: Text("ERROR"),
          );
        }
        if (!snap.hasData) {
          return Padding(
            padding: EdgeInsets.all(8),
            child: CircularProgressIndicator(),
          );
        }
        bool vencido = false;
        if (widget.requisito.escolha == null) {
          vencido = snap.data.foiRespondida;
        } else {
          vencido = snap.data.escolhas[widget.requisito.escolha.id].marcada ==
              widget.requisito.escolha.marcada;
        }
        return Container(
          padding: EdgeInsets.all(4),
          child: Column(
            children: <Widget>[
              ListTile(
                title: Text("${snap.data.questionario.nome}"),
                subtitle: Text("QuestID: ${snap.data.questionario.id}"),
              ),
              ListTile(
                title: Text("${snap.data.questionario.referencia}"),
                subtitle: Text("Referencia"),
              ),
              ListTile(
                title: Text("${snap.data.titulo}"),
                subtitle: Text("PergID: ${widget.requisito.perguntaID}"),
              ),
              ListTile(
                title: Text(widget.requisito.perguntaTipo),
                subtitle: Text("Tipo de pergunta"),
              ),
              if (widget.requisito.escolha != null)
                ListTile(
                  subtitle: Text(
                      "Esta escolha marcada como: ${widget.requisito.escolha.marcada}"),
                  title: Text(
                      "${snap.data.escolhas[widget.requisito.escolha.id].texto}"),
                ),
              ListTile(
                title: Text(widget.requisito.referencia),
                subtitle: Text("Referencia id"),
              ),
              Icon(
                vencido ? Icons.check : Icons.close,
                color: vencido ? Colors.green : Colors.red,
              ),
              Divider(),
            ],
          ),
        );
      },
    );
  }
}
