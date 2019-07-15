import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:file_picker/file_picker.dart';

class PerguntaWigdetImagemArquivo extends StatefulWidget {
  @override
  _PerguntaWigdetImagemArquivoState createState() => _PerguntaWigdetImagemArquivoState();
}

class _PerguntaWigdetImagemArquivoState extends State<PerguntaWigdetImagemArquivo> {
  final key = new GlobalKey<ScaffoldState>();
  String _fileName;

  String _path;
  // map de lista de arquivos contendo {chave<nome do arquivo>:path<endereco do arquivo>}
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

  void _openUserFilesFirebaseList() async {
    if (_pickingType != FileType.ANY || _hasValidMime) {
      try {
        _paths.addAll(await FilePicker.getMultiFilePath(
            type: _pickingType, fileExtension: _extension));

        /**
         if (_multiPick) {
          //_path = null;

          _paths = await FilePicker.getMultiFilePath(
              type: _pickingType, fileExtension: _extension);
        } else {
          //_paths = null;

          _paths.addAll(await FilePicker.getMultiFilePath(
              type: _pickingType, fileExtension: _extension));
        }

         */

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

  _itemSelecionado(index) {
    final bool isMultiPath = _paths != null && _paths.isNotEmpty;
    final String name =
        (isMultiPath ? _paths.keys.toList()[index] : _fileName ?? '...');
    final path = isMultiPath ? _paths.values.toList()[index].toString() : _path;
    print('--- ---- --- $_paths');
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: AssetImage(path),
      ),
      trailing: IconButton(
        icon: Icon(Icons.delete),
        onPressed: () {
          //apagar esta imagem
          setState(() {
            _paths.remove(name);
          });
        },
      ),
      title: Text(name),
      subtitle: Text("Tipo: Imagem"),
    );
  }

  Widget makeRadioTiles() {
    Set<Widget> list = new Set<Widget>();

    for (int i = 0; i < _paths.length; i++) {
      list.add(_itemSelecionado(i));
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
          title: Text("Selecione as imagens"),
          trailing: IconButton(
            icon: Icon(Icons.camera_alt),
            onPressed: () {
              _openUserFilesFirebaseList();
            },
          )),
      _path != null || _paths != null ? makeRadioTiles() : Container()
    ]));
  }
}
