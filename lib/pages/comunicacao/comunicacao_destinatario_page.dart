import 'package:flutter/material.dart';
import 'package:pmsbmibile3/bootstrap.dart';
import 'package:pmsbmibile3/pages/comunicacao/comunicacao_destinatario_page_bloc.dart';

class ComunicacaoDestinatariosPage extends StatefulWidget {
  @override
  _ComunicacaoDestinatariosPageState createState() =>
      _ComunicacaoDestinatariosPageState();
}

class _ComunicacaoDestinatariosPageState
    extends State<ComunicacaoDestinatariosPage> {
  ComunicacaoDestinatarioPageBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = ComunicacaoDestinatarioPageBloc(Bootstrap.instance.firestore);
  }

  @override
  void dispose() {
    super.dispose();
    bloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return DefaultTabController(
      length: 3,
      child: Scaffold(
          appBar: new AppBar(
            // automaticallyImplyLeading: false,
            title: new Text('Selecionar destinatários'),
            bottom: TabBar(
              tabs: <Widget>[
                Tab(
                  text: 'Cargo',
                ),
                Tab(
                  text: 'Eixo',
                ),
                Tab(
                  text: 'Usuário',
                ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.pop(context, bloc.destinatarioList());
            },
            child: Icon(Icons.check),
          ),
          body: TabBarView(
            children: <Widget>[_cargoBody(), _eixoBody(), _usuarioBody()],
          )),
    );
  }

  _cargoBody() {
    return StreamBuilder<ComunicacaoDestinatarioPageState>(
        stream: bloc.stateStream,
        builder: (BuildContext context,
            AsyncSnapshot<ComunicacaoDestinatarioPageState> snapshot) {
          if (snapshot.hasError) {
            return Text('Erro.');
          }
          if (!snapshot.hasData) {
            return Text('Sem dados.');
          }
          if (snapshot.hasData) {
            //  var cargoList = List<Cargo>();
            var cargoList = snapshot.data.cargoList;
            return ListView(
              children: <Widget>[
                ...cargoList.map((variavel) {
                  return Card(
                      color: variavel.checked ? Colors.deepOrange : null,
                      child: InkWell(
                          onTap: () {
                            bloc.eventSink(SelectCargoIDEvent(variavel.id));
                          },
                          child: ListTile(
                            title: Text(
                              "${variavel.nome}",
                              style: TextStyle(fontSize: 18),
                            ),
                          )));
                }).toList()
              ],
            );
          }
          return Text('Algum problema...');
        });
  }

  _eixoBody() {
    return StreamBuilder<ComunicacaoDestinatarioPageState>(
        stream: bloc.stateStream,
        builder: (BuildContext context,
            AsyncSnapshot<ComunicacaoDestinatarioPageState> snapshot) {
          if (snapshot.hasError) {
            return Text('Erro.');
          }
          if (!snapshot.hasData) {
            return Text('Sem dados.');
          }
          //  var cargoList = List<Cargo>();
          var eixoList = snapshot.data.eixoList;
          return ListView(
            children: <Widget>[
              ...eixoList.map((variavel) {
                return Card(
                    color: variavel.checked ? Colors.deepOrange : null,
                    child: InkWell(
                        onTap: () {
                          bloc.eventSink(SelectEixoIDEvent(variavel.id));
                        },
                        child: ListTile(
                          title: Text(
                            // "# ${variavel.id}-${variavel.nome}-${variavel.checked}",
                            "${variavel.nome}",
                            style: TextStyle(fontSize: 18),
                          ),

                          // subtitle: Text(
                          //   "## ${variavel?.nome}",
                          //   "CLIQUE AQUI PARA VER O ARQUIVO",
                          //   style:
                          //       TextStyle(fontSize: 16, color: Colors.blue),
                          // ),
                        )));
              }).toList()
            ],
          );
        });
  }

  _usuarioBody() {
    return StreamBuilder<ComunicacaoDestinatarioPageState>(
        stream: bloc.stateStream,
        builder: (BuildContext context,
            AsyncSnapshot<ComunicacaoDestinatarioPageState> snapshot) {
          if (snapshot.hasError) {
            return Text('Erro.');
          }
          if (!snapshot.hasData) {
            return Text('Sem dados.');
          }
            var usuarioList = snapshot.data.usuarioList;
            return ListView(
              children: <Widget>[
                ...usuarioList.map((variavel) {
                  return Card(
                      color: variavel.checked ? Colors.deepOrange : null,
                      child: InkWell(
                          onTap: () {
                            bloc.eventSink(SelectUsuarioIDEvent(variavel.id));
                          },
                          child: ListTile(
                            title: Text(
                              "${variavel.nome}",
                              style: TextStyle(fontSize: 18),
                            ),
                            subtitle: Text(
                              "Eixo: ${variavel.eixo.nome}. Cargo: ${variavel.cargo.nome}",
                            ),
                            // subtitle: Text(
                            //   "## ${variavel?.nome}",
                            //   "CLIQUE AQUI PARA VER O ARQUIVO",
                            //   style:
                            //       TextStyle(fontSize: 16, color: Colors.blue),
                            // ),
                          )));
                }).toList()
              ],
            );
          
        });
  }
}
