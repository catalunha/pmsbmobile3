import 'package:flutter/material.dart';
import 'package:pmsbmibile3/models/models_controle/acao_model.dart';
import 'package:pmsbmibile3/style/pmsb_colors.dart';

class AcaoWrapWidget extends StatefulWidget {
  final List<Acao> acoes;

  const AcaoWrapWidget({Key key, @required this.acoes}) : super(key: key);

  @override
  _AcaoWrapWidgetState createState() => _AcaoWrapWidgetState();
}

class _AcaoWrapWidgetState extends State<AcaoWrapWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            textoQuadro("Ações"),
            IconButton(icon: Icon(Icons.add_box), onPressed: () {}),
          ],
        )
      ],
    );
  }

  Widget textoQuadro(String texto) {
    return Padding(
      padding: EdgeInsets.only(top: 15.0, bottom: 15.0, left: 30),
      child: Text(
        texto,
        style: TextStyle(
          color: PmsbColors.texto_secundario,
          fontSize: 18,
        ),
      ),
    );
  }

  gerarListaAcoesWidgets() {
    List<Widget> lista = List<Widget>();
    for(Acao acao in widget.acoes) {
      
    }
  }
}
