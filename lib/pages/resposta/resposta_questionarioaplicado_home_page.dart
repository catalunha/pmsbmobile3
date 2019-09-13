import 'package:flutter/material.dart';
import 'package:pmsbmibile3/components/default_scaffold.dart';
import 'package:pmsbmibile3/models/questionario_model.dart';
import 'package:pmsbmibile3/bootstrap.dart';
import 'package:pmsbmibile3/pages/resposta/resposta_questionarioaplicado_home_bloc.dart';
import 'package:pmsbmibile3/services/gerador_md_service.dart';
import 'package:pmsbmibile3/services/gerador_pdf_service.dart';
import 'package:pmsbmibile3/state/auth_bloc.dart';

class RespostaQuestionarioAplicadoHomePage extends StatefulWidget {
  final AuthBloc authBloc;

  const RespostaQuestionarioAplicadoHomePage(this.authBloc, {Key key})
      : super(key: key);

  @override
  _RespostaQuestionarioAplicadoHomePageState createState() {
    return _RespostaQuestionarioAplicadoHomePageState(authBloc);
  }
}

class _RespostaQuestionarioAplicadoHomePageState
    extends State<RespostaQuestionarioAplicadoHomePage> {
  final RespostaQuestionarioAplicadoHomeBloc bloc;

  _RespostaQuestionarioAplicadoHomePageState(AuthBloc authBloc)
      : bloc = RespostaQuestionarioAplicadoHomeBloc(
            authBloc, Bootstrap.instance.firestore);

  @override
  void initState() {
    super.initState();
    // authBloc.perfil.listen((usuario) {
    //   bloc.dispatch(UpdateUserIDAplicacaoHomePageBlocEvent(
    //       usuario.id, usuario.eixoIDAtual.id));
    // });
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  _listaQuestionarioAplicado() {
    return StreamBuilder<RespostaQuestionarioAplicadoHomeState>(
      stream: bloc.stateStream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text("ERROR");
        }
        if (!snapshot.hasData) {
          return Text("SEM DADOS");
        }
        // print('>>> snapshot.data <<< ${snapshot.data.usuarioModel.nome}');
        // print('>>> snapshot.data <<< ${snapshot.data.usuarioModel.eixoIDAtual.id}');
        // print('>>> snapshot.data <<< ${snapshot.data.usuarioModel.setorCensitarioID.id}');
        final questionarios = snapshot.data.questionariosAplicados != null
            ? snapshot.data.questionariosAplicados
            : [];
        return ListView(
          children:
              questionarios.map((q) => QuestionarioAplicadoItem(bloc,q)).toList(),
        );
      },
    );
  }

  _body() {
    return Column(
      children: <Widget>[
        //TODO: preambulo
//        Padding(
//          padding: EdgeInsets.only(top: 10),
//          child: Text(
//            "Eixo : $_eixo",
//            style: TextStyle(fontSize: 16, color: Colors.blue),
//          ),
//        ),
//        Padding(
//          padding: EdgeInsets.only(top: 10),
//          child: Text(
//            "Setor censitário: $_setor",
//            style: TextStyle(fontSize: 16, color: Colors.blue),
//          ),
//        ),
        Expanded(child: _listaQuestionarioAplicado())
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: DefaultScaffold(
        title: Text('Resposta do questionario'),
        body: _body(),
      ),
    );
  }
}

class _CardText extends StatelessWidget {
  final String text;

  const _CardText(this.text, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 2, left: 5),
      child: Text(
        text,
        // style: TextStyle(fontSize: 15),
      ),
    );
  }
}

class QuestionarioAplicadoItem extends StatelessWidget {
  final QuestionarioAplicadoModel _questionario;
final RespostaQuestionarioAplicadoHomeBloc bloc;
  const QuestionarioAplicadoItem(this.bloc,this._questionario, {Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 10,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // _CardText("id: ${_questionario.id}"),
            _CardText("Questionário: ${_questionario.nome}"),
            _CardText("Referência: ${_questionario.referencia}"),
            _CardText("Aplicador: ${_questionario.aplicador.nome}"),
            _CardText("Aplicado: ${_questionario.aplicado.toDate()}"),
            ButtonTheme.bar(
              child: ButtonBar(
                children: <Widget>[
                  IconButton(
                    tooltip: 'Lista das respostas em PDF',
                    icon: Icon(Icons.picture_as_pdf),
                    onPressed: () async {
                      var mdtext = await GeradorMdService
                          .generateMdFromQuestionarioAplicadoModel(_questionario);
                      GeradorPdfService.generatePdfFromMd(mdtext);
                    },
                  ),
                  IconButton(
                    tooltip: 'Lista das respostas em tela',
                    icon: Icon(Icons.text_fields),
                    onPressed: () {
                      Navigator.pushNamed(context, "/resposta/pergunta",
                          arguments: _questionario.id);
                    },
                  ),                  IconButton(
                    tooltip: 'Google Docs das respostas',
                    icon: Icon(Icons.book),
                    onPressed: () {
                      bloc.eventSink(CreateRelatorioEvent(_questionario));
                    },
                  ),
                ],
              ),
            )
          ],
        ));
  }
}
