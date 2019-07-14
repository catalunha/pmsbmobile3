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

  Text _cargoBody() => Text('1111111aaaaaa');

  Text _eixoBody() => Text('222222aaaaa');

  Text _usuarioBody() => Text('3333333333aaaa');
}
