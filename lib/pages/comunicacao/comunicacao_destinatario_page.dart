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
                            // null;
                          },
                          child: ListTile(
                            title: Text(
                              "# ${variavel?.id}:",
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

  _eixoBody() => Text('222222aaaaa');

  _usuarioBody() => Text('3333333333aaaa');
}
