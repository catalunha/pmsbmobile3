import 'package:flutter/material.dart';
import 'package:pmsbmibile3/bootstrap.dart';
import 'package:pmsbmibile3/components/delete_document.dart';
import 'package:pmsbmibile3/models/setor_censitario_model.dart';
import 'package:pmsbmibile3/pages/checklist/item_resposta_crud_bloc.dart';
import 'package:pmsbmibile3/state/auth_bloc.dart';

class ItemRespostaCRUDPage extends StatefulWidget {
  final AuthBloc authBloc;
  final String itemId;
  final String respostaId;

  const ItemRespostaCRUDPage({
    this.authBloc,
    this.itemId,
    this.respostaId,
  });

  @override
  _ItemRespostaCRUDPageState createState() => _ItemRespostaCRUDPageState();
}

class _ItemRespostaCRUDPageState extends State<ItemRespostaCRUDPage> {
  ItemRespostaCRUDBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = ItemRespostaCRUDBloc(
      Bootstrap.instance.firestore,
      widget.authBloc,
    );
    bloc.eventSink(GetItemEvent(widget.itemId));
    if (widget.respostaId != null)
      bloc.eventSink(GetRespostaEvent(widget.respostaId));
    bloc.eventSink(GetSetorListEvent());
  }

  @override
  void dispose() {
    super.dispose();
    bloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: widget?.respostaId == null
            ? Text('Criar município do item')
            : Text('Atualizar município do item'),
      ),
      floatingActionButton: StreamBuilder<ItemRespostaCRUDBlocState>(
          stream: bloc.stateStream,
          builder: (context, snapshot) {
            if (!snapshot.hasData) return Container();
            return FloatingActionButton(
              onPressed: snapshot.data.isDataValid
                  ? () {
                      bloc.eventSink(SaveEvent());
                      Navigator.pop(context);
                    }
                  : null,
              child: Icon(Icons.cloud_upload),
              backgroundColor:
                  snapshot.data.isDataValid ? Colors.blue : Colors.grey,
            );
          }),
      body: StreamBuilder<ItemRespostaCRUDBlocState>(
        stream: bloc.stateStream,
        builder: (BuildContext context,
            AsyncSnapshot<ItemRespostaCRUDBlocState> snapshot) {
          if (snapshot.hasError) {
            return Text("Existe algo errado! Informe o suporte.");
          }
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          return ListView(
            padding: EdgeInsets.all(5),
            children: <Widget>[
              ListTile(
                subtitle: Text(
                    '${snapshot.data?.item?.indice} - ${snapshot.data?.item?.descricao}'),
              ),
              snapshot.data?.respostaId == null
                  ? _pasta(context)
                  : ListTile(
                      title: widget?.respostaId == null
                          ? Text('Para: escolha logo abaixo')
                          : Text('Para: ${snapshot.data?.resposta?.setor?.nome}'),
                    ),
              Padding(
                  padding: EdgeInsets.all(5.0),
                  child: Text(
                    '* Atende ao Termo Referência:',
                    style: TextStyle(fontSize: 15, color: Colors.blue),
                  )),

              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Radio(
                            value: 'Sim',
                            groupValue: snapshot.data?.atendeTR,
                            onChanged: (radioValue) {
                              bloc.eventSink(UpdateAtendeTREvent(radioValue));
                            },
                          ),
                          Icon(
                            Icons.thumb_up,
                            color: Colors.green,
                          ),
                        ]),
                    Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Radio(
                            value: 'Parcialmente',
                            groupValue: snapshot.data?.atendeTR,
                            onChanged: (radioValue) {
                              bloc.eventSink(UpdateAtendeTREvent(radioValue));
                            },
                          ),
                          Icon(
                            Icons.thumbs_up_down,
                            color: Colors.yellow,
                          ),
                        ]),
                    Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Radio(
                            value: 'Não',
                            groupValue: snapshot.data?.atendeTR,
                            onChanged: (radioValue) {
                              bloc.eventSink(UpdateAtendeTREvent(radioValue));
                            },
                          ),
                          Icon(
                            Icons.thumb_down,
                            color: Colors.red,
                          )
                        ]),
                  ]),
              Padding(
                  padding: EdgeInsets.all(5.0),
                  child: Text(
                    'Link do documento no Google Drive:',
                    style: TextStyle(fontSize: 15, color: Colors.blue),
                  )),
              Padding(
                  padding: EdgeInsets.all(5.0),
                  child: _TextFieldMultiplo(bloc, 'linkDocumento')),

              Padding(
                  padding: EdgeInsets.all(5.0),
                  child: Text(
                    'Comentário:',
                    style: TextStyle(fontSize: 15, color: Colors.blue),
                  )),
              Padding(
                  padding: EdgeInsets.all(5.0),
                  child: _TextFieldMultiplo(bloc, 'comentario')),

              Divider(),
              Padding(
                padding: EdgeInsets.all(5.0),
                child: DeleteDocument(
                  onDelete: () {
                    bloc.eventSink(DeleteDocumentEvent());
                    Navigator.of(context).pop();
                  },
                ),
              ),
              Padding(padding: EdgeInsets.only(top: 100)),
            ],
            // ),
          );
        },
      ),
    );
  }

  _pasta(context) {
    return StreamBuilder<ItemRespostaCRUDBlocState>(
        stream: bloc.stateStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Text('Sem município');
          }
          Widget texto;
          if (snapshot.data.setorDestino == null) {
            texto = Text('Município não selecionado');
          } else {
            texto = Text('${snapshot.data?.setorDestino?.nome}');
          }
          return ListTile(
            title: texto,
            leading: IconButton(
              icon: Icon(Icons.folder),
              onPressed: () {
                showModalBottomSheet(
                    context: context,
                    builder: (BuildContext bc) {
                      return UsuarioListaModalSelect(bloc);
                    });
              },
            ),
          );
        });
  }
}

