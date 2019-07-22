import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:pmsbmibile3/bootstrap.dart';
import 'package:pmsbmibile3/components/square_image.dart';
import 'package:pmsbmibile3/pages/produto/produto_imagem_crud_page_bloc.dart';

class ProdutoImagemCRUDPage extends StatefulWidget {
  final String produtoID;
  final String arquivoID;

  ProdutoImagemCRUDPage(this.produtoID, this.arquivoID) {
    // bloc.eventSink(UpdateProdutoIDArquivoIDEvent(produtoID, arquivoID));
  }

  @override
  State<StatefulWidget> createState() {
    return _ProdutoImagemCRUDPageState();
  }
}

class _ProdutoImagemCRUDPageState extends State<ProdutoImagemCRUDPage> {
  final bloc = ProdutoImagemCRUDPageBloc(Bootstrap.instance.firestore);
  final _controller = TextEditingController();
  String arquivoRascunho;
  String arquivoEditado;

  @override
  void initState() {
    super.initState();
    bloc.eventSink(
        UpdateProdutoIDArquivoIDEvent(widget.produtoID, widget.arquivoID));
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
        if (!snapshot.hasData) {
          return Container(
            child: Center(child: CircularProgressIndicator()),
          );
        }
        arquivoRascunho = snapshot.data?.arquivoRascunho ?? 'Sem arquivo';
        arquivoEditado = snapshot.data?.arquivoEditado ?? 'Sem arquivo';

        return ListView(
          padding: EdgeInsets.all(5),
          children: <Widget>[
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
                      bloc.eventSink(
                          DeleteArquivoEvent('arquivoRascunho'));
                    }),
                title: Text('Selecione o arquivo rascunho'),
                trailing: IconButton(
                    icon: Icon(Icons.file_download),
                    onPressed: () async {
                      await _selecionarNovosArquivos().then((arq) {
                        arquivoRascunho = arq;
                      });
                      print('>> arquivoPath 1 >> ${arquivoRascunho}');
                      setState(() {
                        // ALTERA SE VAI OU NAO SER INCORPORADO O EDITADO
                        arquivoRascunho == null
                            ? 'Nenhum arquivo selecionado'
                            : arquivoRascunho;
                      });
                      bloc.eventSink(
                          UpdateArquivoRascunhoEvent(arquivoRascunho));
                    }),
              ),
            ),
            Text(arquivoRascunho),
            Card(
              child: ListTile(
                leading: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () async {
                      bloc.eventSink(
                          DeleteArquivoEvent('arquivoEditado'));
                    }),
                title: Text('Selecione o arquivo editado'),
                trailing: IconButton(
                    icon: Icon(Icons.file_download),
                    onPressed: () async {
                      await _selecionarNovosArquivos().then((arq) {
                        arquivoEditado = arq;
                      });
                      print('>> arquivoEditado 1 >> ${arquivoEditado}');
                      setState(() {
                        // ALTERA SE VAI OU NAO SER INCORPORADO O EDITADO
                        arquivoEditado == null
                            ? 'Nenhum arquivo selecionado'
                            : arquivoEditado;
                      });
                      bloc.eventSink(UpdateArquivoEditadoEvent(arquivoEditado));
                    }),
              ),
            ),
            Text(arquivoEditado),
            _botaoDeletarDocumento(),
            // CircularProgressIndicator(),

          ],
        );
      },
    );
    // return ;
  }

  Future<String> _selecionarNovosArquivos() async {
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
