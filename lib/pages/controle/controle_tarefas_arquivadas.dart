import 'package:flutter/material.dart';
import 'package:pmsbmibile3/components/default_scaffold.dart';
import 'package:pmsbmibile3/models/models_controle/tarefa_model.dart';
import 'package:pmsbmibile3/style/pmsb_colors.dart';
import 'package:pmsbmibile3/widgets/tarefa_card_widget.dart';

class TarefasArquivadasPage extends StatefulWidget {
  final TarefaModel tarefa;

  TarefasArquivadasPage({@required this.tarefa});

  @override
  _TarefasArquivadasPageState createState() => _TarefasArquivadasPageState();
}

class _TarefasArquivadasPageState extends State<TarefasArquivadasPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultScaffold(
      backgroundColor: PmsbColors.navbar,
      backToRootPage: false,
      title: Text("Arquivo do quadro 01"),
      body: body(),
    );
  }

  body() {
    return Container(
      child: Column(
        children: [
          SizedBox(
            height: 30,
          ),
          Container(
            height: 1,
            width: MediaQuery.of(context).size.width * 0.8,
            color: Colors.grey,
          ),
          SizedBox(
            height: 30,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.3),
              child: ListView(
                children: [
                  TarefaCardWidget(
                    arquivado: true,
                    cor: PmsbColors.card,
                    tarefa: widget.tarefa,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
