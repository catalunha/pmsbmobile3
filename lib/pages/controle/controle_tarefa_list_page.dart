import 'package:flutter/material.dart';
import 'package:pmsbmibile3/bootstrap.dart';
import 'package:pmsbmibile3/components/default_scaffold.dart';
import 'package:pmsbmibile3/models/controle_tarefa_model.dart';
import 'package:pmsbmibile3/pages/page_arguments.dart';
import 'package:pmsbmibile3/state/auth_bloc.dart';
import 'package:pmsbmibile3/naosuportato/url_launcher.dart'
    if (dart.library.io) 'package:url_launcher/url_launcher.dart';
import 'package:pmsbmibile3/style/pmsb_colors.dart';
import 'package:pmsbmibile3/style/pmsb_styles.dart';
import 'package:drag_list/drag_list.dart';

import 'controle_tarefa_list_bloc.dart';

class ControleTarefaListPage extends StatefulWidget {
  final AuthBloc authBloc;

  const ControleTarefaListPage(this.authBloc);

  @override
  _ControleTarefaListPageState createState() => _ControleTarefaListPageState();
}

class _ControleTarefaListPageState extends State<ControleTarefaListPage> {
  ControleTarefaListBloc bloc;
  List<String> cards = ["Aberta", "Feita"];
  List<List<String>> childres = [
    ["Aberta 1", "Aberta 2"],
    ["Feita 1", "Feita 2"],
  ];

  @override
  void initState() {
    super.initState();
    bloc =
        ControleTarefaListBloc(Bootstrap.instance.firestore, widget.authBloc);
  }

  @override
  void dispose() {
    super.dispose();
    bloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultScaffold(
      backToRootPage: true,
      title: Text("Controle de Tarefas"),
      body: _buildBody(),
    );
  }

  TextEditingController _cardTextController = TextEditingController();
  TextEditingController _taskTextController = TextEditingController();

