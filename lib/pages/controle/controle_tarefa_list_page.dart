import 'package:flutter/material.dart';
import 'package:pmsbmibile3/bootstrap.dart';
import 'package:pmsbmibile3/components/default_scaffold.dart';
import 'package:pmsbmibile3/state/auth_bloc.dart';

import 'controle_tarefa_list_bloc.dart';

class ControleTarefaListPage extends StatefulWidget {
  final AuthBloc authBloc;

  const ControleTarefaListPage(this.authBloc);

  @override
  _ControleTarefaListPageState createState() => _ControleTarefaListPageState();
}

class _ControleTarefaListPageState extends State<ControleTarefaListPage> {
  ControleTarefaListBloc bloc;

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

  _bodyDestinatario(context) {
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
          if (snapshot.data.isDataValidDestinatario) {
            List<Widget> listaWdg = List<Widget>();
            for (var controleTarefaID
                in snapshot.data.controleTarefaListDestinatario) {
              listaWdg.add(Column(children: <Widget>[
                ListTile(
                    title: Text(
                        '${controleTarefaID.nome}\nDe: ${controleTarefaID.remetente.nome}'),
                    subtitle: Text(
                        'Inicio: ${controleTarefaID.inicio}\nFim: ${controleTarefaID.fim}\nConcluida: ${controleTarefaID.acaoCumprida} de ${controleTarefaID.acaoTotal}')),
                        Flexible(
                flex: 1,
                        child: Slider(
                  activeColor: Colors.indigoAccent,
                  min: 0.0,
                  max: 15.0,
                  onChanged:null,
                  value: 10,
                )),
                Wrap(alignment: WrapAlignment.start, children: <Widget>[
                  IconButton(
                    tooltip: 'Gerar PDF desta tarefa',
                    icon: Icon(Icons.picture_as_pdf),
                    onPressed: () {},
                  ),
                  IconButton(
                    tooltip: 'Marcar/Atualizar ação',
                    icon: Icon(Icons.check),
                    onPressed: () {
                      // Listar paginas de perguntas
                      Navigator.pushNamed(
                              context,
                              "/controle/acao_marcar",
                              arguments: controleTarefaID.id,
                            );
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
                    IconButton(
                      tooltip: 'Ver tarefas recebidas concluidas',
                      icon: Icon(Icons.folder),
                      onPressed: () {
                        // Listar paginas de perguntas
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
          if (snapshot.data.isDataValidRemetente) {
            List<Widget> listaWdg = List<Widget>();
            for (var controleTarefaID
                in snapshot.data.controleTarefaListRemetente) {
              listaWdg.add(Column(children: <Widget>[
                ListTile(
                    title: Text(
                        '${controleTarefaID.nome}\nPara: ${controleTarefaID.destinatario.nome}'),
                    subtitle: Text(
                        'Inicio: ${controleTarefaID.inicio}\nFim: ${controleTarefaID.fim}\nConcluida: ${controleTarefaID.acaoCumprida} de ${controleTarefaID.acaoTotal}\nid:${controleTarefaID.id}')),
                //          Slider(
                //   min: 0.0,
                //   max: 15.0,
                //   onChanged:null,
                //   value: 7,
                // ),
                Wrap(alignment: WrapAlignment.start, children: <Widget>[
                  IconButton(
                    tooltip: 'Duplicar tarefa',
                    icon: Icon(Icons.content_copy),
                    onPressed: () {
                      // Listar paginas de perguntas
                      // Navigator.pushNamed(
                      //         context,
                      //         "/controle/acao_marcar",
                      //         arguments: controleTarefaID.id,
                      //       );
                    },
                  ),                   IconButton(
                    tooltip: 'Gerar PDF desta tarefa',
                    icon: Icon(Icons.picture_as_pdf),
                    onPressed: () {},
                  ),
                  IconButton(
                    tooltip: 'Editar ação',
                    icon: Icon(Icons.check_box),
                    onPressed: () {
                      Navigator.pushNamed(
                              context,
                              "/controle/acao_list",
                              arguments: controleTarefaID.id,
                            );
                    },
                  ),                  IconButton(
                    tooltip: 'Editar Tarefa',
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      Navigator.pushNamed(
                              context,
                              "/controle/tarefa_crud",
                              arguments: controleTarefaID.id,
                            );
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
                    IconButton(
                      tooltip: 'Ver tarefas designadas concluidas',
                      icon: Icon(Icons.folder),
                      onPressed: () {
                        // Listar paginas de perguntas
                      },
                    ),                    IconButton(
                      tooltip: 'Adicionar mais uma tarefa',
                      icon: Icon(Icons.plus_one),
                      onPressed: () {
                      Navigator.pushNamed(
                              context,
                              "/controle/tarefa_crud",
                              arguments: null,
                            );                      },
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
        bottom: TabBar(
          tabs: [
            Tab(text: "Destinatario/Recebida"),
            Tab(text: "Remetente/Designada"),
          ],
        ),
        title: Text('Controle de tarefas'),
        body: _body(context),
      ),
      // ),
    );
  }
}
