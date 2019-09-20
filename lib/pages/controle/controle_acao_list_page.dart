import 'package:flutter/material.dart';
import 'package:pmsbmibile3/bootstrap.dart';
import 'package:pmsbmibile3/pages/controle/controle_acao_list_bloc.dart';

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
            final i = ordemLocal;
            list.add(Card(
              elevation: 10,
              child: Row(
                children: <Widget>[
                  Expanded(
                      flex: 3,
                      child: ListTile(
                        // leading: Text('${ordemLocal} (${v.ordem})'),
                        leading: Text('${ordemLocal}'),
                        title: Text(acao.nome),
                      )),
                  Expanded(
                    flex: 2,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        IconButton(
                            icon: Icon(Icons.arrow_downward),
                            onPressed: (ordemLocal) < lengthAcao
                                ? () {
                                    // print(
                                    //     'em  down => ${i} ${ordemLocal} (${v.ordem})');
                                    // Mover pra baixo na ordem
                                    //TODO: refatorar este codigo com o i fica mais fácil
                                    bloc.eventSink(OrdenarAcaoEvent(
                                        ordemLocal, false));
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
                                    bloc.eventSink(OrdenarAcaoEvent(
                                        ordemLocal, true));
                                  }
                                : null),
                        // IconButton(
                        //     icon: Icon(Icons.edit),
                        //     onPressed: () {
                        //       // Editar uma nova escolha
                        //       Navigator.pushNamed(
                        //           context, "/pergunta/escolha_crud",
                        //           arguments: PerguntaIDEscolhaIDPageArguments(
                        //               perguntaID, k));
                        //     }),
                      ],
                    ),
                  ),
                ],
              ),
            ));
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
          },
          child: Icon(Icons.add),
        ),
        body: _body());
  }
}