class _TextFieldMultiplo extends StatefulWidget {
  final ItemRespostaCRUDBloc bloc;
  final String campo;
  _TextFieldMultiplo(
    this.bloc,
    this.campo,
  );
  @override
  _TextFieldMultiploState createState() {
    return _TextFieldMultiploState(
      bloc,
      campo,
    );
  }
}

class _TextFieldMultiploState extends State<_TextFieldMultiplo> {
  final _textFieldController = TextEditingController();
  final ItemRespostaCRUDBloc bloc;
  final String campo;
  _TextFieldMultiploState(
    this.bloc,
    this.campo,
  );
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ItemRespostaCRUDBlocState>(
      stream: bloc.stateStream,
      builder: (BuildContext context,
          AsyncSnapshot<ItemRespostaCRUDBlocState> snapshot) {
        if (_textFieldController.text.isEmpty) {
          if (campo == 'atendeTR') {
            _textFieldController.text = snapshot.data?.atendeTR;
          } else if (campo == 'comentario') {
            _textFieldController.text = snapshot.data?.comentario;
          } else if (campo == 'linkDocumento') {
            _textFieldController.text = snapshot.data?.linkDocumento;
          }
        }
        return TextField(
          keyboardType: TextInputType.multiline,
          maxLines: null,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
          ),
          controller: _textFieldController,
          onChanged: (texto) {
            bloc.eventSink(UpdateTextFieldEvent(campo, texto));
          },
        );
      },
    );
  }
}

/// Selecao de usuario que vao receber alerta
class UsuarioListaModalSelect extends StatefulWidget {
  final ItemRespostaCRUDBloc bloc;

  const UsuarioListaModalSelect(this.bloc);

  @override
  _UsuarioListaModalSelectState createState() =>
      _UsuarioListaModalSelectState(this.bloc);
}

class _UsuarioListaModalSelectState extends State<UsuarioListaModalSelect> {
  final ItemRespostaCRUDBloc bloc;

  _UsuarioListaModalSelectState(this.bloc);

  Widget _listarPasta() {
    return StreamBuilder<ItemRespostaCRUDBlocState>(
      stream: bloc.stateStream,
      builder: (BuildContext context,
          AsyncSnapshot<ItemRespostaCRUDBlocState> snapshot) {
        if (snapshot.hasError)
          return Center(
            child: Text("Erro. Informe ao administrador do aplicativo"),
          );
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.data.setorList == null) {
          return Center(
            child: Text("Nenhum setor encontrada"),
          );
        }
        if (snapshot.data.setorList.isEmpty) {
          return Center(
            child: Text("Vazio."),
          );
        }

        var lista = List<Widget>();
        for (var usuario in snapshot.data.setorList) {
          lista.add(_cardBuild(context, usuario));
        }

        return ListView(
          children: lista,
        );
      },
    );
  }

  Widget _cardBuild(BuildContext context, SetorCensitarioModel setor) {
    return ListTile(
      title: Text('${setor.nome}'),
      leading: IconButton(
        icon: Icon(Icons.check),
        onPressed: () {
          bloc.eventSink(SelectPastaIDEvent(setor));
          Navigator.pop(context);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Escolha um setor"),
      ),
      body: _listarPasta(),
    );
  }
}
