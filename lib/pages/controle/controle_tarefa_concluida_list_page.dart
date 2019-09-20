import 'package:flutter/material.dart';
import 'package:pmsbmibile3/bootstrap.dart';
import 'package:pmsbmibile3/components/default_scaffold.dart';
import 'package:pmsbmibile3/pages/controle/controle_tarefa_concluida_list_bloc.dart';
import 'package:pmsbmibile3/state/auth_bloc.dart';


class ControleTarefaConcluidaListPage extends StatefulWidget {
  final AuthBloc authBloc;

  const ControleTarefaConcluidaListPage(this.authBloc);

  @override
  _ControleTarefaConcluidaListPageState createState() => _ControleTarefaConcluidaListPageState();
}

class _ControleTarefaConcluidaListPageState extends State<ControleTarefaConcluidaListPage> {
  ControleTarefaConcluidaListBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc =
        ControleTarefaConcluidaListBloc(Bootstrap.instance.firestore, widget.authBloc);
  }

  @override
  void dispose() {
    super.dispose();
    bloc.dispose();
  }

  _bodyDestinatario(context) {
    return StreamBuilder<ControleTarefaConcluidaListBlocState>(
      stream: bloc.stateStream,
      builder: (BuildContext context,
          AsyncSnapshot<ControleTarefaConcluidaListBlocState> snapshot) {
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
              listaWdg.add(Column(children: <Widget>[
                ListTile(
                  trailing: Text('${controleTarefaID.acaoCumprida} de ${controleTarefaID.acaoTotal}'),
                    title: Text(
                        '${controleTarefaID.nome}\nDe: ${controleTarefaID.remetente.nome}'),
                    subtitle: Text(
                        'Inicio: ${controleTarefaID.inicio}\nFim: ${controleTarefaID.fim}\n${controleTarefaID.id}')),
                // Flexible(
                //     flex: 1,
                //     child: Slider(
                //       activeColor: Colors.indigoAccent,
                //       min: 0.0,
                //       max: 15.0,
                //       onChanged: null,
                //       value: 10,
                //     )),
                Wrap(alignment: WrapAlignment.start, children: <Widget>[
                  IconButton(
                    tooltip: 'Gerar PDF desta tarefa',
                    icon: Icon(Icons.picture_as_pdf),
                    onPressed: () {},
                  ),
                  IconButton(
                    tooltip: 'Reativar tarefa',
                    icon: Icon(Icons.reply),
                    onPressed: () {
                                         bloc.eventSink(AtivarTarefaIDEvent(controleTarefaID.id));

                    },
                  ),
                ])
              ]));
            }

            return Column(children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    flex: 10,
                    child: Text(
                        'Município: ${snapshot.data.usuarioID.setorCensitarioID.nome}'),
                  ),
                  Wrap(alignment: WrapAlignment.start, children: <Widget>[
                    IconButton(
                      tooltip: 'Gerar PDF desta tarefa',
                      icon: Icon(Icons.picture_as_pdf),
                      onPressed: () {
                        // Listar paginas de perguntas
                      },
                    ),
                    IconButton(
                      tooltip: 'Filtrar por',
                      icon: Icon(Icons.search),
                      onPressed: () {
                        // Listar paginas de perguntas
                      },
                    ),
                    // IconButton(
                    //   tooltip: 'Ver tarefas recebidas concluidas',
                    //   icon: Icon(Icons.folder),
                    //   onPressed: () {
                    //     // Listar paginas de perguntas
                    //   },
                    // ),
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
        // return Text("Algo não esta certo...");
      },
    );
  }

  _bodyRemetente(context) {
    return StreamBuilder<ControleTarefaConcluidaListBlocState>(
      stream: bloc.stateStream,
      builder: (BuildContext context,
          AsyncSnapshot<ControleTarefaConcluidaListBlocState> snapshot) {
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
              listaWdg.add(Column(children: <Widget>[
                ListTile(
                                    trailing: Text('${controleTarefaID.acaoCumprida} de ${controleTarefaID.acaoTotal}'),

                    title: Text(
                        '${controleTarefaID.nome}\nPara: ${controleTarefaID.destinatario.nome}'),
                    subtitle: Text(
                        'Inicio: ${controleTarefaID.inicio}\nFim: ${controleTarefaID.fim}\nid:${controleTarefaID.id}')),
                //          Slider(
                //   min: 0.0,
                //   max: 15.0,
                //   onChanged:null,
                //   value: 7,
                // ),
                Wrap(alignment: WrapAlignment.start, children: <Widget>[
                  // IconButton(
                  //   tooltip: 'Duplicar tarefa',
                  //   icon: Icon(Icons.content_copy),
                  //   onPressed: () {
                  //     // Listar paginas de perguntas
                  //     // Navigator.pushNamed(
                  //     //         context,
                  //     //         "/controle/acao_marcar",
                  //     //         arguments: controleTarefaID.id,
                  //     //       );
                  //   },
                  // ),
                  IconButton(
                    tooltip: 'Gerar PDF desta tarefa',
                    icon: Icon(Icons.picture_as_pdf),
                    onPressed: () {},
                  ),
                  // IconButton(
                  //   tooltip: 'Editar ação',
                  //   icon: Icon(Icons.check_box),
                  //   onPressed: () {
                  //     Navigator.pushNamed(
                  //       context,
                  //       "/controle/acao_list",
                  //       arguments: controleTarefaID.id,
                  //     );
                  //   },
                  // ),
                  IconButton(
                    tooltip: 'Reativar tarefa',
                    icon: Icon(Icons.reply),
                    onPressed: () {
                      bloc.eventSink(AtivarTarefaIDEvent(controleTarefaID.id));
                    },
                  ),
                ])
              ]));
            }

            return Column(children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    flex: 10,
                    child: Text(
                        'Município: ${snapshot.data.usuarioID.setorCensitarioID.nome}'),
                  ),
                  Wrap(alignment: WrapAlignment.start, children: <Widget>[
                    IconButton(
                      tooltip: 'Gerar PDF desta tarefa',
                      icon: Icon(Icons.picture_as_pdf),
                      onPressed: () {
                        // Listar paginas de perguntas
                      },
                    ),
                    IconButton(
                      tooltip: 'Filtrar por',
                      icon: Icon(Icons.search),
                      onPressed: () {
                        // Listar paginas de perguntas
                      },
                    ),
                    // IconButton(
                    //   tooltip: 'Ver tarefas designadas concluidas',
                    //   icon: Icon(Icons.folder),
                    //   onPressed: () {
                    //     // Listar paginas de perguntas
                    //   },
                    // ),
                    // IconButton(
                    //   tooltip: 'Adicionar mais uma tarefa',
                    //   icon: Icon(Icons.plus_one),
                    //   onPressed: () {
                    //     Navigator.pushNamed(
                    //       context,
                    //       "/controle/tarefa_crud",
                    //       arguments: null,
                    //     );
                    //   },
                    // ),
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
    
      child: Scaffold(
        appBar: AppBar(
            bottom: TabBar(
          tabs: [
            Tab(text: "Destinatario/Recebida"),
            Tab(text: "Remetente/Designada"),
          ],
        ),
        title: Text('Tarefas concluídas'),
        ),
        body: _body(context),
      
      ),
    );
  }
}
