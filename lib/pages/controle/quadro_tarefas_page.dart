import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pmsbmibile3/components/default_scaffold.dart';
import 'package:pmsbmibile3/models/models_controle/acao_model.dart';
import 'package:pmsbmibile3/models/models_controle/anexos_model.dart';
import 'package:pmsbmibile3/models/models_controle/etiqueta_model.dart';
import 'package:pmsbmibile3/models/models_controle/feed_model.dart';
import 'package:pmsbmibile3/models/models_controle/tarefa_model.dart';
import 'package:pmsbmibile3/pages/controle/controle_tarefa_page.dart';
import 'package:pmsbmibile3/state/auth_bloc.dart';
import 'package:pmsbmibile3/style/pmsb_colors.dart';
import 'package:flutter_list_drag_and_drop/drag_and_drop_list.dart';
import 'package:pmsbmibile3/widgets/tarefa_card_widget.dart';

// import 'package:pmsbmibile3/naosuportato/url_launcher.dart'
//     if (dart.library.io) 'package:url_launcher/url_launcher.dart';

class QuadroTarefasPageHomePage extends StatefulWidget {
  final AuthBloc authBloc;

  const QuadroTarefasPageHomePage(this.authBloc);

  @override
  _QuadroTarefasPageHomePageState createState() =>
      _QuadroTarefasPageHomePageState();
}

class _QuadroTarefasPageHomePageState extends State<QuadroTarefasPageHomePage> {
  static List<Feed> listaFeed = [
    Feed(
        anexos: [
          Anexo(tipo: "url", titulo: "Url teste", url: "www.google.com")
        ],
        usuario: "Lucas teste",
        dataPostagem: "15 de julho de 2020",
        corpoTexto:
            "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries,"),
    Feed(
        anexos: [
          Anexo(tipo: "url", titulo: "Url teste", url: "www.google.com")
        ],
        usuario: "Lucas teste",
        dataPostagem: "15 de julho de 2020",
        corpoTexto:
            "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries,"),
    Feed(
        anexos: [
          Anexo(tipo: "url", titulo: "Url teste", url: "www.google.com")
        ],
        usuario: "Lucas teste",
        dataPostagem: "15 de julho de 2020",
        corpoTexto:
            "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries,"),
  ];

  static List<Acao> listaAcao = [
    Acao(titulo: "", status: true),
    Acao(titulo: "", status: false),
  ];

  static List<Etiqueta> listaEtiquetas = [
    Etiqueta(cor: 0xFF20BBE8, titulo: "Wip"),
    Etiqueta(cor: 0xFFFF5733, titulo: "Help"),
    Etiqueta(cor: 0xFF8FD619, titulo: "Working"),
  ];

  TarefaModel tarefa01 = new TarefaModel(
      descricaoAtividade:
          "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries,",
      tituloAtividade: "Título do Card 01",
      acoes: listaAcao,
      etiquetas: listaEtiquetas,
      feed: listaFeed
      // publico: true,
      );

  List<String> cards = [
    "Story",
    "Pendente",
    "Em andamento",
    "Em avaliação",
    "Concluído"
  ];
  List<List<String>> childres = [
    ["ToDo 1", "ToDo 2"],
    ["Done 1", "Done 2"],
    [],
    [],
    [],
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultScaffold(
      backgroundColor: PmsbColors.navbar,
      backToRootPage: false,
      title: Text("Quadro 01"),
      body: body(context),
    );
  }

