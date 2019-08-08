import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:pmsbmibile3/bootstrap.dart';
import 'package:pmsbmibile3/pages/produto/produto_arquivo_crud_page_bloc.dart';
import 'package:pmsbmibile3/pages/produto/produto_arquivo_list_page.dart';

class ProdutoArquivoCRUDPage extends StatefulWidget {
  final String produtoID;
  final String arquivoID;
  final String tipo;
  ProdutoArquivoCRUDPage({this.produtoID, this.arquivoID, this.tipo}) {
    // print('instancia de ProdutoArquivoCRUDPage 2');
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
    return
        Scaffold(
            appBar: AppBar(
              title: Text("Editar ${widget.tipo}"),
            ),
            body: _bodyDados(context),
            floatingActionButton: FloatingActionButton(
              child: Icon(Icons.save),
              onPressed: () {
                bloc.eventSink(SaveEvent());
                Navigator.of(context).pop();
              },
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
        rascunhoUrl = snapshot.data?.rascunhoUrl; // ?? 'Sem arquivo';
        rascunhoLocalPath =
            snapshot.data?.rascunhoLocalPath; //?? 'Sem arquivo';
        editadoUrl = snapshot.data?.editadoUrl; //?? 'Sem arquivo';
        editadoLocalPath = snapshot.data?.editadoLocalPath; // ?? 'Sem arquivo';
        return ListView(
          padding: EdgeInsets.all(5),
          children: <Widget>[
            Text("Editar titulo da ${widget.tipo}"),
            TituloArquivo(bloc),
            ButtonTheme.bar(
                child: ButtonBar(children: <Widget>[
              Text('Apagar rascunho'),
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: () async {
                  bloc.eventSink(DeleteArquivoEvent('arquivoRascunho'));
                },
              ),
              Text('Trocar rascunho'),
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
              Text('Apagar editado'),
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: () async {
                  bloc.eventSink(DeleteArquivoEvent('arquivoEditado'));
                },
              ),
              Text('Trocar editado'),
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
            ParDeImagens(
                rascunhoUrl: rascunhoUrl,
                rascunhoLocalPath: rascunhoLocalPath,
                editadoUrl: editadoUrl,
                editadoLocalPath: editadoLocalPath),
            Divider(),
            Padding(
              padding: EdgeInsets.all(5.0),
              child: _DeleteDocumentOrField(bloc),
            ),
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
}

class TituloArquivo extends StatefulWidget {
  final ProdutoArquivoCRUDPageBloc bloc;
  TituloArquivo(this.bloc);
  @override
  State<StatefulWidget> createState() {
    return TituloArquivoState(bloc);
  }
}

class TituloArquivoState extends State<TituloArquivo> {
  final _controller = TextEditingController();

  final ProdutoArquivoCRUDPageBloc bloc;
  TituloArquivoState(this.bloc);
  @override
  Widget build(BuildContext context) {
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

class _DeleteDocumentOrField extends StatefulWidget {
  final ProdutoArquivoCRUDPageBloc bloc;
  _DeleteDocumentOrField(this.bloc);
  @override
  _DeleteDocumentOrFieldState createState() {
    return _DeleteDocumentOrFieldState(bloc);
  }
}

class _DeleteDocumentOrFieldState extends State<_DeleteDocumentOrField> {
  final _textFieldController = TextEditingController();
  final ProdutoArquivoCRUDPageBloc bloc;
  _DeleteDocumentOrFieldState(this.bloc);
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ProdutoArquivoCRUDPageState>(
      stream: bloc.stateStream,
      builder: (BuildContext context,
          AsyncSnapshot<ProdutoArquivoCRUDPageState> snapshot) {
        return Row(
          children: <Widget>[
            Divider(),
            Text('Para apagar digite CONCORDO e click:  '),
            Container(
              child: Flexible(
                child: TextField(
                  controller: _textFieldController,
                ),
              ),
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                if (_textFieldController.text == 'CONCORDO') {
                  bloc.eventSink(DeleteEvent());
                  Navigator.of(context).pop();
                }
              },
            )
          ],
        );
      },
    );
  }
}
