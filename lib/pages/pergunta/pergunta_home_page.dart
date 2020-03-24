import 'package:flutter/material.dart';
import 'package:pmsbmibile3/bootstrap.dart';
import 'package:pmsbmibile3/components/preambulo.dart';
import 'package:pmsbmibile3/models/pergunta_model.dart';
import 'package:pmsbmibile3/pages/pergunta/pergunta_home_page_bloc.dart';
import 'package:pmsbmibile3/pages/page_arguments.dart'
    show EditarApagarPerguntaPageArguments;
import 'package:pmsbmibile3/style/pmsb_colors.dart';
import 'package:pmsbmibile3/style/pmsb_styles.dart';

class PerguntaHomePage extends StatelessWidget {
  final String _questionarioId;
  final bloc = PerguntaHomePageBloc(Bootstrap.instance.firestore);

  PerguntaHomePage(this._questionarioId) {
    bloc.dispatch(
        UpdateQuestionarioIdPerguntaHomePageBlocEvent(_questionarioId));
  }

  void dispose() {
    bloc.dispose();
  }

  Widget _body(context) {
    return Container(
      color: PmsbColors.fundo,
      child: StreamBuilder<PerguntaHomePageBlocState>(
        stream: bloc.state,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text("ERROR"),
            );
          }
          if (!snapshot.hasData) {
            return Center(
              child: Text("SEM DADOS"),
            );
          }
          final ups = snapshot.data.ups;
          final downs = snapshot.data.downs;
          final perguntas =
              snapshot.data.perguntas != null ? snapshot.data.perguntas : [];
          return Column(
            children: <Widget>[
              Preambulo(
                eixo: true,
                setor: true,
                questionarioID: _questionarioId,
              ),
              Expanded(
                //flex: 12,
                //TODO: Trocar list view por ReordenableList
                child: ListView(
                  children: [
                    //TODO: ToList gerou incompatibilidade com Reordenable, verificar solucao
                    ...perguntas
                        .asMap()
                        .map((index, pergunta) => MapEntry(
                            index,
                            PerguntaItem(
                              ValueKey("value$index"),
                              pergunta,
                              ups[pergunta.id],
                              downs[pergunta.id],
                              bloc,
                              index: index,
                            )))
                        .values
                        .toList(),
                    Padding(padding: EdgeInsets.all(40)),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: PmsbColors.fundo,
        bottomOpacity: 0.0,
        elevation: 0.0,
        centerTitle: true,
        title: Text("Lista de perguntas"),
      ),
      body: _body(context),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          //Adicionar um nova pergunta
          Navigator.pushNamed(
            context,
            '/pergunta/criar_editar',
            arguments: EditarApagarPerguntaPageArguments(
                questionarioID: _questionarioId),
          );
        },
        child: Icon(Icons.add, color: Colors.white,),
        backgroundColor: PmsbColors.cor_destaque,
      ),
    );
  }
}

class PerguntaItem extends StatelessWidget {
  final PerguntaModel _pergunta;
  final int index;
  final bool up;
  final bool down;
  final PerguntaHomePageBloc bloc;
  final ValueKey key;

  PerguntaItem(this.key, this._pergunta, this.up, this.down, this.bloc,
      {this.index})
      : assert(up != null),
        assert(down != null);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: PmsbColors.card,
      elevation: 10,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            title: Text(_pergunta.titulo),
            // trailing: Text("${index}"),
            subtitle: Text("Tipo: ${_pergunta.tipo.nome}"),
            // Column(
            //   children: <Widget>[
            //     Text("Tipo: ${_pergunta.tipo.nome}"),
            //     Text("${_pergunta.id}"),
            //     Text("${_pergunta.referencia}"),
            //   ],
            // ),
          ),
          ButtonTheme.bar(
            child: ButtonBar(
              alignment: MainAxisAlignment.center,
              children: <Widget>[
                // IconButton(
                //   tooltip: 'Descer ordem da pergunta',
                //   icon: Icon(Icons.arrow_downward),
                //   onPressed: down
                //       ? () {
                //           //Mover pergunta para baixo na ordem
                //           bloc.dispatch(OrdemPerguntaPerguntaHomePageBlocEvent(
                //               _pergunta.id, false));
                //         }
                //       : null,
                // ),
                // IconButton(
                //   tooltip: 'Subir ordem na pergunta',
                //   icon: Icon(Icons.arrow_upward),
                //   onPressed: up
                //       ? () {
                //           //Mover pergunta para cima na ordem
                //           bloc.dispatch(OrdemPerguntaPerguntaHomePageBlocEvent(
                //               _pergunta.id, true));
                //         }
                //       : null,
                // ),
                IconButton(
                    tooltip: 'Visão geral da pergunta',
                    icon: Icon(Icons.remove_red_eye, color: Colors.pink,),
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        "/pergunta/pergunta_preview",
                        arguments: _pergunta.id,
                      );
                    }),
                IconButton(
                    tooltip: 'Definir Requisitos',
                    icon: Icon(Icons.rotate_90_degrees_ccw, color: Colors.green),
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        "/pergunta/pergunta_requisito",
                        arguments: _pergunta.id,
                      );
                    }),
                IconButton(
                  tooltip: 'Editar esta pergunta',
                  icon: Icon(Icons.edit, color: Colors.blue,),
                  onPressed: () {
                    final result = Navigator.pushNamed(
                      context,
                      "/pergunta/criar_editar",
                      arguments: EditarApagarPerguntaPageArguments(
                        perguntaID: _pergunta.id,
                        questionarioID: _pergunta.questionario.id,
                      ),
                    );

                    //mensagem com resultado da ação
                    result.then((result) {
                      if (result != null && result is String) {
                        final snackBar = SnackBar(content: Text(result));
                        Scaffold.of(context).showSnackBar(snackBar);
                      }
                    });
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

class CardInfo extends StatelessWidget {
  final String info;

  const CardInfo({Key key, this.info}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(5),
        ),
        color: Colors.black12,
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          " ${this.info} ",
          style: PmsbStyles.textStyleListPerfil01,
        ),
      ),
    );
  }
}
