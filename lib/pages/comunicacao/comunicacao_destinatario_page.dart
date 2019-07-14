import 'package:flutter/material.dart';

class ComunicacaoDestinatariosPage extends StatefulWidget {
  @override
  _ComunicacaoDestinatariosPageState createState() => _ComunicacaoDestinatariosPageState();
}

class _ComunicacaoDestinatariosPageState extends State<ComunicacaoDestinatariosPage> {


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
            Tab(text: 'Cargo',),
            Tab(text: 'Eixo',),
            Tab(text: 'Usuario',),
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
        children: <Widget>[
          Text('...'),
          Text('...'),
          Text('...')
        ],
      )
    ),
    );
  }
}
