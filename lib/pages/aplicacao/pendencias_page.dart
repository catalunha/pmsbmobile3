import 'package:flutter/material.dart';
import 'package:pmsbmibile3/bootstrap.dart';
import 'package:pmsbmibile3/models/pergunta_model.dart';
import 'package:pmsbmibile3/pages/aplicacao/pendencias_page_bloc.dart';
import 'package:pmsbmibile3/pages/page_arguments.dart';

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
    bloc.dispatch(UpdateQuestionarioIDPendenciasPageBlocEvent(
        widget.questionarioAplicadoID));
  }

  //TODO: substituir o preambulo desta pagina
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
                      Navigator.pushNamed(
                          context, "/aplicacao/aplicando_pergunta",
                          arguments: AplicandoPerguntaPageArguments(
                              widget.questionarioAplicadoID,
                              perguntaID: pergunta.id));
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
        //TODO: Preambulo()
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
//        Padding(
//          padding: EdgeInsets.only(top: 10),
//          child: Text(
//            "Questionário: $_questionario",
//            style: TextStyle(fontSize: 16, color: Colors.blue),
//          ),
//        ),
//        Padding(
//          padding: EdgeInsets.only(top: 10),
//          child: Text(
//            "Local: $_local",
//            style: TextStyle(fontSize: 16, color: Colors.blue),
//          ),
//        ),
        Expanded(
          child: _listaPerguntas(),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
    return Column(
      children: <Widget>[
        ListTile(
          title: Text(_perguntaAplicada.titulo),
          // trailing: IconButton(
          //   tooltip: 'Pergunta pode ser respondida ?',
          //   //Sim.
          //   //Nao. Pois tem pendencia e podem ser:
          //   //- tem req e nao foi especificada a pergunta req
          //   //- se tem o req ele pode nao ter sido atendido.
          //   icon: _perguntaAplicada.temPendencias
          //       ? Icon(Icons.clear, color: Colors.red)
          //       : Icon(Icons.check, color: Colors.green),
          //   onPressed: _perguntaAplicada.temPendencias ? null : onPressed,
          // ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              IconButton(
                tooltip: 'Pergunta pode ser respondida ?',
                icon: _perguntaAplicada.temPendencias
                    ? Icon(Icons.clear, color: Colors.red)
                    : Icon(Icons.check, color: Colors.green),
                onPressed: _perguntaAplicada.temPendencias ? null : onPressed,
              ),
              if (_perguntaAplicada.foiRespondida)
                IconButton(
                  tooltip: 'Pergunta foi respondida ?',
                  icon: Icon(Icons.thumb_up, color: Colors.green),
                  onPressed: () {},
                )
              else
                IconButton(
                  tooltip: 'Pergunta foi respondida ?',
                  icon: Icon(Icons.thumb_down),
                  onPressed: () {},
                ),
              if (!_perguntaAplicada.foiRespondida &&
                  _perguntaAplicada.temRespostaValida)
                IconButton(
                  tooltip:
                      'Pergunta não foi respondida e tem informação válida ?',
                  icon: Icon(Icons.thumbs_up_down),
                  onPressed: () {},
                )
              else
                IconButton(
                    tooltip:
                        'Pergunta não foi respondida e tem informação válida ?',
                    icon: Icon(Icons.thumb_down),
                    onPressed: () {}),
              IconButton(
                tooltip: 'Requisitos definidos ?',
                icon: Icon(
                  Icons.rotate_90_degrees_ccw,
                  color: _perguntaAplicada.referenciasRequitosDefinidas
                      ? Colors.green
                      : Colors.red,
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => Dialog(
                      elevation: 5,
                      child: Column(
                        children: <Widget>[
                          Text("Requisitos"),
                          for (var item in _perguntaAplicada.requisitos.entries)
                            RequisitoListItem(item.value)
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class RequisitoListItem extends StatelessWidget {
  final Requisito _requisito;

  const RequisitoListItem(this._requisito, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4),
      child: Column(
        children: <Widget>[
          Text(_requisito.referencia),
          Text("${_requisito.perguntaID}"),
          Text("${_requisito.perguntaTipo}"),
          if (_requisito.escolha != null)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("${_requisito.escolha.id}"),
                Text("${_requisito.escolha.marcada}"),
              ],
            ),
        ],
      ),
    );
  }
}
