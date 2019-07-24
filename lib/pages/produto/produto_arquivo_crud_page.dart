import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:pmsbmibile3/bootstrap.dart';
import 'package:pmsbmibile3/components/square_image.dart';
import 'package:pmsbmibile3/pages/produto/produto_arguments.dart';
import 'package:pmsbmibile3/pages/produto/produto_arquivo_crud_page_bloc.dart';
// import 'package:pmsbmibile3/pages/produto/produto_imagem_crud_page_bloc.dart';

class ProdutoArquivoCRUDPage extends StatefulWidget {
  final String produtoID;
  final String arquivoID;
  final String tipo;

  ProdutoArquivoCRUDPage({this.produtoID, this.arquivoID, this.tipo}) {
    // bloc.eventSink(UpdateProdutoIDArquivoIDEvent(produtoID, arquivoID));
  }

  @override
  State<StatefulWidget> createState() {
    return _ProdutoArquivoCRUDPageState();
  }
}

class _ProdutoArquivoCRUDPageState extends State<ProdutoArquivoCRUDPage> {
  final bloc = ProdutoArquivoCRUDPageBloc(Bootstrap.instance.firestore);
  final _controller = TextEditingController();
  String rascunhoUrl;
  String rascunhoLocalPath;
  String editadoUrl;
  String editadoLocalPath;

  @override
  void initState() {
    super.initState();
    bloc.eventSink(
        UpdateProdutoIDArquivoIDTipoEvent(widget.produtoID, widget.arquivoID, widget.tipo));
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
          Navigator.pop(context);
          // Navigator.pushNamed(context, '/produto/arquivo_list',
          //     arguments: ProdutoArguments(
          //                     produtoID: widget.produtoID, tipo: widget.tipo));
        },
      ),
    );
  }

  _bodyDados(BuildContext context) {
    return StreamBuilder<ProdutoArquivoCRUDPageState>(
      stream: bloc.stateStream,
      builder: (BuildContext context,
          AsyncSnapshot<ProdutoArquivoCRUDPageState> snapshot) {
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
            snapshot.data?.arquivoID == null
                ? Text("arquivoID: null")
                : Text("arquivoID: ${snapshot.data.arquivoID}"),
            Text("Editar titulo da ${widget.tipo}"),
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
            // _cardImagem(rascunhoLocalPath),
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

  _cardImagem(String arquivoPath) {
    return Card(
        child: Container(
            constraints: new BoxConstraints.expand(
              height: 200.0,
            ),
            padding: new EdgeInsets.only(left: 16.0, bottom: 8.0, right: 16.0),
            decoration: new BoxDecoration(
              image: new DecorationImage(
                image: new AssetImage(arquivoPath),
                fit: BoxFit.cover,
              ),
            ),
            child: new Stack(
              children: <Widget>[
                new Positioned(
                  left: 0.0,
                  bottom: 0.0,
                  child: new Text(arquivoPath,
                      style: new TextStyle(
                        color: Colors.yellow,
                        fontWeight: FontWeight.bold,
                        fontSize: 12.0,
                      )),
                ),
                new Positioned(
                    right: 0.0,
                    bottom: 0.0,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(40.0),
                      child: Container(
                        color: Colors.white,
                        child: new IconButton(
                          icon: new Icon(
                            Icons.delete,
                            color: Colors.black,
                          ),
                          onPressed: () {
                            //apagar esta imagem
                            setState(() {
                              // arquivos.removerArquivoLista(arquivo);
                            });
                          },
                        ),
                      ),
                    )),
              ],
            )));
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
                                Navigator.pushNamed(context, '/produto/arquivo_list',
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
