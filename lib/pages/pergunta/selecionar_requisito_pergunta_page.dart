import 'package:flutter/material.dart';
import 'package:pmsbmibile3/bootstrap.dart';
import 'package:pmsbmibile3/pages/pergunta/editar_apagar_pergunta_page_bloc.dart';
import 'package:pmsbmibile3/pages/pergunta/selecionar_requisito_pergunta_page_bloc.dart';
import 'package:pmsbmibile3/state/auth_bloc.dart';

class SelecionarQuequisitoPerguntaPage extends StatelessWidget {
  final AuthBloc authBloc;
  final EditarApagarPerguntaBloc blocPergunta;
  final SelecionarRequisitoPerguntaPageBloc bloc;

  SelecionarQuequisitoPerguntaPage(this.authBloc, this.blocPergunta)
      : bloc = SelecionarRequisitoPerguntaPageBloc(
            Bootstrap.instance.firestore, authBloc, blocPergunta);

  Widget _body() {
    return StreamBuilder<SelecionarRequisitoPerguntaPageBlocState>(
      stream: bloc.state,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text("ERROR");
        }
        if (!snapshot.hasData) {
          return Text("SEM DADOS");
        }

        final requisitos =
            snapshot.data.requisitos != null ? snapshot.data.requisitos : {};

        final widgetRequisitos = requisitos.map(
          (i, e) {
            return MapEntry(
              i,
              Card(
                child: CheckboxListTile(
                  value: e['checkbox'],
                  title: new Text('${e['pergunta']}'),
                  controlAffinity: ListTileControlAffinity.trailing,
                  onChanged: (bool val) {
                    bloc.dispatch(
                        IndexSelecionarRequisitoPerguntaPageBlocEvent(i, val));
                  },
                ),
              ),
            );
          },
        );
        return ListView(
          children: widgetRequisitos.values.toList(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          automaticallyImplyLeading: true,
          title: Text('Selecionar Requisitos'),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            bloc.dispatch(UpdateRequisitosSelecionarRequisitoPerguntaPageBlocEvent());
            Navigator.pop(context);
          },
          child: Icon(Icons.thumb_up),
          backgroundColor: Colors.blue,
        ),
        body: _body());
  }
}
