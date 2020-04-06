import 'package:flutter/material.dart';
import 'package:pmsbmibile3/bootstrap.dart';
import 'package:pmsbmibile3/components/default_scaffold.dart';
import 'package:pmsbmibile3/pages/setor_painel/setor_painel_crud_bloc.dart';
import 'package:pmsbmibile3/state/auth_bloc.dart';
import 'package:pmsbmibile3/style/pmsb_colors.dart';
import 'package:pmsbmibile3/style/pmsb_styles.dart';

class SetorPainelCrudPage extends StatefulWidget {
  final AuthBloc authBloc;
  final String setorCensitarioId;

  const SetorPainelCrudPage(this.authBloc, this.setorCensitarioId);

  _SetorPainelCrudPageState createState() =>
      _SetorPainelCrudPageState(this.authBloc);
}

class _SetorPainelCrudPageState extends State<SetorPainelCrudPage> {
  SetorPainelCrudBloc bloc;
  _SetorPainelCrudPageState(AuthBloc authBloc)
      : bloc = SetorPainelCrudBloc(authBloc, Bootstrap.instance.firestore);
  @override
  void initState() {
    super.initState();
    bloc.eventSink(
        GetSetorCensitarioIDEvent(setorCensitarioId: widget.setorCensitarioId));
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
      title: Text('Editar Item do Painel'),
      floatingActionButton: StreamBuilder<SetorPainelCrudBlocState>(
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
            child: Icon(Icons.check),
            backgroundColor:
                snapshot.data.isDataValid ? PmsbColors.cor_destaque : Colors.grey,
          );
        },
      ),
      body: StreamBuilder<SetorPainelCrudBlocState>(
        stream: bloc.stateStream,
        builder: (BuildContext context,
            AsyncSnapshot<SetorPainelCrudBlocState> snapshot) {
          if (!snapshot.hasData)
            return Center(child: CircularProgressIndicator());
          if (snapshot.data.isDataValid) {
            Widget valor;
            if (snapshot.data?.setorCensitarioPainelID?.painelID?.tipo ==
                'booleano') {
              valor = Center(
                child: SwitchListTile(
                  title: Text('Item atendido ? '),
                  value: snapshot.data?.valor,
                  onChanged: (bool value) {
                    bloc.eventSink(UpdateBooleanoEvent(value));
                  },
                  secondary: Icon(Icons.thumbs_up_down),
                ),
              );
            } else {
              valor = PainelValor(bloc);
            }
            String tipo;
            if (snapshot.data?.setorCensitarioPainelID?.painelID?.tipo ==
                'texto') {
              tipo = 'Informe um texto simples.';
            } else if (snapshot.data?.setorCensitarioPainelID?.painelID?.tipo ==
                'numero') {
              tipo =
                  'Informe um número e se necessário a unidade na observação.';
            } else if (snapshot.data?.setorCensitarioPainelID?.painelID?.tipo ==
                'numero') {
              tipo =
                  'Informe um número e se necessário a unidade na observação.';
            } else if (snapshot.data?.setorCensitarioPainelID?.painelID?.tipo ==
                'booleano') {
              tipo = 'Marque ou desmarque. Se atendido ou não.';
            } else if (snapshot.data?.setorCensitarioPainelID?.painelID?.tipo ==
                'urlimagem') {
              tipo =
                  'Informe o link da imagem. Use o Google Drive do Projeto ou pessoal.';
            } else if (snapshot.data?.setorCensitarioPainelID?.painelID?.tipo ==
                'urlarquivo') {
              tipo =
                  'Informe o link do arquivo. Use o Google Drive do Projeto ou pessoal.';
            }
            return ListView(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    snapshot.data?.setorCensitarioPainelID?.painelID?.nome,
                    style: PmsbStyles.textStyleListPerfil01,
                  ),
                ),
                Divider(),
                Padding(
                  padding: EdgeInsets.all(5.0),
                  child: Text(
                    tipo,
                    style: TextStyle(fontSize: 15, color: Colors.green),
                  ),
                ),
                Padding(padding: EdgeInsets.all(5.0), child: valor),
                Divider(),
                Padding(
                  padding: EdgeInsets.all(5.0),
                  child: Text(
                    "Observações ao informar este valor:",
                    style: PmsbStyles.textoSecundario,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(5.0),
                  child: PainelObservacao(bloc),
                ),
              ],
            );
          } else {
            return Text('Dados inválidos...');
          }
        },
      ),
    );
  }
}

class PainelValor extends StatefulWidget {
  final SetorPainelCrudBloc bloc;
  PainelValor(this.bloc);
  @override
  PainelValorState createState() {
    return PainelValorState(bloc);
  }
}

class PainelValorState extends State<PainelValor> {
  final _textFieldController = TextEditingController();
  final SetorPainelCrudBloc bloc;
  PainelValorState(this.bloc);
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<SetorPainelCrudBlocState>(
      stream: bloc.stateStream,
      builder: (BuildContext context,
          AsyncSnapshot<SetorPainelCrudBlocState> snapshot) {
        if (_textFieldController.text.isEmpty) {
          _textFieldController.text = snapshot.data?.valor;
        }
        return TextField(
          keyboardType: TextInputType.multiline,
          maxLines: null,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
          ),
          controller: _textFieldController,
          onChanged: (text) {
            bloc.eventSink(UpdateValorEvent(text));
          },
        );
      },
    );
  }
}

class PainelObservacao extends StatefulWidget {
  final SetorPainelCrudBloc bloc;
  PainelObservacao(this.bloc);
  @override
  PainelObservacaoState createState() {
    return PainelObservacaoState(bloc);
  }
}

class PainelObservacaoState extends State<PainelObservacao> {
  final _textFieldController = TextEditingController();
  final SetorPainelCrudBloc bloc;
  PainelObservacaoState(this.bloc);
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<SetorPainelCrudBlocState>(
      stream: bloc.stateStream,
      builder: (BuildContext context,
          AsyncSnapshot<SetorPainelCrudBlocState> snapshot) {
        if (_textFieldController.text.isEmpty) {
          _textFieldController.text = snapshot.data?.observacao;
        }
        return TextField(
          keyboardType: TextInputType.multiline,
          maxLines: null,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
          ),
          controller: _textFieldController,
          onChanged: (text) {
            bloc.eventSink(UpdateObservacaoEvent(text));
          },
        );
      },
    );
  }
}
