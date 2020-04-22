import 'package:flutter/material.dart';
import 'package:pmsbmibile3/bootstrap.dart';
import 'package:pmsbmibile3/components/default_scaffold.dart';
import 'package:pmsbmibile3/models/controle_acao_model.dart';
import 'package:pmsbmibile3/models/controle_tarefa_model.dart';
import 'package:pmsbmibile3/pages/controle/controle_acao_list_bloc.dart';
import 'package:pmsbmibile3/pages/page_arguments.dart';
import 'package:pmsbmibile3/naosuportato/url_launcher.dart'
    if (dart.library.io) 'package:url_launcher/url_launcher.dart';

class ControleAcaoListPage extends StatefulWidget {
  final String controleTarefaID;

  const ControleAcaoListPage(this.controleTarefaID);

  _ControleAcaoListPageState createState() => _ControleAcaoListPageState();
}

class _ControleAcaoListPageState extends State<ControleAcaoListPage> {
  ControleAcaoListBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = ControleAcaoListBloc(Bootstrap.instance.firestore);
    bloc.eventSink(UpdateTarefaIDEvent(widget.controleTarefaID));
  }

  @override
  void dispose() {
    super.dispose();
    bloc.dispose();
  }

  _body() {
    return StreamBuilder<ControleAcaoListBlocState>(
        stream: bloc.stateStream,
        builder: (BuildContext context,
            AsyncSnapshot<ControleAcaoListBlocState> snapshot) {
          if (snapshot.hasError) {
            return Text("ERROR");
          }
          if (!snapshot.hasData) {
            return Text("SEM DADOS");
          }
          List<Widget> listaWdg = List<Widget>();
          if (snapshot.data.isDataValid) {
            var controleTarefaID = snapshot.data.controleTarefaID;

            int lengthAcao = snapshot.data.controleAcaoList.length;
            int ordemLocal = 1;
            for (var acao in snapshot.data.controleAcaoList) {
              listaWdg.add(
                Column(
                  children: <Widget>[
                    ListTile(
                      selected: acao.concluida,
                      trailing: acao.concluida
                          ? Text('*  $ordemLocal')
                          : Text('$ordemLocal'),
                      title: Text(acao.nome),
                      subtitle: Text(
                          'id: ${acao.id}\nObs: ${acao.observacao}\nAtualizada: ${acao.modificada}'),
                    ),
                    Wrap(
                      alignment: WrapAlignment.center,
                      children: <Widget>[
                        acao.url != null
                            ? IconButton(
                                tooltip: 'Ver arquivo',
                                icon: Icon(Icons.cloud),
                                onPressed: () {
                                  launch(acao.url);
                                },
                              )
                            : Text(''),
                        IconButton(
                            tooltip: 'Descer ordem da ação',
                            icon: Icon(Icons.arrow_downward),
                            onPressed: (ordemLocal) < lengthAcao
                                ? () {
                                    bloc.eventSink(
                                        OrdenarAcaoEvent(acao, false));
                                  }
                                : null),
                        IconButton(
                            tooltip: 'Subir ordem da ação',
                            icon: Icon(Icons.arrow_upward),
                            onPressed: ordemLocal > 1
                                ? () {
                                    bloc.eventSink(
                                        OrdenarAcaoEvent(acao, true));
                                  }
                                : null),
                        IconButton(
                          tooltip: 'Duplicar ação',
                          icon: Icon(Icons.content_copy),
                          onPressed: () {
                            bloc.eventSink(UpdateTarefaListEvent(acao));
                            showModalBottomSheet(
                                context: context,
                                builder: (BuildContext bc) {
                                  return TarefaListModalSelect(bloc, acao);
                                });
                          },
                        ),
                        IconButton(
                            tooltip: 'Editar ação',
                            icon: Icon(Icons.edit),
                            onPressed: () {
                              Navigator.pushNamed(
                                  context, "/controle/acao_crud",
                                  arguments: ControlePageArguments(
                                      tarefa: acao.tarefa.id, acao: acao.id));
                            }),
                      ],
                    ),
                  ],
                ),
              );
              ordemLocal++;
            }

            return Column(children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                      flex: 10,
                      child: Text(
                          'Setor: ${controleTarefaID?.setor?.nome}\nNome: ${controleTarefaID?.nome}\nPara: ${controleTarefaID?.destinatario?.nome}\nInicio: ${controleTarefaID?.inicio}\nFim: ${controleTarefaID?.fim}\nid: ${controleTarefaID?.id}\nConcluida: ${controleTarefaID?.acaoCumprida} de ${controleTarefaID?.acaoTotal}')),
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
            return Text('Dados inválidos...');
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultScaffold(
        backToRootPage: false,
        title: Text('Gerenciar ações'),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, '/controle/acao_crud',
                arguments: ControlePageArguments(
                    tarefa: widget.controleTarefaID, acao: null));
          },
          child: Icon(Icons.add),
        ),
        body: _body());
  }
}

/// Selecao de setor para duplicar a tarefa
class TarefaListModalSelect extends StatefulWidget {
  final ControleAcaoListBloc bloc;
  final ControleAcaoModel acaoID;

  const TarefaListModalSelect(this.bloc, this.acaoID);

  @override
  _TarefaListModalSelectState createState() =>
      _TarefaListModalSelectState(this.bloc);
}

class _TarefaListModalSelectState extends State<TarefaListModalSelect> {
  final ControleAcaoListBloc bloc;

  _TarefaListModalSelectState(this.bloc);

  Widget _listaSetor() {
    return StreamBuilder<ControleAcaoListBlocState>(
      stream: bloc.stateStream,
      builder: (BuildContext context,
          AsyncSnapshot<ControleAcaoListBlocState> snapshot) {
        if (snapshot.hasError)
          return Center(
            child: Text("Erro. Informe ao administrador do aplicativo"),
          );
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.data.controleTarefaListRemetente == null) {
          return Center(
            child: Text("Nenhum setor encontrado."),
          );
        }
        if (snapshot.data.controleTarefaListRemetente.isEmpty) {
          return Center(
            child: Text("Vazio."),
          );
        }

        var lista = List<Widget>();
        for (var tarefa in snapshot.data.controleTarefaListRemetente) {
          lista.add(_cardBuild(context, tarefa));
        }

        return ListView(
          children: lista,
        );
      },
    );
  }

  Widget _cardBuild(BuildContext context, ControleTarefaModel tarefa) {
    return ListTile(
      title: Text('${tarefa.nome}'),
      subtitle: Text('Setor: ${tarefa?.setor?.nome}'),
      trailing: IconButton(
        icon: Icon(Icons.check),
        onPressed: () {
          bloc.eventSink(
              SelectTarefaIDEvent(tarefaID: tarefa, acaoID: widget.acaoID));
          Navigator.pop(context);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Escolha a tarefa"),
      ),
      body: _listaSetor(),
    );
  }
}
