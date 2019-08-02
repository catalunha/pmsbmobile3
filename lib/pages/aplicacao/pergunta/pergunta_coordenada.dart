import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:file_picker/file_picker.dart';
import 'package:location/location.dart';
import 'package:pmsbmibile3/models/pergunta_model.dart';

class PerguntaWigdetCoordenada extends StatefulWidget {
  @override
  _PerguntaWigdetCoordenadaState createState() =>
      _PerguntaWigdetCoordenadaState();
}

class _PerguntaWigdetCoordenadaState extends State<PerguntaWigdetCoordenada> {
  
  var currentLocation;
  Location location = new Location();
  List<Coordenada> _listaLocalizao = List<Coordenada>();

  final key = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }

  _salvarLocalizacao() async {
    try {
      currentLocation = await location.getLocation();  
      setState(() {
         _listaLocalizao.add(new Coordenada(latitude:currentLocation.latitude, longitude: currentLocation.longitude ));
      });
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        var error = 'Permission denied';
        print("ERROR: ${e.code} ");
      }
      currentLocation = null;
    }
  }

  _listTileCoordenada(Coordenada coordenada, int index) {

    return ListTile(
      leading: Icon(Icons.location_on),
      trailing: IconButton(
        icon: Icon(Icons.delete),
        onPressed: () {
          //apagar esta imagem
          setState(() {
            _listaLocalizao.remove(coordenada);
          });
        },
      ),
      title: Text("Latitude: ${coordenada.latitude}\nLongitude: ${coordenada.longitude} "),
    );
  }

  Widget makeList() {
    Set<Widget> list = new Set<Widget>();

    for (int i = 0; i < _listaLocalizao.length; i++) {
      list.add(_listTileCoordenada(_listaLocalizao[i],i));
    }

    Column column = new Column(
      children: list.toList(),
    );
    return column;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(children: <Widget>[
      ListTile(
          title: Text("Adicionar nova coordenada"),
          trailing: IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              _salvarLocalizacao();
            },
          )),
      _listaLocalizao != null || _listaLocalizao != null ? makeList() : Container()
    ]));
  }
}
