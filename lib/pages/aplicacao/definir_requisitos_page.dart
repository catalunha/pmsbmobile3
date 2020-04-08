import 'package:flutter/material.dart';
import 'package:pmsbmibile3/bootstrap.dart';
import 'package:pmsbmibile3/components/default_scaffold.dart';
import 'package:pmsbmibile3/models/pergunta_model.dart';
import 'package:pmsbmibile3/pages/aplicacao/definir_requisitos_page_bloc.dart';
import 'package:pmsbmibile3/pages/aplicacao/momento_aplicacao_page_bloc.dart';
import 'package:pmsbmibile3/style/pmsb_styles.dart';

// Aplicação 05

class DefinirRequisistosPage extends StatefulWidget {
  const DefinirRequisistosPage(this.momentoBloc, this.referencia,
      this.requisitoId, this.perguntaSelecionadaId,
      {Key key})
      : super(key: key);
  final String referencia;
  final String requisitoId;
  final String perguntaSelecionadaId;
  final MomentoAplicacaoPageBloc momentoBloc;

  @override
  _DefinirRequisistosPageState createState() => _DefinirRequisistosPageState();
}

class _DefinirRequisistosPageState extends State<DefinirRequisistosPage> {
  final bloc = DefinirRequisitosPageBloc(Bootstrap.instance.firestore);

  @override
  void initState() {
    super.initState();
    Bootstrap.instance.authBloc.perfil.listen(
      (usuario) {
        bloc.dispatch(UpdateUsuarioDefinirRequisitosPageBlocEvent(usuario));
      },
    );
    bloc.dispatch(
      UpdateReferenciaDefinirRequisitosPageBlocEvent(widget.referencia),
    );
  }

  Map<String, bool> values = {};

  Widget _radioTules(context) {
    return StreamBuilder<DefinirRequisitosPageBlocState>(
      stream: bloc.state,
      builder: (context, snapshot) {
        // Indicador que nao ha dados
        if (!snapshot.hasData)
          return Center(
            child: Text("SEM DADOS"),
          );
        // Indicador de carregando
        if (snapshot.data.isFetching) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        final perguntas =
            snapshot.data.perguntas != null ? snapshot.data.perguntas : [];
        PerguntaAplicadaModel pergunta;
        // List<Widget> list = List<Widget>();

        // perguntas.forEach(
        //   (pergunta) => {
        //     list.add(
        //       _requisitoRadioTile(widget.momentoBloc, bloc, pergunta,
        //           widget.requisitoId, widget.perguntaSelecionadaId, context),
        //     )
        //   },
        // );

        return perguntas.length <= 0
            ? Center(
                child: Text("Nenhuma pergunta elegivel"),
              )
            : Column(
                children: perguntas.map(
                  (per) {
                    pergunta = per;
                    values[pergunta.id] =
                        widget.perguntaSelecionadaId == pergunta.id
                            ? true
                            : false;

                    return new CheckboxListTile(
                      title: new Text(
                        "Questionario: ${pergunta.questionario.nome}\nReferencia: ${pergunta.questionario.referencia}",
                        style: TextStyle(
                            color: widget.perguntaSelecionadaId == pergunta.id
                                ? Colors.green
                                : null),
                      ),
                      value: values[pergunta.id],
                      onChanged: (bool value) {
                        setState(
                          () {
                            values[pergunta.id] =
                                widget.perguntaSelecionadaId == pergunta.id
                                    ? true
                                    : false;
                          },
                        );
                      },
                    );
                  },
                ).toList(),

                //list

                // perguntas
                //     .map(
                //       (pergunta) => _requisitoRadioTile(
                //         widget.momentoBloc,
                //         bloc,
                //         pergunta,
                //         widget.requisitoId,
                //         widget.perguntaSelecionadaId,
                //       ),
                //     )
                //     .toList(),
              );
      },
    );
  }

