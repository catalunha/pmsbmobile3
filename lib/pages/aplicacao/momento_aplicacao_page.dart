import 'package:flutter/material.dart';
import 'package:pmsbmibile3/bootstrap.dart';
import 'package:pmsbmibile3/pages/aplicacao/momento_aplicacao_page_bloc.dart';
import 'package:pmsbmibile3/state/auth_bloc.dart';

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

  final String _eixo = "eixo exemplo";
  final String _questionario = "questionarios exemplo";
  final String _local = "local exemplo";
  final String _setor = "setor exemplo";

  @override
  void initState() {
    super.initState();
    widget.authBloc.perfil.listen((usuario) {
      bloc.dispatch(UpdateUsuarioMomentoAplicacaoPageBlocEvent(usuario));
    });

    bloc.dispatch(
        UpdateIDMomentoAplicacaoPageBlocEvent(widget.questionarioAplicadoID));
  }

  _botaoDeletar() {
    return SafeArea(
        child: Row(
      children: <Widget>[
        Padding(
            padding: EdgeInsets.all(5.0),
            child: RaisedButton(
                color: Colors.red,
                onPressed: () {
                  bloc.dispatch(DeleteMomentoAplicacaoPageBlocEvent());
                  Navigator.pop(context);
                },
                child: Row(
                  children: <Widget>[
                    Text('Apagar', style: TextStyle(fontSize: 20)),
                    Icon(Icons.delete)
                  ],
                ))),
      ],
    ));
  }

  _listaDadosSuperior() {
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 5),
          child: Text(
            "Eixo - $_eixo",
            style: TextStyle(fontSize: 16, color: Colors.blue),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 5),
          child: Text(
            "Setor - $_setor",
            style: TextStyle(fontSize: 16, color: Colors.blue),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 5),
          child: Text(
            "Questionario - $_questionario",
            style: TextStyle(fontSize: 16, color: Colors.blue),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 5, bottom: 5),
          child: Text(
            "Local - $_local",
            style: TextStyle(fontSize: 16, color: Colors.blue),
          ),
        )
      ],
    );
  }

  Widget _body(context) {
    return ListView(
      children: <Widget>[
        _listaDadosSuperior(),
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
                title: isBound ? null : Text("Escolha um questionario: "),
                subtitle:
                    Text("$nomeQuestionario", style: TextStyle(fontSize: 18)),
              );
            }),
        Divider(color: Colors.black87),
        Padding(
            padding: EdgeInsets.all(5),
            child: Text("Referencia: Local/Pessoa/Momento na aplicação:",
                style: TextStyle(color: Colors.blue, fontSize: 15))),
        ReferenciaInput(bloc),
        Divider(color: Colors.black87),
        ListaRequisitos(bloc),
        _botaoDeletar()
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        centerTitle: true,
        title: Text("Local/Pessoa/Momento de aplicação"),
      ),
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
                  snapshot.data.isValid ? Colors.blue : Colors.grey,
            );
          }),
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
              trailing: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    //selecionar requisitos
                    Navigator.pushNamed(
                        context, '/aplicacao/definir_requisitos');
                  }),
              title: Text("Lista de requisitos:"),
            ),
            ...requisitosMap
                .map((k, r) {
                  return MapEntry(
                      k,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          FlatButton(
                            child: Text(
                              "${r.referencia}",
                              style: TextStyle(fontSize: 15),
                            ),
                            onPressed: () {},
                          ),
                          snapshot.data.requisitosSelecionados.containsKey(k)
                              ? Icon(
                                  Icons.check_circle,
                                  color: Colors.blue,
                                )
                              : Icon(
                                  Icons.check_circle_outline,
                                  color: Colors.red,
                                ),
                        ],
                      ));
                })
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
            ));
      },
    );
  }
}
