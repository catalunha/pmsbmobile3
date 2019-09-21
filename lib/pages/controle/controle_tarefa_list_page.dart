import 'package:flutter/material.dart';
import 'package:pmsbmibile3/bootstrap.dart';
import 'package:pmsbmibile3/components/default_scaffold.dart';
import 'package:pmsbmibile3/models/controle_tarefa_model.dart';
import 'package:pmsbmibile3/models/setor_censitario_model.dart';
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
          List<Widget> listaWdg = List<Widget>();
          if (snapshot.data.isDataValidDestinatario) {
            for (var controleTarefaID
                in snapshot.data.controleTarefaListDestinatario) {
              listaWdg.add(Column(children: <Widget>[
                ListTile(
                    trailing: Text(
                        '${controleTarefaID.acaoCumprida} de ${controleTarefaID.acaoTotal}'),
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
                    tooltip: 'Marcar/Atualizar ação',
                    icon: Icon(Icons.check_box),
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
                        'Setor: ${snapshot.data.usuarioID.setorCensitarioID.nome}'),
                  ),
                  Wrap(alignment: WrapAlignment.start, children: <Widget>[
                    IconButton(
                      tooltip: 'Gerar PDF desta tarefa',
                      icon: Icon(Icons.picture_as_pdf),
                      onPressed: () {
                        // Listar paginas de perguntas
                      },
                    ),
                    // IconButton(
                    //   tooltip: 'Filtrar por',
                    //   icon: Icon(Icons.search),
                    //   onPressed: () {
                    //     // Listar paginas de perguntas
                    //   },
                    // ),
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
        // return Text("Algo não esta certo...");
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
              listaWdg.add(Column(children: <Widget>[
                ListTile(
                    trailing: Text(
                        '${controleTarefaID.acaoCumprida} de ${controleTarefaID.acaoTotal}'),
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
                  IconButton(
                    tooltip: 'Duplicar tarefa',
                    icon: Icon(Icons.content_copy),
                    onPressed: () {
                      showModalBottomSheet(
                context: context,
                builder: (BuildContext bc) {
                  return SetorListaModalSelect(bloc,controleTarefaID);
                });
                    },
                  ),
                  IconButton(
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
                  ),
                  IconButton(
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
                        'Setor: ${snapshot.data.usuarioID.setorCensitarioID.nome}'),
                  ),
                  Wrap(alignment: WrapAlignment.start, children: <Widget>[
                    IconButton(
                      tooltip: 'Gerar PDF desta tarefa',
                      icon: Icon(Icons.picture_as_pdf),
                      onPressed: () {
                        // Listar paginas de perguntas
                      },
                    ),
                    // IconButton(
                    //   tooltip: 'Filtrar por',
                    //   icon: Icon(Icons.search),
                    //   onPressed: () {
                    //     // Listar paginas de perguntas
                    //   },
                    // ),
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
                      icon: Icon(Icons.plus_one),
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          "/controle/tarefa_crud",
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



/// Selecao de usuario que vao receber alerta
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
        if (snapshot.data.setorList == null) {
          return Center(
            child: Text("Nenhum setor encontrado."),
          );
        }
        if (snapshot.data.setorList.isEmpty) {
          return Center(
            child: Text("Vazio."),
          );
        }

        // var usuario = Map<String, UsuarioModel>();

        // usuario = snapshot.data?.setorList;
        var lista = List<Widget>();
        for (var setor in snapshot.data.setorList) {
          // print('setor: ${item.key}');
          lista.add(_cardBuild(context, setor));
        }

        return ListView(
          children: lista,
        );
      },
    );

    // return ListView(
    //   children: valores.keys.map((String key) {
    //     return CheckboxListTile(
    //       title: Text(key),
    //       value: valores[key],
    //       onChanged: (bool value) {
    //         if (key == 'Todos') {
    //           _marcarTodosDaListaComoTrue(value);
    //         } else {
    //           setState(() {
    //             valores[key] = value;
    //           });
    //         }
    //       },
    //     );
    //   }).toList(),
    // );
  }

  Widget _cardBuild(BuildContext context, SetorCensitarioModel setor) {
    // print(setor.nome);
    // return ListTile(
    //   title: Text(setor.nome),
    //   leading: setor.lido ?  Icon(Icons.playlist_add_check): Icon(Icons.not_interested),
    // );
    // return CheckboxListTile(
    //   title: Text(setor.nome),
    //   value: setor.alertar == null ? false : setor.alertar,
    //   onChanged: (bool alertar) {
    //     bloc.eventSink(UpDateAlertaEvent(setorChatID: key, alertar: alertar));
    //   },
    // );
    return ListTile(
      title: Text('${setor.nome}'),
      // subtitle: Text('Setor: ${setor.eixoID?.nome}'),
      trailing: IconButton(
        icon: Icon(Icons.check),
        onPressed: () {
          bloc.eventSink(SelectSetorIDEvent(setorID:setor,tarefaID:widget.tarefaID));
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
        // automaticallyImplyLeading: false,
        // backgroundColor: Colors.blueGrey,
        // actions: <Widget>[
        //   IconButton(
        //     icon: Icon(Icons.check_box),
        //     onPressed: () {
        //       bloc.eventSink(UpDateAlertarTodosEvent(true));
        //     },
        //   ),
        //   IconButton(
        //     icon: Icon(Icons.check_box_outline_blank),
        //     onPressed: () {
        //       bloc.eventSink(UpDateAlertarTodosEvent(false));
        //     },
        //   ),
        //   IconButton(
        //     icon: Icon(Icons.repeat),
        //     onPressed: () {
        //       bloc.eventSink(UpDateAlertarTodosEvent(null));
        //     },
        //   ),
        //   // RaisedButton(
        //   //     child: Text("Marcar todos"),
        //   //     textColor: Colors.blue,
        //   //     color: Colors.white,
        //   //     onPressed: () {
        //   //       bloc.eventSink(UpDateAlertarTodosEvent());
        //   //     }),
        //   // RaisedButton(
        //   //     child: Text("Salvar"),
        //   //     textColor: Colors.blue,
        //   //     color: Colors.white,
        //   //     onPressed: () {
        //   //       Navigator.pop(context);
        //   //     })
        // ],
      ),
      body: _listaSetor(),
    );
  }
}
