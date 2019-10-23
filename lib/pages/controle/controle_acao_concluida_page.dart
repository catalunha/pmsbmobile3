import 'package:flutter/material.dart';
import 'package:pmsbmibile3/bootstrap.dart';
import 'package:pmsbmibile3/pages/controle/controle_acao_concluida_bloc.dart';
import 'package:pmsbmibile3/naosuportato/url_launcher.dart'
    if (dart.library.io) 'package:url_launcher/url_launcher.dart';

class ControleAcaoConcluidaPage extends StatefulWidget {
  final String controleTarefaID;

  const ControleAcaoConcluidaPage(this.controleTarefaID);

  @override
  _ControleAcaoConcluidaPageState createState() =>
      _ControleAcaoConcluidaPageState();
}

class _ControleAcaoConcluidaPageState extends State<ControleAcaoConcluidaPage> {
  ControleAcaoConcluidaBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = ControleAcaoConcluidaBloc(Bootstrap.instance.firestore);
    bloc.eventSink(UpdateTarefaIDEvent(widget.controleTarefaID));
  }

  @override
  void dispose() {
    super.dispose();
    bloc.dispose();
  }

  _bodyDestinatario(context) {
    return StreamBuilder<ControleAcaoConcluidaBlocState>(
      stream: bloc.stateStream,
      builder: (BuildContext context,
          AsyncSnapshot<ControleAcaoConcluidaBlocState> snapshot) {
        if (snapshot.hasError) {
          return Text("ERROR");
        }
        if (!snapshot.hasData) {
          return Text("SEM DADOS");
        }
        if (snapshot.hasData) {
          if (snapshot.data.isDataValid) {
            List<Widget> listaWdg = List<Widget>();
            int ordemLocal = 1;

            for (var controleAcaoID in snapshot.data.controleAcaoList) {
              listaWdg.add(Column(children: <Widget>[
                ListTile(
                    trailing: controleAcaoID.concluida
                        ? Text('*  $ordemLocal')
                        : Text('$ordemLocal'),
                    selected: controleAcaoID.concluida,
                    title: Text('${controleAcaoID?.nome}'),
                    subtitle: Text(
                        'Obs: ${controleAcaoID.observacao}\nAtualizada: ${controleAcaoID.modificada}\nid: ${controleAcaoID.id}')),
                Wrap(alignment: WrapAlignment.center, children: <Widget>[
                  controleAcaoID.url != null && controleAcaoID.url != ''
                      ? IconButton(
                          tooltip: 'Ver arquivo',
                          icon: Icon(Icons.cloud),
                          onPressed: () {
                            launch(controleAcaoID.url);
                          },
                        )
                      : Container(),
                ])
              ]));
              ordemLocal++;
            }
            var controleTarefaID = snapshot.data.controleTarefaDestinatario;
            return Column(children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(flex: 10, child: Text('''
  Setor: ${controleTarefaID?.setor?.nome}
  Nome: ${controleTarefaID?.nome}
  De: ${controleTarefaID?.remetente?.nome}
  Para: ${controleTarefaID?.destinatario?.nome}
  Inicio: ${controleTarefaID?.inicio}
  Fim: ${controleTarefaID?.fim}
  Atualizada: ${controleTarefaID?.modificada}
  id: ${controleTarefaID?.id}
  Concluída: ${controleTarefaID?.acaoCumprida} de ${controleTarefaID?.acaoTotal}
                          ''')),
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
        }
        return Text("Algo não esta certo...");
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ver ações'),
      ),
      body: _bodyDestinatario(context),
    );
  }
}
