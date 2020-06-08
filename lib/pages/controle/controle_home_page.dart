import 'package:flutter/material.dart';
import 'package:pmsbmibile3/components/default_scaffold.dart';
import 'package:pmsbmibile3/models/models_controle/tarefa_model.dart';
import 'package:pmsbmibile3/state/auth_bloc.dart';
import 'package:pmsbmibile3/style/pmsb_colors.dart';
import 'package:pmsbmibile3/widgets/tarefa_card_widget.dart';
// import 'package:pmsbmibile3/naosuportato/url_launcher.dart'
//     if (dart.library.io) 'package:url_launcher/url_launcher.dart';

class ControleTarefaHomePage extends StatefulWidget {
  final AuthBloc authBloc;

  const ControleTarefaHomePage(this.authBloc);

  @override
  _ControleTarefaHomePageState createState() => _ControleTarefaHomePageState();
}

class _ControleTarefaHomePageState extends State<ControleTarefaHomePage> {
  TarefaModel cardModel01 = new TarefaModel(
    descricaoAtividade: "Descrição teste",
    tituloAtividade: "Título do Card 01",
   // publico: true,
  );

  //QuadroModel cardModel02 = new QuadroModel(
   // descricao: "Descrição teste",
   // titulo: "Titulo do Card 02",
   // publico: false,
 // );

  @override
  Widget build(BuildContext context) {
    return DefaultScaffold(
        backToRootPage: true,
        title: Text("Quadro 01"),
        body: Container(
          child: ListView(
            children: [
              TarefaCardWidget(
                altura: 100,
                largura: 50,
                tarefa: cardModel01,
                cor: PmsbColors.card,
              )
            ],
          ),
        ));
  }

//Widget body() {
//return Container();
//}
}
