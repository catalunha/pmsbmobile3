import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:file_picker/file_picker.dart';

class UserFilesFirebaseList extends StatefulWidget {
  @override
  _UserFilesFirebaseListState createState() =>
      new _UserFilesFirebaseListState();
}

class _UserFilesFirebaseListState extends State<UserFilesFirebaseList> {
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

  void _openUserFilesFirebaseList() async {
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

  _itemSelecionado(String name, String path) {
    return ListTile(
      leading: Checkbox(value:false,onChanged: null,),
      trailing: IconButton(icon: Icon(Icons.delete),onPressed: (){
        //apagar esse arquivo/imagem da lista do firebase
      },),
      title: Text(name),
      subtitle: Text("Tipo: Imagem"),
    );
  }

  _listaSelecionados() {
    return Builder(
      builder: (BuildContext context) => new Container(
            //padding: const EdgeInsets.only(bottom: 30.0),
            //height: MediaQuery.of(context).size.height * 0.90,
            child: _path != null || _paths != null
                ? new ListView.separated(
                    itemCount: _paths != null && _paths.isNotEmpty ? _paths.length : 1,
                    itemBuilder: (BuildContext context, int index) {
                      final bool isMultiPath =
                          _paths != null && _paths.isNotEmpty;
                      final String name =
                          (isMultiPath
                              ? _paths.keys.toList()[index]
                              : _fileName ?? '...');
                      final path = isMultiPath
                          ? _paths.values.toList()[index].toString()
                          : _path;

                      return _itemSelecionado(name, path);
                    },
                    separatorBuilder: (BuildContext context, int index) =>
                        new Divider(),
                  )
                : new Container(),
          ),
    );
  }

  _body() {
    return Column(children: <Widget>[
      IconButton(
        icon: Icon(Icons.attach_file),
        onPressed: () => _openUserFilesFirebaseList(),
      ),
      _listaSelecionados()
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.camera_alt),
              onPressed: () {
                // Apos selecionar imagem da camera já inserir na lista no firebase
              },
            ),
            IconButton(
              icon: Icon(Icons.attach_file),
              onPressed: () {
                _openUserFilesFirebaseList();
                // Apos selecionar arquivo já inserir na lista no firebase
              },
            ),
          ],
          centerTitle: true,
          title: Text("Seus arquivos"),
        ),
        body: _listaSelecionados(),
        floatingActionButton: FloatingActionButton(
            onPressed: (){
              // retornar pras telas anteriores os setotes sensitarios que foram selecionados
              Navigator.of(context).pop();
              },
            child: Icon(Icons.thumb_up),
            backgroundColor: Colors.blue,
          ),);
  }
}
