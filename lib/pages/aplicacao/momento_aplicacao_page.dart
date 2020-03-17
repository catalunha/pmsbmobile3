import 'package:flutter/material.dart';
import 'package:pmsbmibile3/bootstrap.dart';
import 'package:pmsbmibile3/components/default_scaffold.dart';
import 'package:pmsbmibile3/components/preambulo.dart';
import 'package:pmsbmibile3/models/models.dart';
import 'package:pmsbmibile3/pages/aplicacao/momento_aplicacao_page_bloc.dart';
import 'package:pmsbmibile3/state/auth_bloc.dart';
import 'package:pmsbmibile3/pages/page_arguments.dart';
import 'package:pmsbmibile3/style/pmsb_colors.dart';
import 'package:pmsbmibile3/style/pmsb_styles.dart';

class MomentoAplicacaoPage extends StatefulWidget {
  final String usuarioID;
  final String questionarioAplicadoID;
  final AuthBloc authBloc;

  const MomentoAplicacaoPage(this.authBloc,
      {Key key, this.usuarioID, this.questionarioAplicadoID})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _MomentoAplicacaoPageState();
  }
}

class _MomentoAplicacaoPageState extends State<MomentoAplicacaoPage> {
  final bloc = MomentoAplicacaoPageBloc(Bootstrap.instance.firestore);

  // //TODO: subistituir o preambulo desta pagina
  // final String _eixo = "eixo exemplo";
  // final String _questionario = "questionarios exemplo";
  // final String _local = "local exemplo";
  // final String _setor = "setor exemplo";

