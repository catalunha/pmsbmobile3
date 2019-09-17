import 'package:flutter/material.dart';
import 'package:pmsbmibile3/bootstrap.dart';
import 'package:pmsbmibile3/pages/controle/controle_acao_marcar_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

class ControleAcaoMarcarPage extends StatefulWidget {
  final String controleTarefaID;

  const ControleAcaoMarcarPage(this.controleTarefaID);

  @override
  _ControleAcaoMarcarPageState createState() => _ControleAcaoMarcarPageState();
}

class _ControleAcaoMarcarPageState extends State<ControleAcaoMarcarPage> {
  ControleAcaoMarcarBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = ControleAcaoMarcarBloc(Bootstrap.instance.firestore);
    bloc.eventSink(UpdateTarefaIDEvent(widget.controleTarefaID));
  }

  @override
  void dispose() {
    super.dispose();
    bloc.dispose();
  }

  _bodyDestinatario(context) {
    return StreamBuilder<ControleAcaoMarcarBlocState>(
      stream: bloc.stateStream,
      builder: (BuildContext context,
          AsyncSnapshot<ControleAcaoMarcarBlocState> snapshot) {
        if (snapshot.hasError) {
          return Text("ERROR");
        }
        if (!snapshot.hasData) {
          return Text("SEM DADOS");
        }
        if (snapshot.hasData) {
          if (snapshot.data.isDataValid) {
            List<Widget> listaWdg = List<Widget>();
            for (var controleAcaoID in snapshot.data.controleAcaoList) {
              listaWdg.add(Column(children: <Widget>[
                ListTile(
                    title: Text('${controleAcaoID.nome}'),
                    subtitle: Text('Obs: ${controleAcaoID.observacao}\nAtualizada: ${controleAcaoID.modificada}')),
                Wrap(alignment: WrapAlignment.center, children: <Widget>[
                  controleAcaoID.url.isNotEmpty
                      ? IconButton(
                          tooltip: 'Ver arquivo',
                          icon: Icon(Icons.cloud),
                          onPressed: () {
                            launch(controleAcaoID.url);
                          },
                        )
                      : Container(),
                  IconButton(
                    tooltip: 'Editar Url e Observações',
                    icon: Icon(Icons.note_add),
                    onPressed: () {},
                  ),
                  IconButton(
                    tooltip: 'Marcar como feita.',
                    icon: controleAcaoID.concluida
                        ? Icon(Icons.check_box)
                        : Icon(Icons.check_box_outline_blank),
                    onPressed: () {
                      bloc.eventSink(UpdateAcaoEvent(
                          controleAcaoID.id, controleAcaoID.concluida));
                    },
                  ),
                ])
              ]));
            }
            print(listaWdg.toString());
            var controleTarefaID = snapshot.data.controleTarefaDestinatario;
            return Column(children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                      flex: 10,
                      child: Text(
                          'Município:${controleTarefaID.setor.nome}\nNome:${controleTarefaID.nome}\nDe: ${controleTarefaID.remetente.nome}\nInicio: ${controleTarefaID.inicio}\nFim: ${controleTarefaID.fim}\nConcluida: ${controleTarefaID.acaoCumprida} de ${controleTarefaID.acaoTotal}')),
                ],
              ),
              Divider(),
              Expanded(
                flex: 10,
                child: ListView(
                  children: listaWdg,
                ),
              )
            ]);
          } else {
            return Text('Existem dados inválidos...');
          }
          // return Text("listando acao...");
        }
        return Text("Algo não esta certo...");
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editando a tarefa'),
      ),
      body: _bodyDestinatario(context),

      // ),
    );
  }
}
