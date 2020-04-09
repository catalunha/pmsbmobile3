import 'package:flutter/material.dart';
import 'package:pmsbmibile3/bootstrap.dart';
import 'package:pmsbmibile3/components/default_scaffold.dart';
import 'package:pmsbmibile3/components/initial_value_text_field.dart';
import 'package:pmsbmibile3/pages/aplicacao/aplicando_pergunta_page_bloc.dart';
import 'package:pmsbmibile3/pages/aplicacao/pergunta/pergunta.dart';
import 'package:pmsbmibile3/components/preambulo.dart';
import 'package:pmsbmibile3/state/auth_bloc.dart';
import 'package:pmsbmibile3/style/pmsb_styles.dart';

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

  // String _eixo = "eixo exemplo";
  // String _questionario = "questionarios exemplo";
  // String _local = "local exemplo";
  // String _setor = "setor exemplo";

  _botoes() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Container(
          height: 45.0,
          child: GestureDetector(
            onTap: () {
              bloc.dispatch(SalvarAplicandoPerguntaPageBlocEvent(false));
            },
            child: Container(
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
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Container(
                constraints: BoxConstraints(maxWidth: 170.0, minHeight: 50.0),
                // onPressed: () {
                //bloc.dispatch(SalvarAplicandoPerguntaPageBlocEvent(false));
                //},
                alignment: Alignment.center,
                child: Text(
                  'Não responder',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                ),
              ),
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Container(
              height: 45.0,
              child: GestureDetector(
                onTap: () {
                  bloc.dispatch(SalvarAplicandoPerguntaPageBlocEvent(true));
                },
                child: Container(
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
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Container(
                    constraints:
                        BoxConstraints(maxWidth: 170.0, minHeight: 50.0),
                    // onPressed: () {
                    //bloc.dispatch(SalvarAplicandoPerguntaPageBlocEvent(false));
                    //},
                    alignment: Alignment.center,
                    child: Text(
                      'Responder',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  _listaDadosSuperior() {
    return Preambulo(
      eixo: true,
      setor: true,
      questionarioID: widget.questionarioAplicadoID,
      questionarioAplicado: true,
      referencia: true,
    );
  }

  Widget _body() {
    return StreamBuilder<AplicandoPerguntaPageBlocState>(
      stream: bloc.state,
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return Text(
            "SEM DADOS",
            style: PmsbStyles.textoSecundario,
          );
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
              child: Text(
                "Você alcançou o fim do questionário!\n Clique aqui para ir ao resumo",
                style: TextStyle(
                  fontSize: 19,
                ),
              ),
            ),
          );
        }
        return ListView(
          children: <Widget>[
            _listaDadosSuperior(),
            //Divider(height: 50, indent: 5, color: Colors.black54),
            Padding(
              padding: EdgeInsets.all(5),
              child: ListTile(
                title: Text(snapshot.data.perguntaAtual.titulo),
                subtitle: Text(snapshot.data.perguntaAtual.textoMarkdown),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(snapshot.data.perguntaAtual.tipo.nome),
            ),
            // Divider(color: Colors.black54),
            // Widget de tipo pergunta
            PerguntaAplicada(
                snapshot.data.perguntaAtual, snapshot.data.usuarioID),
            Padding(padding: EdgeInsets.all(5)),
            // Divider(color: Colors.black54),
            Padding(
                padding: EdgeInsets.all(15),
                child: Text("Observações: ", style: PmsbStyles.textoPrimario)),
            Padding(
              padding: EdgeInsets.all(5.0),
              child: InitialValueTextField(
                id: snapshot.data.perguntaAtual.id,
                value: snapshot.data.perguntaAtual.observacao,
                onChanged: (observacao) {
                  bloc.dispatch(
                    UpdateObservacaoAplicandoPerguntaPageBlocEvent(observacao),
                  );
                },
                initialize: () => snapshot.data.perguntaAtual.observacao != null
                    ? true
                    : false,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(30),
            ),
            _botoes()
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultScaffold(
      backToRootPage: false,
      title: Text("Aplicando Pergunta"),
      body: _body(),
    );
  }
}
