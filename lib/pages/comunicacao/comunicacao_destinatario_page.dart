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
  final bloc = ComunicacaoDestinatarioPageBloc(Bootstrap.instance.firestore);

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
                  text: 'Usuario',
                ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.pop(context);
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
        stream: bloc.comunicacaoDestinatarioPageStateStream,
        builder: (context, snapshot) {
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
                      child: InkWell(
                          onTap: () {
                            bloc.comunicacaoDestinatarioPageEventSink(UpDateCargoIDEvent(variavel.id));
                          },
                          child: ListTile(
                            title: Text(
                              "# ${variavel.id}-${variavel.nome}-${variavel.checked}",
                              style: TextStyle(fontSize: 14),
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
          }
        });
  }

  _eixoBody() {
        return StreamBuilder<ComunicacaoDestinatarioPageState>(
        stream: bloc.comunicacaoDestinatarioPageStateStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Erro.');
          }
          if (!snapshot.hasData) {
            return Text('Sem dados.');
          }
          if (snapshot.hasData) {
            //  var cargoList = List<Cargo>();
            var eixoList = snapshot.data.eixoList;
            return ListView(
              children: <Widget>[
                ...eixoList.map((variavel) {
                  return Card(
                      child: InkWell(
                          onTap: () {
                          },
                          child: ListTile(
                            title: Text(
                              "# ${variavel.id}-${variavel.nome}-${variavel.checked}",
                              style: TextStyle(fontSize: 14),
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
          }
        });
  }

  _usuarioBody() {
        return StreamBuilder<ComunicacaoDestinatarioPageState>(
        stream: bloc.comunicacaoDestinatarioPageStateStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Erro.');
          }
          if (!snapshot.hasData) {
            return Text('Sem dados.');
          }
          if (snapshot.hasData) {
            //  var cargoList = List<Cargo>();
            var usuarioList = snapshot.data.usuarioList;
            return ListView(
              children: <Widget>[
                ...usuarioList.map((variavel) {
                  return Card(
                      child: InkWell(
                          onTap: () {
                          },
                          child: ListTile(
                            title: Text(
                              "# ${variavel.id}-${variavel.nome}-${variavel.eixo}-${variavel.cargo}-${variavel.checked}",
                              style: TextStyle(fontSize: 14),
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
          }
        });
  }
}
