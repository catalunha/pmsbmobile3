import 'package:flutter/material.dart';
import 'package:pmsbmibile3/components/default_scaffold.dart';
import 'package:pmsbmibile3/components/preambulo.dart';
import 'package:pmsbmibile3/models/questionario_model.dart';
import 'package:pmsbmibile3/pages/aplicacao/aplicacao_home_page_bloc.dart';
import 'package:pmsbmibile3/bootstrap.dart';
import 'package:pmsbmibile3/pages/page_arguments.dart';
import 'package:pmsbmibile3/state/auth_bloc.dart';
import 'package:pmsbmibile3/style/pmsb_colors.dart';
import 'package:pmsbmibile3/style/pmsb_styles.dart';

class AplicacaoHomePage extends StatefulWidget {
  final AuthBloc authBloc;

  const AplicacaoHomePage(this.authBloc, {Key key}) : super(key: key);

  @override
  _AplicacaoHomePageState createState() {
    return _AplicacaoHomePageState(authBloc);
  }
}

class _AplicacaoHomePageState extends State<AplicacaoHomePage> {
  final String _eixo = "eixo exemplo";
  final String _setor = "setor exemplo";
  final AplicacaoHomePageBloc bloc =
      AplicacaoHomePageBloc(Bootstrap.instance.firestore);
  final AuthBloc authBloc;

  _AplicacaoHomePageState(this.authBloc);

  @override
  void initState() {
    super.initState();
    authBloc.perfil.listen((usuario) {
      bloc.dispatch(UpdateUserIDAplicacaoHomePageBlocEvent(usuario));
    });
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  _listaQuestionarioAplicado() {
    return StreamBuilder<AplicacaoHomePageBlocState>(
      stream: bloc.state,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text("ERROR");
        }
        if (!snapshot.hasData) {
          return Text("SEM DADOS");
        }
        final questionarios = snapshot.data.questionariosAplicados != null
            ? snapshot.data.questionariosAplicados
            : [];
        var list = questionarios.map((q) => QuestionarioAplicadoItem(q));
        return ListView(children: [
          ...list.toList(),
          Container(
            padding: EdgeInsets.only(top: 80),
          )
        ]);
      },
    );
  }

  _bodyTodos() {
    return Container(
      color: PmsbColors.fundo,
      child: Column(
        children: <Widget>[
          Preambulo(
            eixo: true,
            setor: true,
          ),
          Expanded(child: _listaQuestionarioAplicado())
        ],
      ),
    );
  }

  _bodyArvore() {
    return Container(
      child: Center(
        child: Text(
          "Em construção",
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultScaffold(
      backToRootPage: false,
      title: Text('Aplicando Questionário'),
      body: _bodyTodos(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: PmsbColors.cor_destaque,
        child: Icon(Icons.add),
        onPressed: () {
          // Adicionar novo questionario aplicado
          Navigator.pushNamed(context, "/aplicacao/momento_aplicacao");
        },
      ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

class CardText extends StatelessWidget {
  final String text;

  const CardText(this.text, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 5),
      child: Text(
        text,
        style: TextStyle(fontSize: 15),
      ),
    );
  }
}

class QuestionarioAplicadoItem extends StatelessWidget {
  final QuestionarioAplicadoModel _questionario;

  const QuestionarioAplicadoItem(this._questionario, {Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: PmsbColors.card,
      elevation: 10,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // CardText("QuestionarioId: ${_questionario.id}"),
          Padding(
            padding: const EdgeInsets.only(bottom: 8, top: 5, left: 8),
            child: Text(
              "Questionario: ${_questionario.nome}",
              style: PmsbStyles.textoPrimario,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Text(
              "Referencia: ${_questionario.referencia}",
              style: PmsbStyles.textoSecundario,
            ),
          ),
          ButtonTheme.bar(
            child: ButtonBar(
              alignment: MainAxisAlignment.center,
              children: <Widget>[
                IconButton(
                  tooltip: 'Aplicando perguntas',
                  icon: Icon(
                    Icons.assignment,
                    color: Colors.pink,
                  ),
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      "/aplicacao/aplicando_pergunta",
                      arguments: AplicandoPerguntaPageArguments(
                        _questionario.id,
                      ),
                    );
                  },
                ),
                IconButton(
                  tooltip: 'Verificando pendencias',
                  icon: Icon(
                    Icons.assignment_turned_in,
                    color: Colors.green,
                  ),
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      "/aplicacao/pendencias",
                      arguments: _questionario.id,
                    );
                  },
                ),
                IconButton(
                  tooltip: 'Editar aplicação',
                  icon: Icon(
                    Icons.edit,
                    color: Colors.blue,
                  ),
                  onPressed: () {
                    // Abrir questionário
                    Navigator.pushNamed(
                      context,
                      "/aplicacao/momento_aplicacao",
                      arguments: _questionario.id,
                    );
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
