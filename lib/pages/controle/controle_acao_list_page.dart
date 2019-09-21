import 'package:flutter/material.dart';
import 'package:pmsbmibile3/bootstrap.dart';
import 'package:pmsbmibile3/pages/controle/controle_acao_crud_page.dart';
import 'package:pmsbmibile3/pages/controle/controle_acao_list_bloc.dart';
import 'package:pmsbmibile3/pages/page_arguments.dart';
import 'package:url_launcher/url_launcher.dart';

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
          List<Widget> list = List<Widget>();
          if (snapshot.data.isDataValid) {
            int lengthAcao = snapshot.data.controleAcaoList.length;
            int ordemLocal = 1;
            for (var acao in snapshot.data.controleAcaoList) {
              // }
              // snapshot.data.escolhaMap.forEach((k, v) {
              list.add(
                Column(
                  children: <Widget>[
                    ListTile(
                      // leading: Text('${ordemLocal} (${v.ordem})'),
                      selected: acao.concluida,
                      trailing: acao.concluida
                          ? Text('*  ${ordemLocal}')
                          : Text('${ordemLocal}'),
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
                            tooltip: 'Descer ação',
                            icon: Icon(Icons.arrow_downward),
                            onPressed: (ordemLocal) < lengthAcao
                                ? () {
                                    // print(
                                    //     'em  down => ${i} ${ordemLocal} (${v.ordem})');
                                    // Mover pra baixo na ordem
                                    //TODO: refatorar este codigo com o i fica mais fácil
                                    bloc.eventSink(
                                        OrdenarAcaoEvent(acao, false));
                                  }
                                : null),
                        IconButton(
                            icon: Icon(Icons.arrow_upward),
                            onPressed: ordemLocal > 1
                                ? () {
                                    // print(
                                    //     'em up => ${i} ${ordemLocal} (${v.ordem})');

                                    // Mover pra cima na ordem
                                    //TODO: refatorar este codigo com o i fica mais fácil
                                    bloc.eventSink(
                                        OrdenarAcaoEvent(acao, true));
                                  }
                                : null),
                        IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () {
                              // Editar uma nova escolha
                              Navigator.pushNamed(
                                  context, "/controle/acao_crud",
                                  arguments: ControlePageArguments(
                                      tarefa: null, acao: acao.id));
                            }),
                      ],
                    ),
                  ],
                ),
              );
              ordemLocal++;
            }
            return ListView(
              children: list,
            );
          } else {
            return Text('Dados inválidos...');
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          // backgroundColor: Colors.red,
          automaticallyImplyLeading: true,
          title: Text('Gerenciar ações'),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Editar ou Adicionar uma nova escolha
            Navigator.pushNamed(context, '/controle/acao_crud',
                arguments: ControlePageArguments(
                    tarefa: widget.controleTarefaID, acao: null));
          },
          child: Icon(Icons.add),
        ),
        body: _body());
  }
}