  _requisitoRadioTile(bloc, momentoBloc, PerguntaAplicadaModel perguntaAplicada,
      final String requisitoId, final String perguntaSelecionadaId, context) {
    return

        // GestureDetector(
        //   onTap: () {
        //     // momentoBloc.dispatch(SelecionarRequisitoMomentoAplicacaoPageBlocEvent(
        //     //     requisitoId, perguntaAplicada.id));
        //     Scaffold.of(context).showSnackBar(
        //       SnackBar(
        //         content: Text('Tap'),
        //       ),
        //     );
        //     //Navigator.of(context).pop();
        //   },
        //   child:

        Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Divider(),
          ListTile(
            onTap: () {
              // _handleTapboxChanged();
              momentoBloc.dispatch(
                  SelecionarRequisitoMomentoAplicacaoPageBlocEvent(
                      requisitoId, perguntaAplicada.id));

              Scaffold.of(context).showSnackBar(
                SnackBar(
                  content: Text('Tap'),
                ),
              );
              print("FOIFOIFIOJU OIJHF OIhoih");
            },
            title: Text(
              "Questionario: ${perguntaAplicada.questionario.nome}\nReferencia: ${perguntaAplicada.questionario.referencia}",
              style: TextStyle(
                  color: perguntaSelecionadaId == perguntaAplicada.id
                      ? Colors.green
                      : null),
            ),
            subtitle: Text("Pergunta: ${perguntaAplicada.titulo}"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultScaffold(
      backToRootPage: false,
      title: Text("Definindo referencias"),
      body: ListView(children: <Widget>[
        _radioTules(context),
      ]),
    );
  }
}

// class RequisitoRadioTile extends StatefulWidget {
//   final bloc;
//   final momentoBloc;
//   final perguntaAplicada;
//   final perguntaSelecionadaId;
//   final requisitoId;

//   RequisitoRadioTile(this.momentoBloc, this.bloc, this.perguntaAplicada,
//       this.requisitoId, this.perguntaSelecionadaId,
//       {Key key})
//       : super(key: key);

//   @override
//   _RequisitoRadioTileState createState() => _RequisitoRadioTileState(
//       this.momentoBloc,
//       this.bloc,
//       this.perguntaAplicada,
//       this.requisitoId,
//       this.perguntaSelecionadaId);
// }

// class RequisitoRadioTile extends StatelessWidget {
//   final Color color;
//   final Function onChanged;

//   RequisitoRadioTile(this.momentoBloc, this.bloc, this.perguntaAplicada,
//       this.requisitoId, this.perguntaSelecionadaId, this.color, this.onChanged);

//   final DefinirRequisitosPageBloc bloc;
//   final MomentoAplicacaoPageBloc momentoBloc;
//   final PerguntaAplicadaModel perguntaAplicada;
//   final String requisitoId;
//   final String perguntaSelecionadaId;

//   @override
//   Widget build(BuildContext context) {
//     //TODO: mudar para radio ou seleção por toque, porque é pra escolher somente um das opções disponiveis

//     return Column(
//       mainAxisAlignment: MainAxisAlignment.start,
//       children: <Widget>[
//         Divider(),
//         ListTile(
//           onTap: () {
//             this.onChanged();
//             momentoBloc.dispatch(
//                 SelecionarRequisitoMomentoAplicacaoPageBlocEvent(
//                     requisitoId, perguntaAplicada.id));
//             Scaffold.of(context).showSnackBar(
//               SnackBar(
//                 content: Text('Tap'),
//               ),
//             );
//           },
//           title: Text(
//             "Questionario: ${perguntaAplicada.questionario.nome}\nReferencia: ${perguntaAplicada.questionario.referencia}",
//             style: TextStyle(color: this.color),
//           ),
//           subtitle: Text("Pergunta: ${perguntaAplicada.titulo}"),
//         ),
//       ],
//     );

//     // child: ListTile(
//     //   title: Text(
//     //     "${perguntaSelecionadaId == perguntaAplicada.id ? "(selecionado)" : ""} \n Questionario: ${perguntaAplicada.questionario.nome} \nReferencia: ${perguntaAplicada.questionario.referencia}",
//     //     style: TextStyle(
//     //         color: perguntaSelecionadaId == perguntaAplicada.id
//     //             ? Colors.green
//     //             : null),
//     //   ),
//     //   subtitle: Text("Pergunta: ${perguntaAplicada.titulo}"),
//     // ),
//   }
// }

// class RequisitoRadioTile extends StatelessWidget {
//   const RequisitoRadioTile(this.momentoBloc, this.bloc, this.perguntaAplicada,
//       this.requisitoId, this.perguntaSelecionadaId,
//       {Key key})
//       : super(key: key);

//   final DefinirRequisitosPageBloc bloc;
//   final MomentoAplicacaoPageBloc momentoBloc;
//   final PerguntaAplicadaModel perguntaAplicada;
//   final String requisitoId;
//   final String perguntaSelecionadaId;

//   @override
//   Widget build(BuildContext context) {
//     //TODO: mudar para radio ou seleção por toque, porque é pra escolher somente um das opções disponiveis

//     return InkWell(
//         onTap: () {
//           momentoBloc.dispatch(SelecionarRequisitoMomentoAplicacaoPageBlocEvent(
//               requisitoId, perguntaAplicada.id));
//           Scaffold.of(context).showSnackBar(
//             SnackBar(
//               content: Text('Tap'),
//             ),
//           );
//           //Navigator.of(context).pop();
//         },
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           children: <Widget>[
//             Divider(),
//             ListTile(
//               title: Text(
//                 "Questionario: ${perguntaAplicada.questionario.nome}\nReferencia: ${perguntaAplicada.questionario.referencia}",
//                 style: TextStyle(
//                     color: perguntaSelecionadaId == perguntaAplicada.id
//                         ? Colors.green
//                         : null),
//               ),
//               subtitle: Text("Pergunta: ${perguntaAplicada.titulo}"),
//             ),
//           ],
//         )

//         // child: ListTile(
//         //   title: Text(
//         //     "${perguntaSelecionadaId == perguntaAplicada.id ? "(selecionado)" : ""} \n Questionario: ${perguntaAplicada.questionario.nome} \nReferencia: ${perguntaAplicada.questionario.referencia}",
//         //     style: TextStyle(
//         //         color: perguntaSelecionadaId == perguntaAplicada.id
//         //             ? Colors.green
//         //             : null),
//         //   ),
//         //   subtitle: Text("Pergunta: ${perguntaAplicada.titulo}"),
//         // ),
//         );
//   }
// }

// Widget _preambulo() {
//   return Column(
//     children: <Widget>[
//       Padding(
//         padding: EdgeInsets.all(3),
//         child: Text(
//           "Eixo : $_eixo",
//           style: TextStyle(fontSize: 16, color: Colors.blue),
//         ),
//       ),
//       Padding(
//         padding: EdgeInsets.all(3),
//         child: Text(
//           "Setor : $_setor",
//           style: TextStyle(fontSize: 16, color: Colors.blue),
//         ),
//       ),
//       Padding(
//         padding: EdgeInsets.all(3),
//         child: Text(
//           "Questionário : $_questionario",
//           style: TextStyle(fontSize: 16, color: Colors.blue),
//         ),
//       ),
//       Padding(
//         padding: EdgeInsets.all(3),
//         child: Text(
//           "Local : $_local",
//           style: TextStyle(fontSize: 16, color: Colors.blue),
//         ),
//       ),
//       Padding(
//         padding: EdgeInsets.all(3),
//       ),
//       Padding(
//         padding: EdgeInsets.all(5),
//         child: Text("Questionário 03 -> Pergunta 01"),
//       ),
//     ],
//   );
// }
