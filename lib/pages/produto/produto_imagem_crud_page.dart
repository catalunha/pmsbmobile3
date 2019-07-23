import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:pmsbmibile3/bootstrap.dart';
import 'package:pmsbmibile3/components/square_image.dart';
import 'package:pmsbmibile3/pages/produto/produto_imagem_crud_page_bloc.dart';

class ProdutoImagemCRUDPage extends StatefulWidget {
  final String produtoID;
  final String imagemID;

  ProdutoImagemCRUDPage(this.produtoID, this.imagemID) {
    // bloc.eventSink(UpdateProdutoIDArquivoIDEvent(produtoID, imagemID));
  }

  @override
  State<StatefulWidget> createState() {
    return _ProdutoImagemCRUDPageState();
  }
}

class _ProdutoImagemCRUDPageState extends State<ProdutoImagemCRUDPage> {
  final bloc = ProdutoImagemCRUDPageBloc(Bootstrap.instance.firestore);
  final _controller = TextEditingController();
  String rascunhoUrl;
  String rascunhoLocalPath;
  String editadoUrl;
  String editadoLocalPath;

  @override
  void initState() {
    super.initState();
    bloc.eventSink(
        UpdateProdutoIDArquivoIDEvent(widget.produtoID, widget.imagemID));
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Editar Imagem"),
      ),
      body: _bodyDados(context),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.save),
        onPressed: () {
          bloc.eventSink(SaveEvent());
          Navigator.of(context).pop();
        },
      ),
    );
  }

  _bodyDados(BuildContext context) {
    return StreamBuilder<ProdutoImagemCRUDPageState>(
      stream: bloc.stateStream,
      builder: (BuildContext context,
          AsyncSnapshot<ProdutoImagemCRUDPageState> snapshot) {
        if (snapshot.hasError) {
          return Container(
            child: Center(child: Text('Erro.')),
          );
        }
        if (_controller.text == null || _controller.text.isEmpty) {
          _controller.text = snapshot.data?.titulo;
        }
        // if (!snapshot.hasData) {
        //   return Container(
        //     child: Center(child: CircularProgressIndicator()),
        //   );
        // }
        rascunhoUrl = snapshot.data?.rascunhoUrl ?? 'Sem arquivo';
        rascunhoLocalPath = snapshot.data?.rascunhoLocalPath ?? 'Sem arquivo';
        editadoUrl = snapshot.data?.editadoUrl ?? 'Sem arquivo';
        editadoLocalPath = snapshot.data?.editadoLocalPath ?? 'Sem arquivo';

        return ListView(
          padding: EdgeInsets.all(5),
          children: <Widget>[
            snapshot.data?.produtoID == null
                ? Text("produtoID: null")
                : Text("produtoID: ${snapshot.data.produtoID}"),
            snapshot.data?.imagemID == null
                ? Text("imagemID: null")
                : Text("imagemID: ${snapshot.data.imagemID}"),
            Text("Editar titulo da imagem"),
            TextField(
              controller: _controller,
              onChanged: (nomeProduto) {
                bloc.eventSink(UpdateTituloEvent(nomeProduto));
              },
              maxLines: null,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
            Card(
              child: ListTile(
                leading: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () async {
                      bloc.eventSink(DeleteArquivoEvent('arquivoRascunho'));
                    }),
                title: Text('Selecione o arquivo rascunho'),
                trailing: IconButton(
                    icon: Icon(Icons.file_download),
                    onPressed: () async {
                      await _selecionarNovoArquivo().then((arq) {
                        rascunhoLocalPath = arq;
                      });
                      // print('>> arquivoPath 1 >> ${arquivoRascunho}');
                      setState(() {
                        // ALTERA SE VAI OU NAO SER INCORPORADO O EDITADO
                        rascunhoLocalPath == null
                            ? 'Nenhum arquivo selecionado'
                            : rascunhoLocalPath;
                      });
                      bloc.eventSink(
                          UpdateArquivoRascunhoEvent(rascunhoLocalPath));
                    }),
              ),
            ),
            Text('url: $rascunhoUrl'),
            Text('local: $rascunhoLocalPath'),
            Card(
              child: ListTile(
                leading: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () async {
                      bloc.eventSink(DeleteArquivoEvent('arquivoEditado'));
                    }),
                title: Text('Selecione o arquivo editado'),
                trailing: IconButton(
                    icon: Icon(Icons.file_download),
                    onPressed: () async {
                      await _selecionarNovoArquivo().then((arq) {
                        editadoLocalPath = arq;
                      });
                      // print('>> arquivoEditado 1 >> ${arquivoEditado}');
                      setState(() {
                        // ALTERA SE VAI OU NAO SER INCORPORADO O EDITADO
                        editadoLocalPath == null
                            ? 'Nenhum arquivo selecionado'
                            : editadoLocalPath;
                      });
                      bloc.eventSink(
                          UpdateArquivoEditadoEvent(editadoLocalPath));
                    }),
              ),
            ),
            Text('url: $editadoUrl'),
            Text('local: $editadoLocalPath'),
            _botaoDeletarDocumento(),
            // CircularProgressIndicator(),
          ],
        );
      },
    );
    // return ;
  }

  Future<String> _selecionarNovoArquivo() async {
    try {
      var arquivoPath = await FilePicker.getFilePath(type: FileType.ANY);
      if (arquivoPath != null) {
        // print('>> newfilepath 1 >> ${arquivoPath}');
        return arquivoPath;
      }
    } catch (e) {
      print("Unsupported operation" + e.toString());
    }
  }

  _botaoDeletarDocumento() {
    return SafeArea(
        child: Row(
      children: <Widget>[
        Padding(
            padding: EdgeInsets.all(5.0),
            child: RaisedButton(
                // color: Colors.red,
                onPressed: () {
                  showDialog(
                      context: context,
                      barrierDismissible: true,
                      builder: (context) {
                        return SimpleDialog(
                          children: <Widget>[
                            SimpleDialogOption(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text("CANCELAR EXCLUSÃO"),
                            ),
                            Container(
                              padding: EdgeInsets.all(20),
                            ),
                            Divider(),
                            SimpleDialogOption(
                              onPressed: () {
                                bloc.eventSink(DeleteEvent());
                                Navigator.pushNamed(context, '/produto/imagem',
                                    arguments: widget.produtoID);
                              },
                              child: Text("sim"),
                            ),
                          ],
                        );
                      });
                },
                child: Row(
                  children: <Widget>[
                    // Text('Apagar notícia', style: TextStyle(fontSize: 20)),
                    Icon(Icons.delete)
                  ],
                ))),
      ],
    ));
  }
}
