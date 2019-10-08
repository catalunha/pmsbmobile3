import 'package:flutter/material.dart';
import 'package:pmsbmibile3/bootstrap.dart';
import 'package:pmsbmibile3/components/default_scaffold.dart';
import 'package:pmsbmibile3/models/controle_tarefa_model.dart';
import 'package:pmsbmibile3/models/setor_censitario_model.dart';
import 'package:pmsbmibile3/pages/page_arguments.dart';
import 'package:pmsbmibile3/services/pdf_create_service.dart';
import 'package:pmsbmibile3/services/pdf_save_service.dart';
import 'package:pmsbmibile3/state/auth_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

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
    bloc = ControleTarefaListBloc(Bootstrap.instance.firestore, widget.authBloc);
  }

  @override
  void dispose() {
    super.dispose();
    bloc.dispose();
  }

  _bodyDestinatario(context) {
    return StreamBuilder<ControleTarefaListBlocState>(
      stream: bloc.stateStream,
      builder: (BuildContext context, AsyncSnapshot<ControleTarefaListBlocState> snapshot) {
        if (snapshot.hasError) {
          return Text("ERROR");
        }
        if (!snapshot.hasData) {
          return Text("SEM DADOS");
        }
        if (snapshot.hasData) {
          List<Widget> listaWdg = List<Widget>();
          if (snapshot.data.isDataValidDestinatario) {
            for (var controleTarefaID in snapshot.data.controleTarefaListDestinatario) {
              listaWdg.add(Column(children: <Widget>[
                ListTile(
                    trailing: Text('${controleTarefaID.acaoCumprida} de ${controleTarefaID.acaoTotal}'),
                    title: Text('${controleTarefaID.nome}\nDe: ${controleTarefaID.remetente.nome}'),
                    subtitle: Text(
                        'Inicio: ${controleTarefaID.inicio}\nFim: ${controleTarefaID.fim}\nAtualizada: ${controleTarefaID.modificada}\nid:${controleTarefaID.id}')),
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
                  // IconButton(
                  //   tooltip: 'Relatorio em PDF.',
                  //   icon: Icon(Icons.picture_as_pdf),
                  //   onPressed: () async {
                  //     var pdf =
                  //         await PdfCreateService.pdfwidgetForControleTarefa(
                  //             controleTarefaID);
                  //     PdfSaveService.generatePdfAndOpen(pdf);
                  //   },
                  // ),
                  snapshot.data?.relatorioPdfMakeModel?.pdfGerar != null &&
                          snapshot.data?.relatorioPdfMakeModel?.pdfGerar == false &&
                          snapshot.data?.relatorioPdfMakeModel?.pdfGerado == true &&
                          snapshot.data?.relatorioPdfMakeModel?.tipo == 'controle02' &&
                          snapshot.data?.relatorioPdfMakeModel?.document == controleTarefaID.id
                      ? IconButton(
                          tooltip: 'Ver relatório individual desta tarefa recebida.',
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
                      : IconButton(
                          tooltip: 'Atualizar PDF individual desta tarefa recebida.',
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
                    child: Text('Setor: ${snapshot.data.usuarioID.setorCensitarioID.nome}'),
                  ),
                  Wrap(alignment: WrapAlignment.start, children: <Widget>[
                    // IconButton(
                    //   tooltip: 'Relatorio em PDF.',
                    //   icon: Icon(Icons.picture_as_pdf),
                    //   onPressed: () async {
                    //     var pdf = await PdfCreateService
                    //         .pdfwidgetForControleTarefaDoUsuario(
                    //             usuarioModel: snapshot.data.usuarioID,
                    //             remetente: false,
                    //             concluida: false);
                    //     PdfSaveService.generatePdfAndOpen(pdf);
                    //   },
                    // ),
                    snapshot.data?.relatorioPdfMakeModel?.pdfGerar != null &&
                            snapshot.data?.relatorioPdfMakeModel?.pdfGerar == false &&
                            snapshot.data?.relatorioPdfMakeModel?.pdfGerado == true &&
                            snapshot.data?.relatorioPdfMakeModel?.tipo == 'controle01'
                        ? IconButton(
                            tooltip: 'Ver relatório geral das tarefas recebidas.',
                            icon: Icon(Icons.link),
                            onPressed: () async {
                              bloc.eventSink(GerarRelatorioPdfMakeEvent(
                                  pdfGerar: false,
                                  pdfGerado: false,
                                  tipo: 'controle01',
                                  collection: 'Usuario',
                                  document: snapshot.data.usuarioID.id));
                              launch(snapshot.data?.relatorioPdfMakeModel?.url);
                            },
                          )
                        : IconButton(
                            tooltip: 'Atualizar PDF geral das tarefas recebidas.',
                            icon: Icon(Icons.picture_as_pdf),
                            onPressed: () async {
                              bloc.eventSink(GerarRelatorioPdfMakeEvent(
                                  pdfGerar: true,
                                  pdfGerado: false,
                                  tipo: 'controle01',
                                  collection: 'Usuario',
                                  document: snapshot.data.usuarioID.id));
                            },
                          ),

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
      builder: (BuildContext context, AsyncSnapshot<ControleTarefaListBlocState> snapshot) {
        if (snapshot.hasError) {
          return Text("ERROR");
        }
        if (!snapshot.hasData) {
          return Text("SEM DADOS");
        }
        if (snapshot.hasData) {
          List<Widget> listaWdg = List<Widget>();
          if (snapshot.data.isDataValidRemetente) {
            for (var controleTarefaID in snapshot.data.controleTarefaListRemetente) {
              listaWdg.add(Column(children: <Widget>[
                ListTile(
                    trailing: Text('${controleTarefaID.acaoCumprida} de ${controleTarefaID.acaoTotal}'),
                    title: Text('${controleTarefaID.nome}\nPara: ${controleTarefaID.destinatario.nome}'),
                    subtitle: Text(
                        'Inicio: ${controleTarefaID.inicio}\nFim: ${controleTarefaID.fim}\nAtualizada: ${controleTarefaID.modificada}\nid:${controleTarefaID.id}')),
                Wrap(alignment: WrapAlignment.start, children: <Widget>[
                  controleTarefaID.acaoLink != null
                      ? IconButton(
                          tooltip: 'Ver ação que gerou esta tarefa',
                          icon: Icon(Icons.settings_backup_restore),
                          onPressed: () async {
                            bloc.eventSink(VerAcaoGerouTarefaEvent(acaoLink: controleTarefaID.acaoLink));
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
                  // IconButton(
                  //   tooltip: 'Relatorio em PDF.',
                  //   icon: Icon(Icons.picture_as_pdf),
                  //   onPressed: () async {
                  //     var pdf =
                  //         await PdfCreateService.pdfwidgetForControleTarefa(
                  //             controleTarefaID);
                  //     PdfSaveService.generatePdfAndOpen(pdf);
                  //   },
                  // ),
                  snapshot.data?.relatorioPdfMakeModel?.pdfGerar != null &&
                          snapshot.data?.relatorioPdfMakeModel?.pdfGerar == false &&
                          snapshot.data?.relatorioPdfMakeModel?.pdfGerado == true &&
                          snapshot.data?.relatorioPdfMakeModel?.tipo == 'controle04' &&
                          snapshot.data?.relatorioPdfMakeModel?.document == controleTarefaID.id
                      ? IconButton(
                          tooltip: 'Ver relatório individual desta tarefa designada.',
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
                      : IconButton(
                          tooltip: 'Atualizar PDF individual desta tarefa designada.',
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
                      showModalBottomSheet(
                          context: context,
                          builder: (BuildContext bc) {
                            return SetorListaModalSelect(bloc, controleTarefaID);
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
                        arguments: ControlePageArguments(tarefa: controleTarefaID.id, acao: null),
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
                    child: Text('Setor: ${snapshot.data.usuarioID.setorCensitarioID.nome}'),
                  ),
                  Wrap(alignment: WrapAlignment.start, children: <Widget>[
                    // IconButton(
                    //   tooltip: 'Relatorio em PDF.',
                    //   icon: Icon(Icons.picture_as_pdf),
                    //   onPressed: () async {
                    //     var pdf = await PdfCreateService.pdfwidgetForControleTarefaDoUsuario(
                    //         usuarioModel: snapshot.data.usuarioID, remetente: true, concluida: false);
                    //     PdfSaveService.generatePdfAndOpen(pdf);
                    //   },
                    // ),
                    snapshot.data?.relatorioPdfMakeModel?.pdfGerar != null &&
                            snapshot.data?.relatorioPdfMakeModel?.pdfGerar == false &&
                            snapshot.data?.relatorioPdfMakeModel?.pdfGerado == true &&
                            snapshot.data?.relatorioPdfMakeModel?.tipo == 'controle03'
                        ? IconButton(
                            tooltip: 'Ver relatório geral das tarefas designadas.',
                            icon: Icon(Icons.link),
                            onPressed: () async {
                              bloc.eventSink(GerarRelatorioPdfMakeEvent(
                                  pdfGerar: false,
                                  pdfGerado: false,
                                  tipo: 'controle03',
                                  collection: 'Usuario',
                                  document: snapshot.data.usuarioID.id));
                              launch(snapshot.data?.relatorioPdfMakeModel?.url);
                            },
                          )
                        : IconButton(
                            tooltip: 'Atualizar PDF geral das tarefas designadas.',
                            icon: Icon(Icons.picture_as_pdf),
                            onPressed: () async {
                              bloc.eventSink(GerarRelatorioPdfMakeEvent(
                                  pdfGerar: true,
                                  pdfGerado: false,
                                  tipo: 'controle03',
                                  collection: 'Usuario',
                                  document: snapshot.data.usuarioID.id));
                            },
                          ),

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
                          arguments: ControlePageArguments(tarefa: null, acao: null),
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
            Tab(text: "Destinatário/Recebida"),
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

/// Selecao de setor para duplicar a tarefa
class SetorListaModalSelect extends StatefulWidget {
  final ControleTarefaListBloc bloc;
  final ControleTarefaModel tarefaID;

  const SetorListaModalSelect(this.bloc, this.tarefaID);

  @override
  _SetorListaModalSelectState createState() => _SetorListaModalSelectState(this.bloc);
}

class _SetorListaModalSelectState extends State<SetorListaModalSelect> {
  final ControleTarefaListBloc bloc;

  _SetorListaModalSelectState(this.bloc);

  Widget _listaSetor() {
    return StreamBuilder<ControleTarefaListBlocState>(
      stream: bloc.stateStream,
      builder: (BuildContext context, AsyncSnapshot<ControleTarefaListBlocState> snapshot) {
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
          bloc.eventSink(DuplicarTarefaEvent(setorID: setor, tarefaID: widget.tarefaID));
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
