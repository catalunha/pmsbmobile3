import 'package:pmsbmibile3/components/default_scaffold.dart';
import 'package:pmsbmibile3/naosuportato/naosuportado.dart'
    show FilePicker, FileType;
import 'package:flutter/material.dart';
import 'package:pmsbmibile3/bootstrap.dart';
import 'package:pmsbmibile3/pages/produto/produto_crud_page_bloc.dart';
import 'package:pmsbmibile3/services/recursos.dart';
import 'package:pmsbmibile3/state/auth_bloc.dart';
import 'package:pmsbmibile3/style/pmsb_colors.dart';
import 'package:pmsbmibile3/style/pmsb_styles.dart';

class ProdutoCRUDPage extends StatefulWidget {
  final String produtoID;
  final AuthBloc authBloc;

  ProdutoCRUDPage(this.produtoID, this.authBloc);

  @override
  State<StatefulWidget> createState() {
    return _ProdutoCRUDPageState(authBloc);
  }
}

class _ProdutoCRUDPageState extends State<ProdutoCRUDPage> {
  final ProdutoCRUDPageBloc bloc;

  _ProdutoCRUDPageState(AuthBloc authBloc)
      : bloc = ProdutoCRUDPageBloc(Bootstrap.instance.firestore, authBloc);

  @override
  void initState() {
    super.initState();
    bloc.eventSink(UpdateUsuarioIDEvent());
    bloc.eventSink(UpdateProdutoIDEvent(widget.produtoID));
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultScaffold(
      backToRootPage: false,
      title: Text(
          (widget.produtoID != null ? "Editar" : "Adicionar") + " Produto"),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.check,
          color: Colors.white,
        ),
        backgroundColor: PmsbColors.cor_destaque,
        onPressed: () {
          bloc.eventSink(SaveProdutoIDEvent());
          Navigator.pop(context);
        },
      ),
      body: ListView(
        children: <Widget>[
          Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(
                "Título:",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              )),
          Padding(
            padding: EdgeInsets.all(5.0),
            child: ProdutoTitulo(bloc),
          ),
          if (Recursos.instance.disponivel("file_picking"))
            Padding(
              padding: EdgeInsets.all(5.0),
              child: ArquivoPDF(bloc),
            ),
          Divider(),
          widget.produtoID != null ? ListTile(
            title: Text("Apagar"),
            trailing: IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  _apagarAplicacao(context, bloc);
                }),
          ): Container(),
        ],
      ),
    );
  }

  void _apagarAplicacao(context, ProdutoCRUDPageBloc bloc) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext bc) {
        return SingleChildScrollView(
          child: Container(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(bc).viewInsets.bottom,
              ),
              child: Container(
                  height: 250,
                  color: Colors.black38,
                  child: _DeleteDocumentOrField(bloc))),
        );
      },
    );
  }
}

class ProdutoTitulo extends StatefulWidget {
  final ProdutoCRUDPageBloc bloc;
  ProdutoTitulo(this.bloc);
  @override
  ProdutoTituloState createState() {
    return ProdutoTituloState(bloc);
  }
}

class ProdutoTituloState extends State<ProdutoTitulo> {
  final _textFieldController = TextEditingController();
  final ProdutoCRUDPageBloc bloc;
  ProdutoTituloState(this.bloc);
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ProdutoCRUDPageState>(
      stream: bloc.stateStream,
      builder:
          (BuildContext context, AsyncSnapshot<ProdutoCRUDPageState> snapshot) {
        if (_textFieldController.text.isEmpty) {
          _textFieldController.text = snapshot.data?.produtoModelIDTitulo;
        }
        return TextField(
          keyboardType: TextInputType.multiline,
          maxLines: null,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
          ),
          controller: _textFieldController,
          onChanged: (text) {
            bloc.eventSink(UpdateProdutoIDNomeEvent(text));
          },
        );
      },
    );
  }
}

class _DeleteDocumentOrField extends StatefulWidget {
  final ProdutoCRUDPageBloc bloc;
  _DeleteDocumentOrField(this.bloc);
  @override
  _DeleteDocumentOrFieldState createState() {
    return _DeleteDocumentOrFieldState(bloc);
  }
}