  @override
  void initState() {
    super.initState();
    widget.authBloc.perfil.listen((usuario) {
      bloc.dispatch(UpdateUsuarioMomentoAplicacaoPageBlocEvent(usuario));
    });

    bloc.dispatch(
        UpdateIDMomentoAplicacaoPageBlocEvent(widget.questionarioAplicadoID));
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  // _botaoDeletar() {
  //   return SafeArea(
  //       child: Row(
  //     children: <Widget>[
  //       Padding(
  //         padding: EdgeInsets.all(5.0),
  //         child: RaisedButton(
  //           color: Colors.red,
  //           onPressed: () {
  //             bloc.dispatch(DeleteMomentoAplicacaoPageBlocEvent());
  //             Navigator.pop(context);
  //           },
  //           child: Row(
  //             children: <Widget>[
  //               Text('Apagar', style: TextStyle(fontSize: 20)),
  //               Icon(Icons.delete)
  //             ],
  //           ),
  //         ),
  //       ),
  //     ],
  //   ));
  // }

  // _listaDadosSuperior() {
  //   return Column(
  //     children: <Widget>[
  //       Padding(
  //         padding: EdgeInsets.only(top: 5),
  //         child: Text(
  //           "Eixo - $_eixo",
  //           style: TextStyle(fontSize: 16, color: Colors.blue),
  //         ),
  //       ),
  //       Padding(
  //         padding: EdgeInsets.only(top: 5),
  //         child: Text(
  //           "Setor - $_setor",
  //           style: TextStyle(fontSize: 16, color: Colors.blue),
  //         ),
  //       ),
  //       Padding(
  //         padding: EdgeInsets.only(top: 5),
  //         child: Text(
  //           "Questionario - $_questionario",
  //           style: TextStyle(fontSize: 16, color: Colors.blue),
  //         ),
  //       ),
  //       Padding(
  //         padding: EdgeInsets.only(top: 5, bottom: 5),
  //         child: Text(
  //           "Local - $_local",
  //           style: TextStyle(fontSize: 16, color: Colors.blue),
  //         ),
  //       )
  //     ],
  //   );
  // }

  Widget _body(context) {
    return ListView(
      children: <Widget>[
        Preambulo(
          eixo: true,
          setor: true,
          questionarioID: widget.questionarioAplicadoID,
          questionarioAplicado: true,
        ),
        // _listaDadosSuperior(),
        Divider(color: Colors.black87),
        StreamBuilder<MomentoAplicacaoPageBlocState>(
            stream: bloc.state,
            builder: (context, snapshot) {
              if (!snapshot.hasData) return Container();
              final questionario = snapshot?.data?.questionario;
              final nomeQuestionario =
                  questionario?.nome != null ? questionario.nome : "";
              final isBound = snapshot.data.isBound;

              return ListTile(
                trailing: isBound
                    ? null
                    : IconButton(
                        icon: Icon(Icons.search),
                        onPressed: () {
                          bloc.dispatch(
                              CarregarListaQuestionarioMomentoAplicacaoPageBlocEvent());
                          Navigator.pushNamed(
                              context, "/aplicacao/selecionar_questionario",
                              arguments: bloc);
                          //selecionar o questionario
                        }),
                title: isBound
                    ? Text("Escolhido: ${questionario.id}")
                    : Text("Escolha um questionario: "),
                subtitle:
                    Text("$nomeQuestionario", style: TextStyle(fontSize: 18)),
              );
            }),
        Divider(color: Colors.black87),
        Padding(
          padding: EdgeInsets.all(5),
          child: Text(
            "Referencia: Local/Pessoa/Momento na aplicação:",
            style: TextStyle(color: Colors.blue, fontSize: 15),
          ),
        ),
        ReferenciaInput(bloc),
        Divider(color: Colors.black87),
        ListaRequisitos(bloc),
        // _botaoDeletar(),

        Divider(color: Colors.black87),

        ListTile(
          title: Text("Apagar"),
          trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                _apagarAplicacao(context, bloc);
              }),
        ),
        Divider(color: Colors.black87),

        // _DeleteDocumentOrField(bloc),
        Container(
          padding: EdgeInsets.only(top: 80),
        )
      ],
    );
  }

  void _apagarAplicacao(context, MomentoAplicacaoPageBloc bloc) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(child: _DeleteDocumentOrField(bloc));
        });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultScaffold(
      title: Text("Local/Pessoa/Momento de aplicação"),
      // appBar: AppBar(
      //   centerTitle: true,
      //   title: Text("Local/Pessoa/Momento de aplicação"),
      // ),
      body: _body(context),
      floatingActionButton: StreamBuilder<MomentoAplicacaoPageBlocState>(
          stream: bloc.state,
          builder: (context, snapshot) {
            if (!snapshot.hasData) return Container();

            return FloatingActionButton(
              onPressed: snapshot.data.isValid
                  ? () {
                      //salvar e voltar
                      bloc.dispatch(SaveMomentoAplicacaoPageBlocEvent());
                      Navigator.pop(context);
                    }
                  : null,
              child: Icon(Icons.thumb_up),
              backgroundColor:
                  snapshot.data.isValid ? PmsbColors.cor_destaque : Colors.grey,
            );
          }),
    );
  }
}

class _DeleteDocumentOrField extends StatefulWidget {
  final MomentoAplicacaoPageBloc bloc;

  _DeleteDocumentOrField(this.bloc);

  @override
  _DeleteDocumentOrFieldState createState() {
    return _DeleteDocumentOrFieldState(bloc);
  }
}

class _DeleteDocumentOrFieldState extends State<_DeleteDocumentOrField> {
  final _textFieldController = TextEditingController();
  final MomentoAplicacaoPageBloc bloc;

