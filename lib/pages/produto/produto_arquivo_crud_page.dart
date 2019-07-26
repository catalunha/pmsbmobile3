import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:pmsbmibile3/bootstrap.dart';
import 'package:pmsbmibile3/pages/produto/produto_arquivo_crud_page_bloc.dart';
import 'package:provider/provider.dart';
// import 'package:pmsbmibile3/pages/produto/produto_arquivo_crud_page_bloc.dart';
// import 'package:pmsbmibile3/pages/produto/produto_imagem_crud_page_bloc.dart';

class ProdutoArquivoCRUDPage extends StatefulWidget {
  final String produtoID;
  final String arquivoID;
  final String tipo;
  // final ProdutoArquivoCRUDPageBloc bloc;
  ProdutoArquivoCRUDPage({this.produtoID, this.arquivoID, this.tipo}) {
    print('instancia de ProdutoArquivoCRUDPage 2');
  }

  // ProdutoArquivoCRUDPage({this.produtoID, this.arquivoID, this.tipo})
  //     : bloc = ProdutoArquivoCRUDPageBloc(Bootstrap.instance.firestore) {
  //   print('instancia de ProdutoArquivoCRUDPage');
  //   bloc.eventSink(
  //       UpdateProdutoIDArquivoIDTipoEvent(produtoID, arquivoID, tipo));
  // }

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
    bloc.eventSink(UpdateProdutoIDArquivoIDTipoEvent(
        widget.produtoID, widget.arquivoID, widget.tipo));
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Provider<ProdutoArquivoCRUDPageBloc>.value(
        value: bloc,
        child: Scaffold(
          appBar: AppBar(
            title: Text("Editar ${widget.tipo}"),
          ),
          body: _bodyDados(context),
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.save),
            onPressed: () {
              bloc.eventSink(SaveEvent());
              Navigator.of(context).pop();
              // Navigator.pushNamed(context, '/produto/arquivo_list',
              //     arguments: ProdutoArguments(
              //                     produtoID: widget.produtoID, tipo: widget.tipo));
            },
          ),
        ));
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

        // if (!snapshot.hasData) {
        //   return Container(
        //     child: Center(child: CircularProgressIndicator()),
        //   );
        // }
        rascunhoUrl = snapshot.data?.rascunhoUrl; // ?? 'Sem arquivo';
        rascunhoLocalPath =
            snapshot.data?.rascunhoLocalPath; //?? 'Sem arquivo';
        editadoUrl = snapshot.data?.editadoUrl; //?? 'Sem arquivo';
        editadoLocalPath = snapshot.data?.editadoLocalPath; // ?? 'Sem arquivo';
