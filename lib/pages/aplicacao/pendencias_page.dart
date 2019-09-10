import 'package:flutter/material.dart';
import 'package:pmsbmibile3/bootstrap.dart';
import 'package:pmsbmibile3/components/preambulo.dart';
import 'package:pmsbmibile3/models/pergunta_model.dart';
import 'package:pmsbmibile3/pages/aplicacao/pendencias_page_bloc.dart';
import 'package:pmsbmibile3/pages/page_arguments.dart';
import 'package:pmsbmibile3/pages/aplicacao/requisito_list_item_bloc.dart';

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
        Preambulo(
          eixo: true,
          setor: true,
          questionarioID: widget.questionarioAplicadoID,
          questionarioAplicado: true,
          referencia: true,
        ),
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
        title: Text("Resumo"),
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
                      child: ListView(
                        children: <Widget>[
                          ListTile(
                            title: Text("Requisitos"),
                          ),
                          for (var item in _perguntaAplicada.requisitos.entries)
                            RequisitoListItem(item.value),
                          FlatButton(
                            child: Text("OK"),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
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

class RequisitoListItem extends StatefulWidget {
  final Requisito requisito;

  const RequisitoListItem(this.requisito, {Key key}) : super(key: key);

  @override
  _RequisitoListItemState createState() {
    return _RequisitoListItemState();
  }
}

class _RequisitoListItemState extends State<RequisitoListItem> {
  RequisitoListItemBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc =
        RequisitoListItemBloc(Bootstrap.instance.firestore, widget.requisito);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<PerguntaAplicadaModel>(
      stream: bloc.state,
      builder: (context, snap) {
        if (snap.hasError) {
          return Center(
            child: Text("ERROR"),
          );
        }
        if (!snap.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        bool vencido = false;
        if (widget.requisito.escolha == null) {
          vencido = snap.data.foiRespondida;
        } else {
          vencido = snap.data.escolhas[widget.requisito.escolha.id].marcada ==
              widget.requisito.escolha.marcada;
        }
        return Container(
          padding: EdgeInsets.all(4),
          child: Column(
            children: <Widget>[
              ListTile(
                title: Text("${snap.data.questionario.nome}"),
                subtitle: Text("QuestID: ${snap.data.questionario.id}"),
              ),
              ListTile(
                title: Text("${snap.data.questionario.referencia}"),
                subtitle: Text("Referencia"),
              ),
              ListTile(
                title: Text("${snap.data.titulo}"),
                subtitle: Text("PergID: ${widget.requisito.perguntaID}"),
              ),
              ListTile(
                title: Text(widget.requisito.perguntaTipo),
                subtitle: Text("Tipo de pergunta"),
              ),
              if (widget.requisito.escolha != null)
                ListTile(
                  subtitle: Text(
                      "Esta escolha marcada como: ${widget.requisito.escolha.marcada}"),
                  title: Text(
                      "${snap.data.escolhas[widget.requisito.escolha.id].texto}"),
                ),
              ListTile(
                title: Text(widget.requisito.referencia),
                subtitle: Text("Referencia id"),
              ),
              Icon(
                vencido ? Icons.check : Icons.close,
                color: vencido ? Colors.green : Colors.red,
              ),
              Divider(),
            ],
          ),
        );
      },
    );
  }
}
