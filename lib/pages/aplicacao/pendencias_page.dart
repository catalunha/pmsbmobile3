import 'package:flutter/material.dart';
import 'package:pmsbmibile3/bootstrap.dart';
import 'package:pmsbmibile3/models/pergunta_model.dart';
import 'package:pmsbmibile3/pages/aplicacao/pendencias_page_bloc.dart';

//Aplicação 03

class PendenciasPage extends StatefulWidget {
  const PendenciasPage(this.questionarioAplicadoID, {Key key})
      : super(key: key);

  final String questionarioAplicadoID;

  @override
  _PendenciasPageState createState() => _PendenciasPageState();
}

class _PendenciasPageState extends State<PendenciasPage> {
  final bloc = PendenciasPageBloc(Bootstrap.instance.firestore);


  @override
  void initState() {
    super.initState();
    bloc.dispatch(UpdateQuestionarioIDPendenciasPageBlocEvent(widget.questionarioAplicadoID));
  }

  List<String> _tipoperguntas = [
    "01 - Pergunta texto",
    "02 - Pergunta imagem",
    "03 - Pergunta numero",
    "04 - Pergunta coordenada",
    "05 - Pergunta escolha unica",
    "06 - Pergunta escolha multipla"
  ];

  String _eixo = "eixo exemplo";
  String _setor = "setor exemplo";
  String _questionario = "questionario exemplo";
  String _local = "local exemplo";

  _listaPerguntas() {
    return StreamBuilder<PendenciasPageBlocState>(
      stream: bloc.state,
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return Center(
            child: Text("SEM DADOS"),
          );
        return ListView(
          children: snapshot.data.perguntas
              .map((pergunta) => PerguntaAplicadaListItem(
                    pergunta,
                    onPressed: () {
                      //bloc.dispatch();
                    },
                  ))
              .toList(),
        );
      },
    );
  }

  _bodyTodos(context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 10),
          child: Text(
            "Eixo : $_eixo",
            style: TextStyle(fontSize: 16, color: Colors.blue),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 10),
          child: Text(
            "Setor censitário: $_setor",
            style: TextStyle(fontSize: 16, color: Colors.blue),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 10),
          child: Text(
            "Questionário: $_questionario",
            style: TextStyle(fontSize: 16, color: Colors.blue),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 10),
          child: Text(
            "Local: $_local",
            style: TextStyle(fontSize: 16, color: Colors.blue),
          ),
        ),
        Expanded(child: _listaPerguntas())
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        actions: <Widget>[],
        centerTitle: true,
        title: Text("Pendências"),
      ),
      body: _bodyTodos(context),
    );
  }
}

class PerguntaAplicadaListItem extends StatelessWidget {
  const PerguntaAplicadaListItem(this._perguntaAplicada,
      {Key key, this.onPressed})
      : super(key: key);

  final void Function() onPressed;

  final PerguntaAplicadaModel _perguntaAplicada;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ListTile(
      title: Text(_perguntaAplicada.titulo),
      trailing: IconButton(
        icon: Icon(Icons.check),
        onPressed: onPressed,
      ),
    );
  }
}
