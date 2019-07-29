import 'package:flutter/material.dart';
import 'package:pmsbmibile3/bootstrap.dart';
import 'package:pmsbmibile3/models/pergunta_model.dart';
import 'package:pmsbmibile3/models/pergunta_tipo_model.dart';
import 'package:pmsbmibile3/pages/aplicacao/aplicando_pergunta_page_bloc.dart';
import 'package:pmsbmibile3/pages/aplicacao/pergunta_widget/pergunta_widget.dart';

class AplicacaoPerguntaPage extends StatefulWidget {
  const AplicacaoPerguntaPage(this.questionarioAplicadoID, {Key key})
      : super(key: key);

  final String questionarioAplicadoID;

  @override
  _AplicacaoPerguntaPageState createState() => _AplicacaoPerguntaPageState();
}

class _AplicacaoPerguntaPageState extends State<AplicacaoPerguntaPage> {
  final bloc = AplicandoPerguntaPageBloc(Bootstrap.instance.firestore);
  TextEditingController _observacoesControler = new TextEditingController();

  @override
  void initState() {
    super.initState();
    bloc.dispatch(UpdateQuestionarioAplicadoIDAplicandoPerguntaPageBlocEvent(
        widget.questionarioAplicadoID));
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
                    color: Colors.green,
                    onPressed: () {
                      bloc.dispatch(PularAplicandoPerguntaPageBlocEvent());
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Text('Pular', style: TextStyle(fontSize: 20)),
                        Icon(Icons.undo, textDirection: TextDirection.rtl)
                      ],
                    )))),
        Expanded(
            flex: 2,
            child: Padding(
                padding: EdgeInsets.all(5),
                child: RaisedButton(
                    color: Colors.blue,
                    onPressed: () {
                      bloc.dispatch(SalvarAplicandoPerguntaPageBlocEvent());
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Text('Salvar', style: TextStyle(fontSize: 20)),
                        Icon(Icons.thumb_up)
                      ],
                    )))),
      ],
    );
  }

  _listaDadosSuperior() {
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 2),
          child: Text(
            "Eixo - $_eixo",
            style: TextStyle(fontSize: 16, color: Colors.blue),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 2),
          child: Text(
            "Setor - $_setor",
            style: TextStyle(fontSize: 16, color: Colors.blue),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 2),
          child: Text(
            "Questionario - $_questionario",
            style: TextStyle(fontSize: 16, color: Colors.blue),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 2, bottom: 5),
          child: Text(
            "Local - $_local",
            style: TextStyle(fontSize: 16, color: Colors.blue),
          ),
        )
      ],
    );
  }

  Widget _body() {
    return StreamBuilder<AplicandoPerguntaPageBlocState>(
      stream: bloc.state,
      builder: (context, snapshot) {
        if (!snapshot.hasData) return Text("SEM DADOS");
        if (!snapshot.data.perguntasOk) {
          return Center(child: CircularProgressIndicator());
        }
        return ListView(
          children: <Widget>[
            _listaDadosSuperior(),
            Divider(height: 50, indent: 5, color: Colors.black54),
            Padding(
                padding: EdgeInsets.all(5),
                child: ListTile(
                  title: Text(snapshot.data.perguntaAtual.titulo),
                  subtitle: Text(snapshot.data.perguntaAtual.textoMarkdown),
                )),
            Divider(color: Colors.black54),
            Padding(
                padding: EdgeInsets.all(5),
                child:
                    Text("Observações:", style: TextStyle(color: Colors.blue))),
            Padding(
                padding: EdgeInsets.all(5.0),
                child: TextField(
                  controller: _observacoesControler,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                )),
            Divider(color: Colors.black54),
            // Widget de tipo pergunta
            PerguntaAplicada(snapshot.data.perguntaAtual),
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
        backgroundColor: Colors.red,
        centerTitle: true,
        title: Text("Aplicando pergunta"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.location_on),
            onPressed: () {
              // ---
            },
          )
        ],
      ),
      body: _body(),
    );
  }
}

class PerguntaAplicada extends StatelessWidget {
  PerguntaAplicada(this.perguntaAplicada, {Key key})
      : assert(perguntaAplicada != null),
        super(key: key);

  final mapaTipoPergunta = MapaPerguntasWidget();
  final PerguntaAplicadaModel perguntaAplicada;

  @override
  Widget build(BuildContext context) {
//    mapaTipoPergunta.getWigetPergunta(
//      tipo: PerguntaTipoModel.ENUM[perguntaAplicada.tipo],
//      entrada: perguntaAplicada,
//    );
    return Center(
      child: Text("Pergutna "),
    );
  }
}