  Widget body(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          SizedBox(height: 15),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.10,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Quadro 01",
                  style: TextStyle(
                      fontSize: 18, color: PmsbColors.texto_terciario),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.05,
            ),
            child: Divider(
              color: Colors.white12,
              height: 15,
            ),
          ),
          SizedBox(height: 15),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.05,
              ),
              child: _listaColunas(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _listaColunas(BuildContext context) {
    // return Listener(
    //   onPointerMove: (PointerMoveEvent onPointerMove){
    //     // if((MediaQuery.of(context).size.width-30)>){

    //     // }
    //     print('X1: ${onPointerMove.position.dx}, Y1: ${onPointerMove.position.dy}');
    //   },
    // onPointerSignal: (PointerSignalEvent event) {
    //   // if (event is PointerMoveEvent) {
    //     print('x: ${event.position.dx}, y: ${event.position.dy}');
    //    // print('scroll delta: ${event.scrollDelta}');
    //   // }
    // },
    // child:
    return Container(
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: cards.length,
        itemBuilder: (context, index) {
          return _gerarColuna(context, index);
        },
      ),
    );
    // // );
  }

  Widget _gerarColuna(BuildContext context, int index) {
    return Container(
      child: Stack(
        children: <Widget>[
          Container(
            width: 300.0,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                    blurRadius: 8,
                    offset: Offset(0, 0),
                    color: Color.fromRGBO(127, 140, 141, 0.5),
                    spreadRadius: 1)
              ],
              borderRadius: BorderRadius.circular(10.0),
              color: Colors.white,
            ),
            margin: const EdgeInsets.all(16.0),
            height: MediaQuery.of(context).size.height * 0.8,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Text(
                        cards[index],
                        style: TextStyle(
                          color: Colors.blueGrey,
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                          icon: Icon(
                            Icons.add,
                            color: Colors.blueGrey,
                          ),
                          onPressed: () {})
                    ],
                  ),
                ),
                SingleChildScrollView(
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.7,
                    // child: ReorderableListView(
                    //   onReorder: (oldIndex, newIndex) {
                    //     setState(() {
                    //       _handleReOrder(oldIndex, newIndex, index);
                    //     });
                    //   },
                    //   scrollDirection: Axis.vertical,
                    //   padding: EdgeInsets.symmetric(vertical: 8.0),
                    //   children: List.generate(
                    //     childres[index].length,
                    //     (indexCard) {
                    //       return _cardTarefa(
                    //         indexCard,
                    //         childres[index].indexOf(childres[index][indexCard]),
                    //       );
                    //     },
                    //   ),
                    // ),

                    child: DragAndDropList<String>(
                      childres[index],
                      itemBuilder: (BuildContext context, item) {
                        return _cardTarefa(
                          index,
                          childres[index].indexOf(item),
                        );
                      },
                      onDragFinish: (oldIndex, newIndex) {
                        setState(() {
                          _handleReOrder(oldIndex, newIndex, index);
                        });
                      },
                      canBeDraggedTo: (one, two) => true,
                      dragElevation: 8.0,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned.fill(
            child: DragTarget<dynamic>(
              onWillAccept: (data) {
                // print(data);
                return true;
              },
              onLeave: (data) {},
              onAccept: (data) {
                if (data['from'] == index) {
                  return;
                }
                childres[data['from']].remove(data['string']);
                childres[index].add(data['string']);
                setState(() {});
              },
              builder: (context, accept, reject) {
                return Container();
              },
            ),
          ),
        ],
      ),
    );
  }

  Container _cardTarefa(int index, int innerIndex) {
    return Container(
      key: Key('$index'),
      width: 300.0,
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Draggable<dynamic>(
        feedback: Material(
          elevation: 5.0,
          child: Container(
            width: 284.0,
            padding: const EdgeInsets.all(16.0),
            color: PmsbColors.card,
            child: Text('${tarefa01.tituloAtividade}'),
          ),
        ),
        childWhenDragging: Container(),
        child: TarefaCardWidget(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => (ControleTarefaPage(
                  tarefa: tarefa01,
                )),
              ),
            );
          },
          tarefa: tarefa01,
          cor: PmsbColors.card,
        ),
        data: {"from": index, "string": childres[index][innerIndex]},
      ),
    );
  }

  _handleReOrder(int oldIndex, int newIndex, int index) {
    var oldValue = childres[index][oldIndex];
    childres[index][oldIndex] = childres[index][newIndex];
    childres[index][newIndex] = oldValue;
  }

  // Widget _buildAddCardWidget(context) {
  //   return Column(
  //     children: <Widget>[
  //       InkWell(
  //         onTap: () {
  //           _showAddCard();
  //         },
  //         child: Container(
  //           width: 300.0,
  //           decoration: BoxDecoration(
  //             boxShadow: [
  //               BoxShadow(
  //                   blurRadius: 8,
  //                   offset: Offset(0, 0),
  //                   color: Color.fromRGBO(127, 140, 141, 0.5),
  //                   spreadRadius: 2)
  //             ],
  //             borderRadius: BorderRadius.circular(10.0),
  //             color: Colors.white,
  //           ),
  //           margin: const EdgeInsets.all(16.0),
  //           padding: const EdgeInsets.all(16.0),
  //           child: Row(
  //             children: <Widget>[
  //               Icon(
  //                 Icons.add,
  //               ),
  //               SizedBox(
  //                 width: 16.0,
  //               ),
  //               Text("Add Card"),
  //             ],
  //           ),
  //         ),
  //       ),
  //     ],
  //   );
  // }

  // Widget _buildAddCardTaskWidget(context, index) {
  //   return Container(
  //     margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
  //     child: InkWell(
  //       onTap: () {
  //         _showAddCardTask(index);
  //       },
  //       child: Row(
  //         children: <Widget>[
  //           Icon(
  //             Icons.add,
  //           ),
  //           SizedBox(
  //             width: 16.0,
  //           ),
  //           Text("Add Card Task jhg"),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  // _showAddCard() {
  //   showDialog(
  //       context: context,
  //       barrierDismissible: true,
  //       builder: (context) {
  //         return Dialog(
  //           child: Column(
  //             mainAxisSize: MainAxisSize.min,
  //             children: <Widget>[
  //               Padding(
  //                 padding: const EdgeInsets.all(8.0),
  //                 child: Text(
  //                   "Add Card",
  //                   style:
  //                       TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
  //                 ),
  //               ),
  //               Padding(
  //                 padding: const EdgeInsets.all(8.0),
  //                 child: TextField(
  //                   decoration: InputDecoration(hintText: "Card Title"),
  //                   controller: _cardTextController,
  //                 ),
  //               ),
  //               SizedBox(
  //                 height: 30.0,
  //               ),
  //               Center(
  //                 child: RaisedButton(
  //                   onPressed: () {
  //                     Navigator.of(context).pop();
  //                     _addCard(_cardTextController.text.trim());
  //                   },
  //                   child: Text("Add Card"),
  //                 ),
  //               )
  //             ],
  //           ),
  //         );
  //       });
  // }

  // _addCard(String text) {
  //   cards.add(text);
  //   childres.add([]);
  //   _cardTextController.text = "";
  //   setState(() {});
  // }

  // _showAddCardTask(int index) {
  //   showDialog(
  //       context: context,
  //       barrierDismissible: true,
  //       builder: (context) {
  //         return Dialog(
  //           child: Column(
  //             mainAxisSize: MainAxisSize.min,
  //             children: <Widget>[
  //               Padding(
  //                 padding: const EdgeInsets.all(8.0),
  //                 child: Text(
  //                   "Add Card task",
  //                   style:
  //                       TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
  //                 ),
  //               ),
  //               Padding(
  //                 padding: const EdgeInsets.all(8.0),
  //                 child: TextField(
  //                   decoration: InputDecoration(hintText: "Task Title"),
  //                   controller: _taskTextController,
  //                 ),
  //               ),
  //               SizedBox(
  //                 height: 30.0,
  //               ),
  //               Center(
  //                 child: RaisedButton(
  //                   onPressed: () {
  //                     Navigator.of(context).pop();
  //                     _addCardTask(index, _taskTextController.text.trim());
  //                   },
  //                   child: Text("Add Task"),
  //                 ),
  //               )
  //             ],
  //           ),
  //         );
  //       });
  // }

  // _addCardTask(int index, String text) {
  //   childres[index].add(text);
  //   _taskTextController.text = "";
  //   setState(() {});
  // }
}
