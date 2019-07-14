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
  String _fileName;
  String _path;
  Map<String, String> _paths = Map<String, String>();
  String _extension;
  bool _multiPick = true;
  bool _hasValidMime = true;
  FileType _pickingType;
  TextEditingController _controller = new TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(() => _extension = _controller.text);
  }

  _salvarLocalizacao() async {
    try {
      currentLocation = await location.getLocation();  
      setState(() {
         _listaLocalizao.add(new Coordenada(lat:currentLocation.latitude, long: currentLocation.longitude ));
      });
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        var error = 'Permission denied';
      }
      currentLocation = null;
    }
  }

  void _openUserFilesFirebaseList() async {
    if (_pickingType != FileType.IMAGE || _hasValidMime) {
      try {
        if (_multiPick) {
          //_path = null;
          _paths.addAll(await FilePicker.getMultiFilePath(
              type: _pickingType, fileExtension: _extension));
        } else {
          //_paths = null;
          _paths.addAll(await FilePicker.getMultiFilePath(
              type: _pickingType, fileExtension: _extension));
        }
      } on PlatformException catch (e) {
        print("Unsupported operation" + e.toString());
      }
      if (!mounted) return;
      setState(() {
        _fileName = _path != null
            ? _path.split('/').last
            : _paths != null ? _paths.keys.toString() : '...';
      });
    }
  }

  _itemSelecionado(Coordenada coordenada, int index) {

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
      title: Text("Latitude: ${coordenada.lat}\nLongitude: ${coordenada.long} "),
    );
  }

  Widget makeRadioTiles() {
    Set<Widget> list = new Set<Widget>();

    for (int i = 0; i < _listaLocalizao.length; i++) {
      list.add(_itemSelecionado(_listaLocalizao[i],i));
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
      _path != null || _paths != null ? makeRadioTiles() : Container()
    ]));
  }
}