  _DeleteDocumentOrFieldState(this.bloc);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<MomentoAplicacaoPageBlocState>(
      stream: bloc.state,
      builder: (BuildContext context,
          AsyncSnapshot<MomentoAplicacaoPageBlocState> snapshot) {
        return Container(
          height: 250,
          color: PmsbColors.fundo,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                SizedBox(height: 20),
                Text(
                    'Para apagar a aplicação digite CONCORDO na caixa de texto abaixo e confirme:  '),
                Divider(),
                Container(
                  child: Flexible(
                    child: TextField(
                      controller: _textFieldController,
                    ),
                  ),
                ),
                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    // Botao de cancelar delete
                    GestureDetector(
                      onTap: () {
                        return;
                      },
                      child: Container(
                        color: Colors.red,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child:
                              Text('Cancelar', style: PmsbStyles.textoPrimario),
                        ),
                      ),
                    ),

                    // Botao de confirmar delete
                    GestureDetector(
                      onTap: () {
                        if (_textFieldController.text == 'CONCORDO') {
                          bloc.dispatch(DeleteMomentoAplicacaoPageBlocEvent());
                          Navigator.of(context).pop();
                        }
                      },
                      child: Container(
                        color: Colors.green,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text('Confirmar',
                              style: PmsbStyles.textoPrimario),
                        ),
                      ),
                    )
                  ],
                ),

                // IconButton(
                //   icon: Icon(Icons.delete),
                //   onPressed: () {
                //     //Ir para a pagina visuais do produto
                //     if (_textFieldController.text == 'CONCORDO') {
                //       bloc.dispatch(DeleteMomentoAplicacaoPageBlocEvent());
                //       Navigator.of(context).pop();
                //     }
                //   },
                // )
              ],
            ),
          ),
        );
      },
    );
  }
}

class ListaRequisitos extends StatelessWidget {
  final MomentoAplicacaoPageBloc bloc;

  const ListaRequisitos(this.bloc, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<MomentoAplicacaoPageBlocState>(
      stream: bloc.state,
      builder: (context, snapshot) {
        if (!snapshot.hasData || !snapshot.data.isBound)
          return Center(
            child: Text("Escolher requisitos depois de salvar"),
          );
        final requisitos = snapshot?.data?.requisitos;
        final requisitosMap = requisitos != null ? requisitos : {};
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              title: Text("Lista de referencias:"),
            ),
            ...requisitosMap
                .map(
                  (k, r) {
                    return MapEntry(
                      k,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          FlatButton(
                            child: Row(
                              children: <Widget>[
                                Text(
                                  "${r.referencia}",
                                  style: TextStyle(fontSize: 15),
                                ),
                                Icon(Icons.search),
                              ],
                            ),
                            onPressed: () {
                              Navigator.pushNamed(
                                  context, '/aplicacao/definir_requisitos',
                                  arguments: DefinirRequisitosPageArguments(
                                      bloc,
                                      r.referencia,
                                      k,
                                      snapshot.data.requisitosSelecionados[k]));
                            },
                          ),
                          snapshot.data.requisitosSelecionados.containsKey(k)
                              ? Icon(
                                  Icons.check,
                                  color: Colors.green,
                                )
                              : Icon(
                                  Icons.check,
                                  color: Colors.red,
                                ),
                        ],
                      ),
                    );
                  },
                )
                .values
                .toList(),
            Divider(color: Colors.black87),
          ],
        );
      },
    );
  }
}

class ReferenciaInput extends StatefulWidget {
  final MomentoAplicacaoPageBloc bloc;

  const ReferenciaInput(this.bloc, {Key key}) : super(key: key);

  @override
  _ReferenciaInput createState() {
    return _ReferenciaInput();
  }
}

class _ReferenciaInput extends State<ReferenciaInput> {
  final _controller = TextEditingController();
  bool initial = true;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<MomentoAplicacaoPageBlocState>(
      stream: widget.bloc.state,
      builder: (context, snapshot) {
        if (initial &&
            _controller.text.isEmpty &&
            snapshot.hasData &&
            snapshot.data.referencia != null) {
          initial = false;
          _controller.text = snapshot.data.referencia;
        }
        return Padding(
          padding: EdgeInsets.all(5.0),
          child: TextField(
            controller: _controller,
            onChanged: (text) {
              widget.bloc.dispatch(
                  UpdateReferenciaMomentoAplicacaoPageBlocEvent(text));
            },
            keyboardType: TextInputType.multiline,
            maxLines: null,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
            ),
          ),
        );
      },
    );
  }
}