class _DeleteDocumentOrFieldState extends State<_DeleteDocumentOrField> {
  final _textFieldController = TextEditingController();
  final ProdutoCRUDPageBloc bloc;
  _DeleteDocumentOrFieldState(this.bloc);
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ProdutoCRUDPageState>(
      stream: bloc.stateStream,
      builder:
          (BuildContext context, AsyncSnapshot<ProdutoCRUDPageState> snapshot) {
        return Container(
          height: 250,
          color: PmsbColors.fundo,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                SizedBox(height: 20),
                Text(
                  'Para apagar, digite CONCORDO na caixa de texto abaixo e confirme:  ',
                  style: PmsbStyles.textoPrimario,
                ),
                Container(
                  child: Flexible(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Digite aqui",
                        hintStyle: TextStyle(
                            color: Colors.white38, fontStyle: FontStyle.italic),
                      ),
                      controller: _textFieldController,
                    ),
                  ),
                ),
                SizedBox(height: 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    // Botao de cancelar delete
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        height: 50.0,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color(0xffEB3349),
                              Color(0xffF45C43),
                              Color(0xffEB3349)
                            ],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        child: Container(
                          constraints:
                              BoxConstraints(maxWidth: 150.0, minHeight: 50.0),
                          alignment: Alignment.center,
                          child: Text(
                            "Cancelar",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),

                    // Botao de confirmar delete
                    GestureDetector(
                      onTap: () {
                        if (_textFieldController.text == 'CONCORDO') {
                           bloc.eventSink(DeleteProdutoIDEvent());
                          _alerta(
                            "O produto foi removido.",
                            () {
                              var count = 0;
                              Navigator.popUntil(context, (route) {
                                return count++ == 3;
                              });
                            },
                          );
                        } else {
                          _alerta(
                            "Verifique se a caixa de texto abaixo foi preenchida corretamente.",
                            () {
                              Navigator.pop(context);
                            },
                          );
                        }
                      },
                      child: Container(
                        height: 50.0,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color(0xff1D976C),
                              Color(0xff1D976C),
                              Color(0xff93F9B9)
                            ],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        child: Container(
                          constraints:
                              BoxConstraints(maxWidth: 150.0, minHeight: 50.0),
                          alignment: Alignment.center,
                          child: Text(
                            "Confirmar",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

   Future<void> _alerta(String msgAlerta, Function acao) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: PmsbColors.card,
          title: Text(msgAlerta),
          actions: <Widget>[
            FlatButton(child: Text('Ok'), onPressed: acao),
          ],
        );
      },
    );
  }
}

class ArquivoPDF extends StatelessWidget {
  final ProdutoCRUDPageBloc bloc;
  String pdfUrl;
  String pdfLocalPath;

  ArquivoPDF(this.bloc);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ProdutoCRUDPageState>(
      stream: bloc.stateStream,
      builder:
          (BuildContext context, AsyncSnapshot<ProdutoCRUDPageState> snapshot) {
        if (snapshot.hasError) {
          return Container(
            child: Center(child: Text('Erro.')),
          );
        }
        pdfLocalPath = snapshot.data?.pdfLocalPath;
        pdfUrl = snapshot.data?.pdfUrl;

        return Column(
          children: <Widget>[
            Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: <Widget>[
                  Text(
                    'Atualizar PDF do produto:',
                    style: PmsbStyles.textoPrimario,
                  ),
                  IconButton(
                    icon: Icon(Icons.delete_forever),
                    onPressed: () {
                      bloc.eventSink(UpdateDeletePDFEvent());
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.file_upload),
                    onPressed: () async {
                      await _selecionarNovoArquivo().then((arq) {
                        pdfLocalPath = arq;
                      });
                      bloc.eventSink(UpdatePDFEvent(pdfLocalPath));
                    },
                  ),
                ]),
            pdfLocalPath == null
                ? Container()
                : Text('Arquivo local: $pdfLocalPath'),
            pdfUrl == null
                ? Text(
                    'Sem arquivo na nuvem',
                    style: PmsbStyles.textoSecundario,
                  )
                : Text(
                    'Arquivo já esta na núvem!',
                    style: PmsbStyles.textoPrimario,
                  ),
          ],
        );
      },
    );
  }

  Future<String> _selecionarNovoArquivo() async {
    try {
      var arquivoPath = await FilePicker.getFilePath(type: FileType.ANY);
      if (arquivoPath != null) {
        return arquivoPath;
      }
    } catch (e) {
      print("Unsupported operation" + e.toString());
    }
    return null;
  }
}