// String 
        return ListView(
          padding: EdgeInsets.all(5),
          children: <Widget>[
            Text("Editar titulo da ${widget.tipo}"),
            TituloArquivo(),
            ButtonTheme.bar(
                child: ButtonBar(children: <Widget>[
              Text('Apague ou Selecione o arquivo de rascunho'),
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: () async {
                  bloc.eventSink(DeleteArquivoEvent('arquivoRascunho'));
                },
              ),
              IconButton(
                icon: Icon(Icons.file_download),
                onPressed: () async {
                  await _selecionarNovoArquivo().then((arq) {
                    rascunhoLocalPath = arq;
                  });
                  bloc.eventSink(UpdateArquivoRascunhoEvent(rascunhoLocalPath));
                },
              ),
            ])),
            ButtonTheme.bar(
                child: ButtonBar(children: <Widget>[
              Text('Apague ou Selecione o arquivo editado'),
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: () async {
                  bloc.eventSink(DeleteArquivoEvent('arquivoEditado'));
                },
              ),
              IconButton(
                icon: Icon(Icons.file_download),
                onPressed: () async {
                  await _selecionarNovoArquivo().then((arq) {
                    editadoLocalPath = arq;
                  });
                  bloc.eventSink(UpdateArquivoEditadoEvent(editadoLocalPath));
                },
              ),
            ])),
            _imagemRow(
                rascunhoUrl, rascunhoLocalPath, editadoUrl, editadoLocalPath),
            _botaoDeletarDocumento(),
            //TODO: Comentar esta informação após testes.
            //+++ comentar
            snapshot.data?.produtoID == null
                ? Text("produtoID: null")
                : Text("produtoID: " + (snapshot.data?.produtoID ?? '...')),
            Text('snapshot.data?.produtoID: ' +
                (snapshot.data?.produtoID ?? '...')),
            snapshot.data?.arquivoID == null
                ? Text("arquivoID: null")
                : Text("arquivoID: ${snapshot.data.arquivoID}"),
            snapshot.data?.titulo == null
                ? Text("titulo: null")
                : Text("titulo: ${snapshot.data.titulo}"),
            Text('idUsuario: ' +
                (snapshot.data?.produtoModel?.usuarioID?.id ?? '...')),
            Text('uidParArquivos: ${snapshot.data.arquivoID}'),
            Text('rascunhoUrl: $rascunhoUrl'),
            Text('rascunhoUrl: ' + (rascunhoUrl ?? '...')),
            Text('local: $rascunhoLocalPath'),
            Text('editadoUrl: $editadoUrl'),
            Text('editadoUrl: '+( editadoUrl ??'...')),
            Text('local: $editadoLocalPath'),
            //--- comentar
          ],
        );
      },
    );
    // return ;
  }

  _imagemRow(rascunhoUrl, rascunhoLocalPath, editadoUrl, editadoLocalPath) {
    Widget rascunho;
    if (rascunhoUrl == null && rascunhoLocalPath == null) {
      rascunho = Center(child: Text('Sem imagem.'));
    } else if (rascunhoUrl != null) {
      rascunho = Image.network(rascunhoUrl);
    } else {
      rascunho = Image.asset(rascunhoLocalPath);
    }

    Widget editado;
    if (editadoUrl == null && editadoLocalPath == null) {
      editado = Center(child: Text('Sem imagem.'));
    } else if (editadoUrl != null) {
      editado = Image.network(editadoUrl);
    } else {
      editado = Image.asset(editadoLocalPath);
    }
    return Row(
      children: <Widget>[
        Expanded(
          child: rascunho,
        ),
        Expanded(
          child: editado,
        ),
      ],
    );
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
                              child: Text("CANCELAR EXCLUSÃO"),
                              onPressed: () {
                                // Navigator.pop(context);
                                Navigator.of(context).pop();
                              },
                            ),
                            Container(
                              padding: EdgeInsets.all(20),
                            ),
                            Divider(),
                            SimpleDialogOption(
                              child: Text("sim"),
                              onPressed: () {
                                bloc.eventSink(DeleteEvent());
                                Navigator.of(context).pop();
                                Navigator.of(context).pop();

                                // // Navigator.pushNamed(
                                // //     context, '/produto/arquivo_list',
                                // //     arguments: widget.produtoID);
                                // Navigator.pushNamed(
                                //     context, '/produto/arquivo_list',
                                //     arguments: ProdutoArguments(
                                //         produtoID: widget.produtoID,
                                //         tipo: 'imagem'));
                              },
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

class TituloArquivo extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return TituloArquivoState();
  }
}

class TituloArquivoState extends State<TituloArquivo> {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<ProdutoArquivoCRUDPageBloc>(context);
    return StreamBuilder<ProdutoArquivoCRUDPageState>(
        stream: bloc.stateStream,
        builder: (BuildContext context,
            AsyncSnapshot<ProdutoArquivoCRUDPageState> snapshot) {
          if (_controller.text == null || _controller.text.isEmpty) {
            _controller.text = snapshot.data?.titulo;
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Text("Atualizar nome no produto"),
              TextField(
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
                controller: _controller,
                onChanged: (produtoTexto) {
                  setState(() {
                    bloc.eventSink(UpdateTituloEvent(produtoTexto));
                  });
                },
              ),
            ],
          );
        });
  }
}