  _showAddCard() {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return Dialog(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Add Card",
                    style:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    decoration: InputDecoration(hintText: "Card Title"),
                    controller: _cardTextController,
                  ),
                ),
                SizedBox(
                  height: 30.0,
                ),
                Center(
                  child: RaisedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      _addCard(_cardTextController.text.trim());
                    },
                    child: Text("Add Card"),
                  ),
                )
              ],
            ),
          );
        });
  }

  _addCard(String text) {
    cards.add(text);
    childres.add([]);
    _cardTextController.text = "";
    setState(() {});
  }

  _showAddCardTask(int index) {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return Dialog(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Add Card task",
                    style:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    decoration: InputDecoration(hintText: "Task Title"),
                    controller: _taskTextController,
                  ),
                ),
                SizedBox(
                  height: 30.0,
                ),
                Center(
                  child: RaisedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      _addCardTask(index, _taskTextController.text.trim());
                    },
                    child: Text("Add Task"),
                  ),
                )
              ],
            ),
          );
        });
  }

  _addCardTask(int index, String text) {
    childres[index].add(text);
    _taskTextController.text = "";
    setState(() {});
  }

  _handleReOrder(int oldIndex, int newIndex, int index) {
    var oldValue = childres[index][oldIndex];
    childres[index][oldIndex] = childres[index][newIndex];
    childres[index][newIndex] = oldValue;
    setState(() {});
  }

  _buildBody() {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: cards.length + 1,
      itemBuilder: (context, index) {
        if (index == cards.length)
          return _buildAddCardWidget(context);
        else
          return _buildCard(context, index);
      },
    );
  }

  Widget _buildAddCardWidget(context) {
    return Column(
      children: <Widget>[
        InkWell(
          onTap: () {
            _showAddCard();
          },
          child: Container(
            width: 300.0,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                    blurRadius: 8,
                    offset: Offset(0, 0),
                    color: Color.fromRGBO(127, 140, 141, 0.5),
                    spreadRadius: 2)
              ],
              borderRadius: BorderRadius.circular(10.0),
              color: Colors.white,
            ),
            margin: const EdgeInsets.all(16.0),
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: <Widget>[
                Icon(
                  Icons.add,
                ),
                SizedBox(
                  width: 16.0,
                ),
                Text("Add Card"),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAddCardTaskWidget(context, index) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: InkWell(
        onTap: () {
          _showAddCardTask(index);
        },
        child: Row(
          children: <Widget>[
            Icon(
              Icons.add,
            ),
            SizedBox(
              width: 16.0,
            ),
            Text("Add Card Task"),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context, int index) {
    // return Container(
    //         width: 300.0,
    //   child: ,
    // );
    return Container(
      child: Stack(
        children: <Widget>[
          Container(
            width: 0.300,
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
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    cards[index],
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                /*SingleChildScrollView(
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.7,
                    child: DragAndDropList<String>(
                      childres[index],
                      itemBuilder: (BuildContext context, item) {
                        return _buildCardTask(
                            index, childres[index].indexOf(item));
                      },
                      onDragFinish: (oldIndex, newIndex) {
                        _handleReOrder(oldIndex, newIndex, index);
                      },
                      canBeDraggedTo: (one, two) => true,
                      dragElevation: 8.0,
                    ),
                  ),
               */ // ),
              ],
            ),
          ),
          Positioned.fill(
            child: DragTarget<dynamic>(
              onWillAccept: (data) {
                print(data);
                return true;
              },
              onLeave: (data) {},
              onAccept: (data) {
                if (data['from'] == index) {
                  return;
                }
                childres[data['from']].remove(data['string']);
                childres[index].add(data['string']);
                print(data);
                setState(() {});
              },
              builder: (context, accept, reject) {
                print("--- > $accept");
                print(reject);
                return Container();
              },
            ),
          ),
        ],
      ),
    );
  }

  Container _buildCardTask(int index, int innerIndex) {
    return Container(
      width: 300.0,
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Draggable<dynamic>(
        feedback: Material(
          elevation: 5.0,
          child: Container(
            width: 284.0,
            padding: const EdgeInsets.all(16.0),
            color: Colors.greenAccent,
            child: Text(childres[index][innerIndex]),
          ),
        ),
        childWhenDragging: Container(),
        child: Container(
          padding: const EdgeInsets.all(16.0),
          color: Colors.greenAccent,
          child: Text(childres[index][innerIndex]),
        ),
        data: {"from": index, "string": childres[index][innerIndex]},
      ),
    );
  }
}

/// Selecao de setor para duplicar a tarefa
class SetorListaModalSelect extends StatefulWidget {
  final ControleTarefaListBloc bloc;
  final ControleTarefaModel tarefaID;

  const SetorListaModalSelect(this.bloc, this.tarefaID);

  @override
  _SetorListaModalSelectState createState() =>
      _SetorListaModalSelectState(this.bloc);
}

class _SetorListaModalSelectState extends State<SetorListaModalSelect> {
  final ControleTarefaListBloc bloc;

  _SetorListaModalSelectState(this.bloc);

  Widget _listaSetor() {
    return StreamBuilder<ControleTarefaListBlocState>(
      stream: bloc.stateStream,
      builder: (BuildContext context,
          AsyncSnapshot<ControleTarefaListBlocState> snapshot) {
        if (snapshot.hasError)
          return Center(
            child: Text("Erro. Informe ao administrador do aplicativo"),
          );
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.data.tarefaDuplicadaNoSetorMap.isEmpty) {
          return Center(
            child: Text("Nenhum setor encontrado."),
          );
        }

        var lista = List<Widget>();
        for (var setor in snapshot.data.tarefaDuplicadaNoSetorMap.entries) {
          lista.add(_cardBuild(context, setor.value));
        }

        return ListView(
          children: lista,
        );
      },
    );
  }

  Widget _cardBuild(
      BuildContext context, TarefaDuplicadaNoSetor tarefaDuplicadaNoSetor) {
    return ListTile(
      title: Text('${tarefaDuplicadaNoSetor.setorCensitarioID.nome}'),
      selected: tarefaDuplicadaNoSetor.duplicado,
      trailing: tarefaDuplicadaNoSetor.duplicado
          ? Icon(Icons.check)
          : IconButton(
              icon: Icon(Icons.clear),
              onPressed: () {
                bloc.eventSink(DuplicarTarefaEvent(
                    setorID: tarefaDuplicadaNoSetor.setorCensitarioID,
                    tarefaID: widget.tarefaID));
                Navigator.pop(context);
              },
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Escolha um setor"),
      ),
      body: _listaSetor(),
    );
  }
}
/* _bodyDestinatario(context) {
    return StreamBuilder<ControleTarefaListBlocState>(
      stream: bloc.stateStream,
      builder: (BuildContext context,
          AsyncSnapshot<ControleTarefaListBlocState> snapshot) {
        if (snapshot.hasError) {
          return Text("ERROR");
        }
        if (!snapshot.hasData) {
          return Text("SEM DADOS");
        }
        if (snapshot.hasData) {
          List<Widget> listaWdg = List<Widget>();
          if (snapshot.data.isDataValidDestinatario) {
            for (var controleTarefaID
                in snapshot.data.controleTarefaListDestinatario) {
              listaWdg.add(Card(
                color: PmsbColors.card,
                  child: Column(children: <Widget>[
                ListTile(
                    trailing: Text(
                        '${controleTarefaID.acaoCumprida} de ${controleTarefaID.acaoTotal}'),
                    title: Text(
                        '${controleTarefaID.nome}\nDe: ${controleTarefaID.remetente.nome}'),
                    subtitle: Text(
                        'Inicio: ${controleTarefaID.inicio}\nFim: ${controleTarefaID.fim}\nAtualizada: ${controleTarefaID.modificada}\nid:${controleTarefaID.id}')),
                Wrap(alignment: WrapAlignment.start, children: <Widget>[
                  snapshot.data?.relatorioPdfMakeModel?.pdfGerar != null &&
                          snapshot.data?.relatorioPdfMakeModel?.pdfGerar ==
                              false &&
                          snapshot.data?.relatorioPdfMakeModel?.pdfGerado ==
                              true &&
                          snapshot.data?.relatorioPdfMakeModel?.tipo ==
                              'controle02' &&
                          snapshot.data?.relatorioPdfMakeModel?.document ==
                              controleTarefaID.id
                      ? IconButton(
                          tooltip:
                              'Ver relatório individual desta tarefa recebida.',
                          icon: Icon(Icons.link),
                          onPressed: () async {
                            bloc.eventSink(GerarRelatorioPdfMakeEvent(
                                pdfGerar: false,
                                pdfGerado: false,
                                tipo: 'controle02',
                                collection: 'ControleTarefa',
                                document: controleTarefaID.id));
                            launch(snapshot.data?.relatorioPdfMakeModel?.url);
                          },
                        )
                      : snapshot.data?.relatorioPdfMakeModel?.pdfGerar !=
                                  null &&
                              snapshot.data?.relatorioPdfMakeModel?.pdfGerar ==
                                  true &&
                              snapshot.data?.relatorioPdfMakeModel?.pdfGerado ==
                                  false &&
                              snapshot.data?.relatorioPdfMakeModel?.tipo ==
                                  'controle02' &&
                              snapshot.data?.relatorioPdfMakeModel?.document ==
                                  controleTarefaID.id
                          ? CircularProgressIndicator()
                          : IconButton(
                              tooltip:
                                  'Atualizar PDF individual desta tarefa recebida.',
                              icon: Icon(Icons.picture_as_pdf),
                              onPressed: () async {
                                bloc.eventSink(GerarRelatorioPdfMakeEvent(
                                    pdfGerar: true,
                                    pdfGerado: false,
                                    tipo: 'controle02',
                                    collection: 'ControleTarefa',
                                    document: controleTarefaID.id));
                              },
                            ),
                  IconButton(
                    tooltip: 'Marcar/Atualizar ação',
                    icon: Icon(Icons.check),
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        "/controle/acao_marcar",
                        arguments: controleTarefaID.id,
                      );
                    },
                  ),
                ])
              ])));
            }

            return Column(children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    flex: 10,
                    child: Text(
                        'Setor: ${snapshot.data.usuarioID.setorCensitarioID.nome}'),
                  ),
                  Wrap(alignment: WrapAlignment.start, children: <Widget>[
                    IconButton(
                      tooltip: 'Ver tarefas recebidas concluidas',
                      icon: Icon(Icons.folder),
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          "/controle/concluida",
                          arguments: null,
                        );
                      },
                    ),
                  ]),
                ],
              ),
              Divider(),
              Expanded(
                flex: 10,
                child: listaWdg != null
                    ? ListView(
                        children: listaWdg,
                      )
                    : Container(),
              )
            ]);
          } else {
            return Text('Existem dados inválidos...');
          }
        }
        return Text("Algo não esta certo...");
      },
    );
  }

  _bodyRemetente(context) {
    return StreamBuilder<ControleTarefaListBlocState>(
      stream: bloc.stateStream,
      builder: (BuildContext context,
          AsyncSnapshot<ControleTarefaListBlocState> snapshot) {
        if (snapshot.hasError) {
          return Text("ERROR");
        }
        if (!snapshot.hasData) {
          return Text("SEM DADOS");
        }
        if (snapshot.hasData) {
          List<Widget> listaWdg = List<Widget>();
          if (snapshot.data.isDataValidRemetente) {
            for (var controleTarefaID
                in snapshot.data.controleTarefaListRemetente) {
              listaWdg.add(Card(
                color: PmsbColors.card,
                  child: Column(children: <Widget>[
                ListTile(
                    trailing: Text(
                        '${controleTarefaID.acaoCumprida} de ${controleTarefaID.acaoTotal}'),
                    title: Text(
                        '${controleTarefaID.nome}\nPara: ${controleTarefaID.destinatario.nome}'),
                    subtitle: Text(
                        'Inicio: ${controleTarefaID.inicio}\nFim: ${controleTarefaID.fim}\nAtualizada: ${controleTarefaID.modificada}\nid:${controleTarefaID.id}')),
                Wrap(alignment: WrapAlignment.start, children: <Widget>[
                  controleTarefaID.acaoLink != null
                      ? IconButton(
                          tooltip: 'Ver ação que gerou esta tarefa',
                          icon: Icon(Icons.settings_backup_restore),
                          onPressed: () async {
                            bloc.eventSink(VerAcaoGerouTarefaEvent(
                                acaoLink: controleTarefaID.acaoLink));
                            if (snapshot.data.tarefaBase != null) {
                              Navigator.pushNamed(
                                context,
                                "/controle/acao_concluida",
                                arguments: snapshot.data.tarefaBase,
                              );
                            }
                          },
                        )
                      : Text(''),
                  snapshot.data?.relatorioPdfMakeModel?.pdfGerar != null &&
                          snapshot.data?.relatorioPdfMakeModel?.pdfGerar ==
                              false &&
                          snapshot.data?.relatorioPdfMakeModel?.pdfGerado ==
                              true &&
                          snapshot.data?.relatorioPdfMakeModel?.tipo ==
                              'controle04' &&
                          snapshot.data?.relatorioPdfMakeModel?.document ==
                              controleTarefaID.id
                      ? IconButton(
                          tooltip:
                              'Ver relatório individual desta tarefa designada.',
                          icon: Icon(Icons.link),
                          onPressed: () async {
                            bloc.eventSink(GerarRelatorioPdfMakeEvent(
                                pdfGerar: false,
                                pdfGerado: false,
                                tipo: 'controle04',
                                collection: 'ControleTarefa',
                                document: controleTarefaID.id));
                            launch(snapshot.data?.relatorioPdfMakeModel?.url);
                          },
                        )
                      : snapshot.data?.relatorioPdfMakeModel?.pdfGerar !=
                                  null &&
                              snapshot.data?.relatorioPdfMakeModel?.pdfGerar ==
                                  true &&
                              snapshot.data?.relatorioPdfMakeModel?.pdfGerado ==
                                  false &&
                              snapshot.data?.relatorioPdfMakeModel?.tipo ==
                                  'controle04' &&
                              snapshot.data?.relatorioPdfMakeModel?.document ==
                                  controleTarefaID.id
                          ? CircularProgressIndicator()
                          : IconButton(
                              tooltip:
                                  'Atualizar PDF individual desta tarefa designada.',
                              icon: Icon(Icons.picture_as_pdf),
                              onPressed: () async {
                                bloc.eventSink(GerarRelatorioPdfMakeEvent(
                                    pdfGerar: true,
                                    pdfGerado: false,
                                    tipo: 'controle04',
                                    collection: 'ControleTarefa',
                                    document: controleTarefaID.id));
                              },
                            ),
                  IconButton(
                    tooltip: 'Duplicar tarefa',
                    icon: Icon(Icons.content_copy),
                    onPressed: () {
                      bloc.eventSink(
                          UpdateTarefaDuplicadaPorSetorEvent(controleTarefaID));
                      showModalBottomSheet(
                          context: context,
                          builder: (BuildContext bc) {
                            return SetorListaModalSelect(
                                bloc, controleTarefaID);
                          });
                    },
                  ),
                  IconButton(
                    tooltip: 'Editar ação',
                    icon: Icon(Icons.check),
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        "/controle/acao_list",
                        arguments: controleTarefaID.id,
                      );
                    },
                  ),
                  IconButton(
                    tooltip: 'Editar Tarefa',
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        "/controle/tarefa_crud",
                        arguments: ControlePageArguments(
                            tarefa: controleTarefaID.id, acao: null),
                      );
                    },
                  ),
                ])
              ])));
            }

            return Column(children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    flex: 10,
                    child: Text(
                        'Setor: ${snapshot.data.usuarioID.setorCensitarioID.nome}'),
                  ),
                  Wrap(alignment: WrapAlignment.start, children: <Widget>[
                    IconButton(
                      tooltip: 'Ver tarefas designadas concluidas',
                      icon: Icon(Icons.folder),
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          "/controle/concluida",
                          arguments: null,
                        );
                      },
                    ),
                    IconButton(
                      tooltip: 'Adicionar mais uma tarefa',
                      icon: Icon(Icons.assignment_turned_in),
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          "/controle/tarefa_crud",
                          arguments:
                              ControlePageArguments(tarefa: null, acao: null),
                        );
                      },
                    ),
                  ]),
                ],
              ),
              Divider(),
              Expanded(
                flex: 10,
                child: ListView(
                  children: listaWdg,
                ),
              )
            ]);
          } else {
            return Text('Existem dados inválidos...');
          }
        }
        return Text("Algo não esta certo...");
      },
    );
  }

  _body(context) {
    return TabBarView(
      children: [
        _bodyDestinatario(context),
        _bodyRemetente(context),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {

    return DefaultTabController(
      length: 2,
      child: DefaultScaffold(
        backToRootPage: true,
        bottom: TabBar(
          tabs: [
            Tab(
                child: Text(
              "Destinatário/Recebida",
              style: PmsbStyles.textoSecundario,
            )),
            Tab(
                child: Text(
              "Remetente/Designada",
              style: PmsbStyles.textoSecundario,
            )),
          ],
        ),
        title: Text('Controle de tarefas'),
        body: _body(context),
      ),
    );
  */ //}
