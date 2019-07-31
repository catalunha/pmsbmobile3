import 'package:pmsbmibile3/bootstrap.dart';
import 'package:pmsbmibile3/components/eixo.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:pmsbmibile3/models/pergunta_model.dart';
import 'package:pmsbmibile3/pages/page_arguments.dart';
import 'package:pmsbmibile3/pages/pergunta/editar_apagar_pergunta_page_bloc.dart';
import 'package:pmsbmibile3/pages/pergunta/pergunta_escolha_list_bloc.dart';

class PerguntaEscolhaListPage extends StatelessWidget {
  final PerguntaEscolhaListPageBloc bloc;
  String perguntaID;

  PerguntaEscolhaListPage(this.perguntaID)
      : bloc = PerguntaEscolhaListPageBloc(Bootstrap.instance.firestore) {
    bloc.eventSink(UpdatePerguntaIDEvent(perguntaID));
    // print('>>> PerguntaEscolhaListPage.perguntaID <<< ${perguntaID}');
  }
  void dispose() {
    bloc.dispose();
  }

  _textoTopo(text) {
    return Padding(
      padding: EdgeInsets.only(top: 10),
      child: Text(
        text,
        style: TextStyle(fontSize: 16, color: Colors.blue),
      ),
    );
  }

  _listarPerguntaEscolha() {
    return StreamBuilder<PerguntaEscolhaListPageState>(
      stream: bloc.stateStream,
      builder: (BuildContext context,
          AsyncSnapshot<PerguntaEscolhaListPageState> snapshot) {
        if (snapshot.hasError) {
          return Text("ERROR");
        }
        if (!snapshot.hasData) {
          return Text("SEM DADOS");
        }
        List<Widget> list = List<Widget>();
        if (snapshot.data.isDataValid) {
          int lengthEscolha = snapshot.data?.escolhaMap?.length;
          int ordemLocal = 1;
          snapshot.data.escolhaMap.forEach((k, v) {
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
                        title: Text(v.texto),
                      )),
                  Expanded(
                    flex: 2,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        IconButton(
                            icon: Icon(Icons.arrow_downward),
                            onPressed: (ordemLocal) < lengthEscolha
                                ? () {
                                    // print(
                                    //     'em  down => ${i} ${ordemLocal} (${v.ordem})');
                                    // Mover pra baixo na ordem
                                    //TODO: refatorar este codigo com o i fica mais fácil
                                    bloc.eventSink(OrdenarEscolhaEvent(
                                        k, false));
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
                                    bloc.eventSink(OrdenarEscolhaEvent(
                                        k, true));
                                  }
                                : null),
                        IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () {
                              // Editar uma nova escolha
                              Navigator.pushNamed(
                                  context, "/pergunta/escolha_crud",
                                  arguments: PerguntaIDEscolhaIDPageArguments(
                                      perguntaID, k));
                            }),
                      ],
                    ),
                  ),
                ],
              ),
            ));
            ordemLocal++;
          });
          return ListView(
            children: list,
          );
        } else {
          return Text('Dados inválidos...');
        }
      },
    );
  }

  _body() {
    return Container(
        alignment: Alignment(0.0, 0.0),
        child: Column(children: <Widget>[
          Container(
            padding: EdgeInsets.only(top: 10),
            child: EixoAtualUsuario(),
          ),
          // StreamBuilder<EditarApagarPerguntaBlocState>(
          //   stream: bloc.state,
          //   builder: (context, snapshot) {
          //     if (snapshot.hasError) {
          //       return Text("ERROR");
          //     }
          //     if (!snapshot.hasData) {
          //       return Text("SEM DADOS");
          //     }
          //     return Column(
          //       children: <Widget>[
          //         _textoTopo(
          //             "Questionario: ${snapshot.data.questionario.nome}"),
          //         _textoTopo("Pergunta: ${snapshot.data.titulo}"),
          //       ],
          //     );
          //   },
          // ),
          Padding(padding: EdgeInsets.all(10)),
          Expanded(child: _listarPerguntaEscolha())
        ]));
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          automaticallyImplyLeading: true,
          title: Text('Gerenciar escolha'),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Editar ou Adicionar uma nova escolha
            Navigator.pushNamed(context, "/pergunta/escolha_crud",
                arguments: PerguntaIDEscolhaIDPageArguments(perguntaID, null));
          },
          child: Icon(Icons.add),
          backgroundColor: Colors.blue,
        ),
        body: _body());
  }
}
