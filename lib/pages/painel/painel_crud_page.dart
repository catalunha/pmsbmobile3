import 'package:flutter/material.dart';
import 'package:pmsbmibile3/bootstrap.dart';
import 'package:pmsbmibile3/pages/painel/painel_crud_bloc.dart';
import 'package:pmsbmibile3/state/auth_bloc.dart';

class PainelCrudPage extends StatefulWidget {
  final String painelId;
  final AuthBloc authBloc;

  const PainelCrudPage( this.authBloc,this.painelId,);

  _PainelCrudPageState createState() => _PainelCrudPageState(this.authBloc);
}

class _PainelCrudPageState extends State<PainelCrudPage> {
  PainelCrudBloc bloc;
  _PainelCrudPageState(AuthBloc authBloc) : bloc = PainelCrudBloc(Bootstrap.instance.firestore,authBloc);
  @override
  void initState() {
    super.initState();
    bloc.eventSink(GetPainelEvent(painelId: widget.painelId));
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
          title: Text('Editar item do painel'),
        ),
        floatingActionButton: StreamBuilder<PainelCrudBlocState>(
            stream: bloc.stateStream,
            builder: (context, snapshot) {
              if (!snapshot.hasData) return Container();
              return FloatingActionButton(
                onPressed: snapshot.data.isDataValid
                    ? () {
                        //salvar e voltar
                        bloc.eventSink(SaveEvent());
                        Navigator.pop(context);
                      }
                    : null,
                child: Icon(Icons.cloud_upload),
                backgroundColor:
                    snapshot.data.isDataValid ? Colors.blue : Colors.grey,
              );
            }),
        body: StreamBuilder<PainelCrudBlocState>(
            stream: bloc.stateStream,
            builder: (context, snapshot) {
              if (!snapshot.hasData)
                return Center(child: CircularProgressIndicator());
              if (snapshot.hasData) {
                if (snapshot.data.isDataValid) {
                  return ListView(
                    children: <Widget>[
                      Padding(
                          padding: EdgeInsets.all(5.0),
                          child: Text(
                            'Nome do item',
                            style: TextStyle(fontSize: 15, color: Colors.blue),
                          )),
                      Padding(
                          padding: EdgeInsets.all(5.0),
                          child: PainelNome(bloc)),
                      Padding(
                          padding: EdgeInsets.all(5.0),
                          child: Text(
                            "Tipo do item:",
                            style: TextStyle(fontSize: 15, color: Colors.blue),
                          )),
                      Padding(
                        padding: EdgeInsets.all(5.0),
                        child: PainelTipo(bloc),
                      ),
                      Divider(),
                      Padding(
                        padding: EdgeInsets.all(5.0),
                        child: _DeleteDocumentOrField(bloc),
                      ),
                    ],
                  );
                } else {
                  return Text('Dados inválidos...');
                }
              }
            }));
  }
}

class PainelNome extends StatefulWidget {
  final PainelCrudBloc bloc;
  PainelNome(this.bloc);
  @override
  PainelNomeState createState() {
    return PainelNomeState(bloc);
  }
}

class PainelNomeState extends State<PainelNome> {
  final _textFieldController = TextEditingController();
  final PainelCrudBloc bloc;
  PainelNomeState(this.bloc);
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<PainelCrudBlocState>(
      stream: bloc.stateStream,
      builder:
          (BuildContext context, AsyncSnapshot<PainelCrudBlocState> snapshot) {
        if (_textFieldController.text.isEmpty) {
          _textFieldController.text = snapshot.data?.nome;
        }
        return TextField(
          keyboardType: TextInputType.multiline,
          maxLines: null,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
          ),
          controller: _textFieldController,
          onChanged: (text) {
            bloc.eventSink(UpdateNomeEvent(text));
          },
        );
      },
    );
  }
}

class PainelTipo extends StatefulWidget {
  final PainelCrudBloc bloc;
  PainelTipo(this.bloc);
  @override
  PainelTipoState createState() {
    return PainelTipoState(bloc);
  }
}

class PainelTipoState extends State<PainelTipo> {
  final PainelCrudBloc bloc;
  PainelTipoState(this.bloc);
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<PainelCrudBlocState>(
      stream: bloc.stateStream,
      builder:
          (BuildContext context, AsyncSnapshot<PainelCrudBlocState> snapshot) {
        return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              RadioListTile(
                title: Text(
                  'Um texto simples',
                ),
                value: 'texto',
                groupValue: snapshot.data?.tipo,
                onChanged: (radioValue) {
                  bloc.eventSink(UpdateTipoEvent(radioValue));
                },
              ),
              RadioListTile(
                title: Text(
                  'Um número',
                ),
                value: 'numero',
                groupValue: snapshot.data?.tipo,
                onChanged: (radioValue) {
                  bloc.eventSink(UpdateTipoEvent(radioValue));
                },
              ),
              RadioListTile(
                title: Text(
                  'Um link para uma imagem',
                ),
                value: 'urlimagem',
                groupValue: snapshot.data?.tipo,
                onChanged: (radioValue) {
                  bloc.eventSink(UpdateTipoEvent(radioValue));
                },
              ),
              RadioListTile(
                title: Text(
                  'Um link para um arquivo',
                ),
                value: 'urlarquivo',
                groupValue: snapshot.data?.tipo,
                onChanged: (radioValue) {
                  bloc.eventSink(UpdateTipoEvent(radioValue));
                },
              ),
              RadioListTile(
                title: Text(
                  'Marcar Sim ou Não',
                ),
                value: 'booleano',
                groupValue: snapshot.data?.tipo,
                onChanged: (radioValue) {
                  bloc.eventSink(UpdateTipoEvent(radioValue));
                },
              ),
            ]);
      },
    );
  }
}

class _DeleteDocumentOrField extends StatefulWidget {
  final PainelCrudBloc bloc;
  _DeleteDocumentOrField(this.bloc);
  @override
  _DeleteDocumentOrFieldState createState() {
    return _DeleteDocumentOrFieldState(bloc);
  }
}

class _DeleteDocumentOrFieldState extends State<_DeleteDocumentOrField> {
  final _textFieldController = TextEditingController();
  final PainelCrudBloc bloc;
  _DeleteDocumentOrFieldState(this.bloc);
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<PainelCrudBlocState>(
      stream: bloc.stateStream,
      builder:
          (BuildContext context, AsyncSnapshot<PainelCrudBlocState> snapshot) {
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
                  bloc.eventSink(DeleteDocumentEvent());
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
