import 'package:flutter/material.dart';
import 'package:pmsbmibile3/bootstrap.dart';
import 'package:pmsbmibile3/components/initial_value_text_field.dart';
import 'package:pmsbmibile3/pages/aplicacao/aplicando_pergunta_page_bloc.dart';
import 'package:pmsbmibile3/pages/aplicacao/pergunta/pergunta.dart';
import 'package:pmsbmibile3/components/preambulo.dart';
import 'package:pmsbmibile3/state/auth_bloc.dart';

class AplicacaoPerguntaPage extends StatefulWidget {
  const AplicacaoPerguntaPage(
      this.authBloc, this.questionarioAplicadoID, this.perguntaID,
      {Key key})
      : assert(questionarioAplicadoID != null),
        super(key: key);

  final String questionarioAplicadoID;
  final String perguntaID;
  final AuthBloc authBloc;

  @override
  _AplicacaoPerguntaPageState createState() => _AplicacaoPerguntaPageState();
}

class _AplicacaoPerguntaPageState extends State<AplicacaoPerguntaPage> {
  final bloc = AplicandoPerguntaPageBloc(Bootstrap.instance.firestore);

  @override
  void initState() {
    super.initState();
    bloc.dispatch(IniciarQuestionarioAplicadoAplicandoPerguntaPageBlocEvent(
        widget.questionarioAplicadoID, widget.perguntaID));
    widget.authBloc.userId.listen((id) {
      bloc.dispatch(UpdateUserIDAplicandoPerguntaPageBlocEvent(id));
    });
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  String _eixo = "eixo exemplo";
  String _questionario = "questionarios exemplo";
  String _local = "local exemplo";
  String _setor = "setor exemplo";

  _botoes() {
    return Row(
      children: <Widget>[
        Expanded(
          flex: 2,
          child: Padding(
            padding: EdgeInsets.all(5),
            child: RaisedButton(
              color: Colors.blue,
              onPressed: () {
                bloc.dispatch(SalvarAplicandoPerguntaPageBlocEvent(false));
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Text('Não Responder', style: TextStyle(fontSize: 20)),
                  Icon(Icons.undo, textDirection: TextDirection.rtl)
                ],
              ),
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: Padding(
            padding: EdgeInsets.all(5),
            child: RaisedButton(
              color: Colors.green,
              onPressed: () {
                bloc.dispatch(SalvarAplicandoPerguntaPageBlocEvent(true));
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Text('Responder', style: TextStyle(fontSize: 20)),
                  Icon(Icons.thumb_up)
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  _listaDadosSuperior() {
    return Preambulo(
      eixo: _eixo,
      setor: _setor,
      questionario: _questionario,
      local: _local,
    );
  }

  Widget _body() {
    return StreamBuilder<AplicandoPerguntaPageBlocState>(
      stream: bloc.state,
      builder: (context, snapshot) {
        if (!snapshot.hasData) return Text("SEM DADOS");
        if (snapshot.data.carregando) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        if (!snapshot.data.perguntasOk) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.data.questionarioFinalizado) {
          return Center(
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(context, "/aplicacao/pendencias",
                    arguments: snapshot.data.questionarioAplicadoID);
              },
              child: Text("Ultima"),
            ),
          );
        }
        return ListView(
          children: <Widget>[
//            _listaDadosSuperior(),
            Divider(height: 50, indent: 5, color: Colors.black54),
            Padding(
                padding: EdgeInsets.all(5),
                child: ListTile(
                  title: Text(snapshot.data.perguntaAtual.titulo),
                  subtitle: Text(snapshot.data.perguntaAtual.textoMarkdown),
                )),
            Text(snapshot.data.perguntaAtual.tipo.nome),
            Divider(color: Colors.black54),
            // Widget de tipo pergunta
            PerguntaAplicada(
                snapshot.data.perguntaAtual, snapshot.data.usuarioID),
            Divider(color: Colors.black54),
            Padding(
                padding: EdgeInsets.all(5),
                child:
                    Text("Observações:", style: TextStyle(color: Colors.blue))),
            Padding(
                padding: EdgeInsets.all(5.0),
                child: InitialValueTextField(
                  id: snapshot.data.perguntaAtual.id,
                  value: snapshot.data.perguntaAtual.observacao,
                  onChanged: (observacao) {
                    bloc.dispatch(
                        UpdateObservacaoAplicandoPerguntaPageBlocEvent(
                            observacao));
                  },
                  initialize: () =>
                      snapshot.data.perguntaAtual.observacao != null
                          ? true
                          : false,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                )),
            Padding(padding: EdgeInsets.all(5)),
            _botoes()
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Aplicando pergunta"),
      ),
      body: _body(),
    );
  }
}
