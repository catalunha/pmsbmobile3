import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:file_picker/file_picker.dart';

class FileExplorer extends StatefulWidget {
  @override
  _FileExplorerState createState() => new _FileExplorerState();
}

class _FileExplorerState extends State<FileExplorer> {
  final key = new GlobalKey<ScaffoldState>();
  String _fileName;
  String _path;
  Map<String, String> _paths;
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

  void _openFileExplorer() async {
    if (_pickingType != FileType.CUSTOM || _hasValidMime) {
      try {
        if (_multiPick) {
          _path = null;
          _paths = await FilePicker.getMultiFilePath(
              type: _pickingType, fileExtension: _extension);
        } else {
          _paths = null;
          _path = await FilePicker.getFilePath(
              type: _pickingType, fileExtension: _extension);
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

  _itemSelecionadoCard(String name, String path) {
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            //leading: Icon(Icons.album),
            title: Text(name),
            subtitle: Text(path),
          ),
          ButtonTheme.bar(
            // make buttons use the appropriate styles for cards
            child: ButtonBar(
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.content_copy),
                  onPressed: () {
                    Clipboard.setData(
                        new ClipboardData(text: "![Não encontrado]($path)"));
                    key.currentState.showSnackBar(new SnackBar(
                      content: new Text("Copiado para o Clipboard"),
                    ));
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    /* Funcao de deletar imagem da area de tranferencia */
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _listaSelecionados() {
    return Builder(
      builder: (BuildContext context) => new Container(
            padding: const EdgeInsets.only(bottom: 30.0),
            height: MediaQuery.of(context).size.height * 0.90,
            child: _path != null || _paths != null
                ? new ListView.separated(
                    itemCount:
                        _paths != null && _paths.isNotEmpty ? _paths.length : 1,
                    itemBuilder: (BuildContext context, int index) {
                      final bool isMultiPath =
                          _paths != null && _paths.isNotEmpty;
                      final String name = 'Arquivo $index: ' +
                          (isMultiPath
                              ? _paths.keys.toList()[index]
                              : _fileName ?? '...');
                      final path = isMultiPath
                          ? _paths.values.toList()[index].toString()
                          : _path;

                      return _itemSelecionadoCard(name, path);
                    },
                    separatorBuilder: (BuildContext context, int index) =>
                        new Divider(),
                  )
                : new Container(),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.attach_file),
              onPressed: () => _openFileExplorer(),
            ),
          ],
        ),
        Container(
            decoration: BoxDecoration(
              border: Border.all(color: Color(0xffDCDCDC), width: 1.0),
              borderRadius: BorderRadius.all(
                  Radius.circular(5.0) //         <--- border radius here
                  ),
            ),
            alignment: FractionalOffset.center,
            child: _listaSelecionados())
      ],
    );
  }
}
